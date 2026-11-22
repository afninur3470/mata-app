import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../shared/feedback_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStats(),
                  const SizedBox(height: 24),
                  _buildMenuList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFFFF5722),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Color(0xFFFF5722),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Budi Santoso',
            style: AppTypography.headingH4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Tim Engineer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'budi.santoso@telkomsel.co.id',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      transform: Matrix4.translationValues(0, -30, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('28', 'Tugas Selesai', Icons.task_alt),
          _buildStatItem('94%', 'SLA', Icons.speed),
          _buildStatItem('4.8', 'Rating', Icons.star),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFF5722), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.headingH4.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final menuItems = [
      {'icon': Icons.person_outline, 'label': 'Akun'},
      {'icon': Icons.notifications_outlined, 'label': 'Notifikasi'},
      {'icon': Icons.security_outlined, 'label': 'Keamanan'},
      {'icon': Icons.language_outlined, 'label': 'Bahasa'},
      {'icon': Icons.palette_outlined, 'label': 'Tema'},
      {'icon': Icons.feedback_outlined, 'label': 'Beri Umpan Balik'},
      {'icon': Icons.help_outline, 'label': 'Bantuan'},
      {'icon': Icons.privacy_tip_outlined, 'label': 'Kebijakan Privasi'},
      {'icon': Icons.info_outline, 'label': 'Tentang Aplikasi'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuItems.length + 1,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          indent: 60,
          color: AppColors.border,
        ),
        itemBuilder: (context, index) {
          if (index == menuItems.length) {
            return _buildLogoutItem();
          }
          final item = menuItems[index];
          return _buildMenuItem(
            context,
            item['icon'] as IconData,
            item['label'] as String,
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textMuted),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDark,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textMuted,
      ),
      onTap: () {
        if (label == 'Beri Umpan Balik') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          );
        }
      },
    );
  }

  Widget _buildLogoutItem() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: Text(
        'Logout',
        style: AppTypography.bodyMedium.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
      },
    );
  }
}
