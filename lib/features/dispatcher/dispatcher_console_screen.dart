import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class DispatcherConsoleScreen extends StatefulWidget {
  const DispatcherConsoleScreen({super.key});

  @override
  State<DispatcherConsoleScreen> createState() => _DispatcherConsoleScreenState();
}

class _DispatcherConsoleScreenState extends State<DispatcherConsoleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _vendorRating = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'Dispatcher Console',
          style: AppTypography.headingH6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildQuickActions(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTrackingTab(),
                _buildVendorEvaluationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.edit_document,
              label: 'Input WO',
              color: const Color(0xFF0369A1),
              onTap: () {
                // TODO: Input WO
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.folder_open,
              label: 'Repositori BAUT',
              color: const Color(0xFF0284C7),
              onTap: () {
                // TODO: Open BAUT repository
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.bodySmallMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF0369A1),
        labelColor: const Color(0xFF0369A1),
        unselectedLabelColor: AppColors.textMuted,
        tabs: const [
          Tab(text: 'Tracking On-Air'),
          Tab(text: 'Vendor Evaluation'),
        ],
      ),
    );
  }

  Widget _buildTrackingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeline(),
          const SizedBox(height: 24),
          _buildWorkOrderList(),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline',
            style: AppTypography.headingH6.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          _buildTimelineStep('Handover', true, true),
          _buildTimelineStep('RFI', true, true),
          _buildTimelineStep('On-Air', true, false),
          _buildTimelineStep('BAUT', false, false),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String label, bool isActive, bool isCompleted) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : isActive
                    ? const Color(0xFF0369A1)
                    : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : null,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.bodyMediumMedium.copyWith(
            color: isActive || isCompleted
                ? AppColors.textDark
                : Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkOrderList() {
    final workOrders = [
      {'id': 'WO-2024001', 'title': 'Perbaikan Server A', 'status': 'On-Air'},
      {'id': 'WO-2024002', 'title': 'Maintenance Panel B', 'status': 'RFI'},
      {'id': 'WO-2024003', 'title': 'Instalasi UPS Baru', 'status': 'Handover'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Orders',
          style: AppTypography.headingH6.copyWith(
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        ...workOrders.map((wo) {
          return _buildWorkOrderCard(
            wo['id'] as String,
            wo['title'] as String,
            wo['status'] as String,
          );
        }),
      ],
    );
  }

  Widget _buildWorkOrderCard(String id, String title, String status) {
    Color statusColor;
    switch (status) {
      case 'On-Air':
        statusColor = const Color(0xFF0369A1);
        break;
      case 'RFI':
        statusColor = Colors.orange;
        break;
      case 'Handover':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: AppTypography.bodySmallMedium.copyWith(
                    color: const Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppTypography.bodyMediumMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: AppTypography.bodySmall.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorEvaluationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Penilaian Vendor',
            style: AppTypography.headingH6.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildVendorCard('PT. Teknologi Jaya'),
          const SizedBox(height: 24),
          _buildVendorCard('CV. Solusi Digital'),
        ],
      ),
    );
  }

  Widget _buildVendorCard(String vendorName) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vendorName,
            style: AppTypography.headingH6.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Rating Kinerja',
            style: AppTypography.bodyMediumMedium.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _vendorRating = index + 1;
                  });
                },
                child: Icon(
                  index < _vendorRating ? Icons.star : Icons.star_border,
                  size: 40,
                  color: index < _vendorRating ? Colors.amber : Colors.grey[300],
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Text(
            'Catatan',
            style: AppTypography.bodyMediumMedium.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tulis catatan penilaian...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: AppColors.bg,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Submit evaluation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0369A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Kirim Penilaian',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
