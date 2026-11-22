import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/notification_service.dart';

class NotificationBell extends StatelessWidget {
  final Color? iconColor;
  final VoidCallback? onTap;

  const NotificationBell({
    super.key,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationService>(
      builder: (context, notificationService, child) {
        final unreadCount = notificationService.unreadCount;

        return GestureDetector(
          onTap: onTap ?? () {
            // Navigate to inbox screen
            // context.push('/inbox');
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: iconColor ?? Colors.white,
                size: 24,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
