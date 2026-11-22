import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class BAUTSplitViewScreen extends StatefulWidget {
  const BAUTSplitViewScreen({super.key});

  @override
  State<BAUTSplitViewScreen> createState() => _BAUTSplitViewScreenState();
}

class _BAUTSplitViewScreenState extends State<BAUTSplitViewScreen> {
  final String _selectedWO = 'WO-2024001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          _buildSidebar(),
          _buildWOList(),
          Expanded(
            child: _buildContentArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                'Dispatcher',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildSidebarItem(Icons.dashboard, 'Dashboard', true),
          _buildSidebarItem(Icons.assignment, 'Work Orders', false),
          _buildSidebarItem(Icons.folder, 'Repositori BAUT', false),
          _buildSidebarItem(Icons.people, 'Vendor', false),
          const Spacer(),
          _buildSidebarItem(Icons.settings, 'Pengaturan', false),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0369A1).withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? const Color(0xFF0369A1) : AppColors.textMuted,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTypography.bodySmallMedium.copyWith(
              color: isActive ? const Color(0xFF0369A1) : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWOList() {
    final workOrders = [
      'WO-2024001',
      'WO-2024002',
      'WO-2024003',
      'WO-2024004',
      'WO-2024005',
    ];

    return Container(
      width: 320,
      color: Colors.grey[50],
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Text(
              'Work Orders',
              style: AppTypography.headingH6.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: workOrders.length,
              itemBuilder: (context, index) {
                final wo = workOrders[index];
                final isSelected = _selectedWO == wo;
                return _buildWOItem(wo, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWOItem(String wo, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0369A1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF0369A1) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wo,
            style: AppTypography.bodySmallMedium.copyWith(
              color: isSelected ? Colors.white : const Color(0xFF0369A1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Perbaikan Server A',
            style: AppTypography.bodySmall.copyWith(
              color: isSelected ? Colors.white70 : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    return Row(
      children: [
        Expanded(
          child: _buildPDFViewer(),
        ),
        _buildAICopilotPanel(),
      ],
    );
  }

  Widget _buildPDFViewer() {
    return Container(
      margin: const EdgeInsets.all(16),
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
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Color(0xFF0369A1)),
                const SizedBox(width: 12),
                Text(
                  'BAUT-$_selectedWO.pdf',
                  style: AppTypography.bodyMediumMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 120,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'PDF Viewer',
                    style: AppTypography.headingH4.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dokumen BAUT akan ditampilkan di sini',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAICopilotPanel() {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
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
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF0369A1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB31216), Color(0xFFED1C24)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Si MaTa AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildAIMessage(
                  'Halo! Saya Si MaTa, asisten AI Anda. Saya akan membantu menganalisis dokumen BAUT ini.',
                  true,
                ),
                _buildAIMessage(
                  'Berdasarkan analisis, dokumen ini telah lengkap dengan semua tanda tangan yang diperlukan.',
                  true,
                ),
                _buildAIMessage(
                  'Apakah ada yang ingin Anda tanyakan tentang dokumen ini?',
                  true,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tanya Si MaTa...',
                      hintStyle: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIMessage(String message, bool isAI) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAI ? Colors.white : const Color(0xFF0369A1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: AppTypography.bodySmall.copyWith(
          color: isAI ? AppColors.textDark : Colors.white,
        ),
      ),
    );
  }
}
