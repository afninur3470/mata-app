import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme/app_typography.dart';
import '../core/sync/sync_manager.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncManager>(
      builder: (context, syncManager, child) {
        final status = syncManager.status;
        final retryCount = syncManager.retryCount;

        // Don't show banner when idle or syncing normally
        if (status == SyncStatus.idle || status == SyncStatus.syncing) {
          return const SizedBox.shrink();
        }

        String message;
        Color backgroundColor;
        IconData icon;

        switch (status) {
          case SyncStatus.retrying:
            message = 'Koneksi terputus. Mencoba mengirim ulang data (Percobaan ke-${retryCount + 1})...';
            backgroundColor = Colors.orange;
            icon = Icons.sync;
            break;
          case SyncStatus.failed:
            message = 'Sinkronisasi gagal. Data tersimpan secara lokal.';
            backgroundColor = Colors.red;
            icon = Icons.error_outline;
            break;
          default:
            return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (status == SyncStatus.retrying)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              if (status == SyncStatus.failed)
                TextButton(
                  onPressed: syncManager.flush,
                  child: Text(
                    'Coba Lagi',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
