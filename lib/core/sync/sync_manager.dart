import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SyncManager extends ChangeNotifier {
  static SyncManager? _instance;
  SyncStatus _status = SyncStatus.idle;
  int _retryCount = 0;
  Timer? _retryTimer;
  final SupabaseClient _supabase = Supabase.instance.client;

  static SyncManager get instance {
    _instance ??= SyncManager._internal();
    return _instance!;
  }

  SyncManager._internal();

  SyncStatus get status => _status;
  int get retryCount => _retryCount;

  Future<void> init() async {
    await Hive.initFlutter();
    // Initialize sync queue storage
    await Hive.openBox('sync_queue');
  }

  Future<void> enqueueCheckIn(Map<String, dynamic> data) async {
    final box = Hive.box('sync_queue');
    final operation = SyncOperation(
      table: 'check_ins',
      action: 'insert',
      payload: data,
    );
    await box.add(operation.toJson());
  }

  Future<void> flush() async {
    if (_status == SyncStatus.syncing || _status == SyncStatus.retrying) {
      return;
    }

    _status = SyncStatus.syncing;
    _retryCount = 0;
    notifyListeners();

    await _attemptFlush();
  }

  Future<void> _attemptFlush() async {
    const delays = [0, 5000, 15000, 30000];
    const maxRetries = 3;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        if (attempt > 0) {
          _status = SyncStatus.retrying;
          _retryCount = attempt;
          notifyListeners();

          await Future.delayed(Duration(milliseconds: delays[attempt]));
        }

        debugPrint('Attempting sync...');
        
        final box = Hive.box('sync_queue');
        final operations = box.values.toList();
        
        for (final op in operations) {
          final syncOp = SyncOperation.fromJson(op as Map<String, dynamic>);
          await _syncOperation(syncOp);
        }
        
        await box.clear();

        _status = SyncStatus.idle;
        _retryCount = 0;
        _retryTimer?.cancel();
        notifyListeners();
        return;

      } catch (e) {
        debugPrint('Sync attempt ${attempt + 1} failed: $e');

        final isServerError = e.toString().contains('500') ||
                              e.toString().contains('502') ||
                              e.toString().contains('503') ||
                              e.toString().contains('timeout') ||
                              e.toString().contains('SocketException');

        if (isServerError && attempt < maxRetries) {
          continue;
        } else if (attempt == maxRetries) {
          _status = SyncStatus.failed;
          notifyListeners();

          _retryTimer?.cancel();
          _retryTimer = Timer(const Duration(seconds: 30), () {
            _retryCount = 0;
            flush();
          });
        } else {
          _status = SyncStatus.failed;
          _retryCount = 0;
          notifyListeners();
          return;
        }
      }
    }
  }

  Future<void> _syncOperation(SyncOperation operation) async {
    switch (operation.action) {
      case 'insert':
        await _supabase.from(operation.table).insert(operation.payload);
        break;
      case 'update':
        await _supabase.from(operation.table).update(operation.payload);
        break;
      case 'delete':
        await _supabase.from(operation.table).delete().match(operation.payload as Map<String, Object>);
        break;
    }
  }

  void cancelRetry() {
    _retryTimer?.cancel();
    _status = SyncStatus.idle;
    _retryCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }
}

class SyncOperation {
  final String table;
  final String action;
  final Map<String, dynamic> payload;

  SyncOperation({
    required this.table,
    required this.action,
    required this.payload,
  });

  Map<String, dynamic> toJson() {
    return {
      'table': table,
      'action': action,
      'payload': payload,
    };
  }

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      table: json['table'] as String,
      action: json['action'] as String,
      payload: json['payload'] as Map<String, dynamic>,
    );
  }
}

enum SyncStatus {
  idle,
  syncing,
  retrying,
  failed,
}
