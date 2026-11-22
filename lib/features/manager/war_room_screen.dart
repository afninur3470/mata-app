import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class WarRoomScreen extends StatelessWidget {
  const WarRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1024) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildSidebar(),
        Expanded(
          child: _buildMainContent(),
        ),
        _buildRightPanel(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return const Center(
      child: Text('War Room is available on desktop only'),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: AppColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildLogo(),
          const SizedBox(height: 24),
          _buildRoleBadge(),
          const SizedBox(height: 32),
          _buildNavigation(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.adminPrimary,
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
        border: Border.all(color: AppColors.adminPrimary),
      ),
      child: Text(
        'MANAGER NBAD',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.adminPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    final menuItems = [
      {'icon': Icons.dashboard, 'label': 'War Room', 'active': true},
      {'icon': Icons.task_alt, 'label': 'Tasks', 'active': false},
      {'icon': Icons.approval, 'label': 'Approvals', 'active': false},
      {'icon': Icons.analytics, 'label': 'Analytics', 'active': false},
    ];

    return Column(
      children: menuItems.map((item) {
        return _buildMenuItem(
          item['icon'] as IconData,
          item['label'] as String,
          item['active'] as bool,
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: active ? AppColors.adminPrimary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: active ? AppColors.adminPrimary : AppColors.textMuted,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTypography.bodyMediumMedium.copyWith(
              color: active ? AppColors.adminPrimary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildKPICards(),
            const SizedBox(height: 32),
            _buildCharts(),
            const SizedBox(height: 32),
            _buildFeedbackWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'War Room Dashboard',
          style: AppTypography.headingH2.copyWith(
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Real-time monitoring and task management',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICards() {
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Total Tasks',
            '1,234',
            '+12%',
            Icons.task_alt,
            AppColors.adminPrimary,
            true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'SLA Compliance',
            '94.5%',
            '+2.3%',
            Icons.speed,
            AppColors.success,
            true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'Pending Approval',
            '23',
            '-5%',
            Icons.pending,
            AppColors.warning,
            false,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'Critical Escalations',
            '7',
            '+1',
            Icons.warning_amber_rounded,
            AppColors.danger,
            false,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    String trend,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTypography.headingH2.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? AppColors.success : AppColors.danger,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: AppTypography.bodySmall.copyWith(
                  color: isPositive ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'vs last week',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Row(
      children: [
        Expanded(
          child: _buildBarChart(),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: _buildDonutChart(),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MBB vs FBB Performance',
            style: AppTypography.headingH6.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 85, AppColors.adminPrimary),
                  _buildBarGroup(1, 72, AppColors.adminPrimary),
                  _buildBarGroup(2, 90, AppColors.adminPrimary),
                  _buildBarGroup(3, 78, AppColors.adminPrimary),
                  _buildBarGroup(4, 88, AppColors.adminPrimary),
                  _buildBarGroup(5, 82, AppColors.adminPrimary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('MBB', AppColors.adminPrimary),
              const SizedBox(width: 24),
              _buildLegend('FBB', AppColors.supportPrimary),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 24,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildDonutChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tasks by Status',
            style: AppTypography.headingH6.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 80,
                sections: [
                  PieChartSectionData(
                    value: 45,
                    color: AppColors.success,
                    title: '45%',
                    titleStyle: AppTypography.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: AppColors.adminPrimary,
                    title: '30%',
                    titleStyle: AppTypography.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 15,
                    color: AppColors.warning,
                    title: '15%',
                    titleStyle: AppTypography.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 10,
                    color: AppColors.danger,
                    title: '10%',
                    titleStyle: AppTypography.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Completed', AppColors.success),
              const SizedBox(width: 16),
              _buildLegend('In Progress', AppColors.adminPrimary),
              const SizedBox(width: 16),
              _buildLegend('Pending', AppColors.warning),
              const SizedBox(width: 16),
              _buildLegend('Critical', AppColors.danger),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      width: 320,
      color: AppColors.surface,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Detail',
            style: AppTypography.headingH6.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSLATimer(),
          const SizedBox(height: 24),
          _buildSiteInfo(),
          const SizedBox(height: 24),
          _buildEngineerInfo(),
          const Spacer(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSLATimer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: 0.65,
                    strokeWidth: 8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.warning,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '2:35:00',
                      style: AppTypography.headingH4.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Remaining',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'SLA: 4 hours',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiteInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.adminPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Site Information',
                style: AppTypography.bodyMediumMedium.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Site ID', 'JKT-001234'),
          _buildInfoRow('Site Name', 'Gedung Menara Telkom'),
          _buildInfoRow('Region', 'Jakarta Pusat'),
          _buildInfoRow('Technology', '5G NSA'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmallMedium.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: AppColors.adminPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Assigned Engineer',
                style: AppTypography.bodyMediumMedium.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.adminPrimary,
                radius: 24,
                child: Text(
                  'BS',
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
                      'Budi Santoso',
                      style: AppTypography.bodyMediumMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Senior Engineer',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Approve',
              style: AppTypography.bodyMediumMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Reject',
              style: AppTypography.bodyMediumMedium.copyWith(
                color: AppColors.danger,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Kepuasan User',
                    style: AppTypography.headingH6.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Rata-rata: 4.5/5.0',
                style: AppTypography.bodyMediumMedium.copyWith(
                  color: AppColors.adminPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Feedback Terbaru',
            style: AppTypography.bodySmallMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          _buildFeedbackItem('Budi Santoso', 5, 'Aplikasi sangat membantu pekerjaan lapangan!', '2 jam lalu'),
          const SizedBox(height: 8),
          _buildFeedbackItem('Ahmad Rizky', 4, 'UI intuitif, tapi perlu perbaikan di fitur GPS', '5 jam lalu'),
          const SizedBox(height: 8),
          _buildFeedbackItem('Dewi Sartika', 5, 'Sangat puas dengan fitur eskalasi otomatis', '1 hari lalu'),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(String name, int rating, String feedback, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.adminPrimary.withValues(alpha: 0.1),
            radius: 20,
            child: Text(
              name.split(' ').map((e) => e[0]).take(2).join(),
              style: const TextStyle(
                color: AppColors.adminPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: AppTypography.bodySmallMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 12,
                          color: index < rating ? Colors.amber : Colors.grey[300],
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  feedback,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
