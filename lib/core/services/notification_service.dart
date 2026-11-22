import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final SupabaseClient _supabase = Supabase.instance.client;
  
  StreamSubscription? _notificationSubscription;
  StreamSubscription? _escalationSubscription;
  int _unreadCount = 0;
  String? _currentUserId;

  int get unreadCount => _unreadCount;

  NotificationService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification tapped: ${response.payload}');
      },
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  Future<void> initialize(String userId) async {
    _currentUserId = userId;
    await _loadUnreadCount();
    _startListening();
  }

  Future<void> _loadUnreadCount() async {
    final uid = _currentUserId;
    if (uid == null) return;

    final count = await _supabase
        .from('notifications')
        .select('id')
        .eq('user_id', uid)
        .eq('is_read', false)
        .count();

    _unreadCount = count.count;
    notifyListeners();
  }

  void _startListening() {
    final uid = _currentUserId;
    if (uid == null) return;

    _notificationSubscription = _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .listen((List<Map<String, dynamic>> data) {
      _handleNotificationChanges(data);
    });

    _escalationSubscription = _supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('approval_status', 'pending_manager')
        .listen((List<Map<String, dynamic>> data) {
      _handleEscalationChanges(data);
    });
  }

  void _handleNotificationChanges(List<Map<String, dynamic>> data) {
    for (final row in data) {
      final isRead = row['is_read'] as bool? ?? false;
      if (!isRead) {
        _unreadCount++;
        notifyListeners();
        _showLocalNotification(
          row['title'] as String? ?? 'Notifikasi Baru',
          row['message'] as String? ?? '',
          row['type'] as String?,
        );
      }
    }
  }

  void _handleEscalationChanges(List<Map<String, dynamic>> data) {
    final userRole = _supabase.auth.currentUser?.userMetadata?['role'];
    if (userRole != 'manager' && userRole != 'admin') return;

    for (final task in data) {
      if (task['approval_status'] == 'pending_manager') {
        final cost = (task['escalation_cost'] as num?)?.toInt() ?? 0;
        if (cost > 500000) {
          _showEscalationNotification(task);
        }
      }
    }
  }

  Future<void> _showEscalationNotification(Map<String, dynamic> task) async {
    final engineerName = task['assigned_to_name'] as String? ?? 'Teknisi';
    final site = task['location'] as String? ?? 'Site';
    final cost = (task['escalation_cost'] as num?)?.toInt() ?? 0;

    await _showLocalNotification(
      '⚠ Eskalasi Baru',
      'Teknisi $engineerName mengajukan biaya darurat di $site (Rp$cost). Butuh persetujuan Anda.',
      'escalation',
    );
  }

  Future<void> _showLocalNotification(
    String title,
    String body,
    String? type,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'mata_notifications',
      'MaTa Notifications',
      channelDescription: 'Notifikasi untuk aplikasi MaTa',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: type,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);

    _unreadCount = (_unreadCount > 0) ? _unreadCount - 1 : 0;
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    final uid = _currentUserId;
    if (uid == null) return;

    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', uid)
        .eq('is_read', false);

    _unreadCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _escalationSubscription?.cancel();
    super.dispose();
  }
}
