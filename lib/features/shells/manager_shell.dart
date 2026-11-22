import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class ManagerShell extends StatefulWidget {
  final Widget child;

  const ManagerShell({super.key, required this.child});

  @override
  State<ManagerShell> createState() => _ManagerShellState();
}

class _ManagerShellState extends State<ManagerShell> {
  int _selectedIndex = 0;

  final List<ShellItem> _menuItems = [
    ShellItem(
      icon: Icons.dashboard,
      label: 'War Room',
      route: '/manager/war-room',
    ),
    ShellItem(
      icon: Icons.map,
      label: 'Living Map',
      route: '/manager/living-map',
    ),
    ShellItem(
      icon: Icons.escalator_warning,
      label: 'Eskalasi',
      route: '/manager/escalations',
    ),
    ShellItem(
      icon: Icons.analytics,
      label: 'Analytics',
      route: '/manager/analytics',
    ),
    ShellItem(
      icon: Icons.people,
      label: 'User Management',
      route: '/manager/users',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 24),
          _buildRoleBadge(),
          const SizedBox(height: 32),
          Expanded(child: _buildNavigation()),
          _buildUserSection(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB31216), Color(0xFFED1C24)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'T',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Telkomsel',
            style: AppTypography.headingH6.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'NBAD',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.adminPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Manager',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.adminPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        final item = _menuItems[index];
        final isSelected = _selectedIndex == index;
        return _buildMenuItem(item, isSelected, index);
      },
    );
  }

  Widget _buildMenuItem(ShellItem item, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        context.go(item.route);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.adminPrimary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: isSelected ? AppColors.adminPrimary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              item.label,
              style: AppTypography.bodyMediumMedium.copyWith(
                color: isSelected ? AppColors.adminPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.adminPrimary,
            radius: 24,
            child: Text(
              'M',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manager',
                  style: AppTypography.bodyMediumMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  'manager@telkomsel.co.id',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textMuted),
            onPressed: () {
              // TODO: Logout
            },
          ),
        ],
      ),
    );
  }
}

class ShellItem {
  final IconData icon;
  final String label;
  final String route;

  ShellItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
