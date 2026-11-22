import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class GPSRadarCard extends StatelessWidget {
  final double? distance;
  final bool isWithinRange;

  const GPSRadarCard({
    super.key,
    this.distance,
    this.isWithinRange = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isWithinRange
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.gps_fixed,
                  color: isWithinRange ? AppColors.success : AppColors.warning,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GPS Radar',
                      style: AppTypography.headingH6.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      distance != null
                          ? '${distance!.toStringAsFixed(0)} meter dari lokasi'
                          : 'Mendeteksi lokasi...',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isWithinRange
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isWithinRange ? 'In Range' : 'Out of Range',
                  style: AppTypography.bodySmall.copyWith(
                    color: isWithinRange ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRadarAnimation(),
        ],
      ),
    );
  }

  Widget _buildRadarAnimation() {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radar circles
          _buildRadarCircle(120, 0.1),
          _buildRadarCircle(90, 0.15),
          _buildRadarCircle(60, 0.2),
          _buildRadarCircle(30, 0.25),
          // Center dot
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isWithinRange ? AppColors.success : AppColors.warning,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isWithinRange ? AppColors.success : AppColors.warning)
                      .withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Scanning line
          _buildScanningLine(),
        ],
      ),
    );
  }

  Widget _buildRadarCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: (isWithinRange ? AppColors.success : AppColors.warning)
              .withValues(alpha: opacity),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildScanningLine() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 360),
      duration: const Duration(seconds: 2),
      builder: (context, angle, child) {
        return Transform.rotate(
          angle: angle * 3.14159 / 180,
          child: Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isWithinRange ? AppColors.success : AppColors.warning)
                      .withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
