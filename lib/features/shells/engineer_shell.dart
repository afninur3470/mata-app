import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class EngineerShell extends StatefulWidget {
  final Widget child;

  const EngineerShell({super.key, required this.child});

  @override
  State<EngineerShell> createState() => _EngineerShellState();
}

class _EngineerShellState extends State<EngineerShell> {
  int _selectedIndex = 0;

  final List<ShellItem> _menuItems = [
    ShellItem(
      icon: Icons.home,
      label: 'Home',
      route: '/engineer/home',
    ),
    ShellItem(
      icon: Icons.task_alt,
      label: 'Tasks',
      route: '/engineer/tasks',
    ),
    ShellItem(
      icon: Icons.book,
      label: 'Journal',
      route: '/engineer/journal',
    ),
    ShellItem(
      icon: Icons.inbox,
      label: 'Inbox',
      route: '/engineer/inbox',
    ),
    ShellItem(
      icon: Icons.person,
      label: 'Profile',
      route: '/engineer/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: widget.child,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                context.go(item.route);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: isSelected ? const Color(0xFFFF5722) : AppColors.textMuted,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected ? const Color(0xFFFF5722) : AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
