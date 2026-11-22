import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class EscalationManagementScreen extends StatefulWidget {
  const EscalationManagementScreen({super.key});

  @override
  State<EscalationManagementScreen> createState() => _EscalationManagementScreenState();
}

class _EscalationManagementScreenState extends State<EscalationManagementScreen> {
  bool _isDrawerOpen = false;
  Map<String, dynamic>? _selectedEscalation;

  final List<Map<String, dynamic>> _escalations = [
    {
      'id': 'ESC-001',
      'task': 'WO-2024001',
      'site': 'Gedung Menara Telkom',
      'engineer': 'Budi Santoso',
      'category': 'Teknis',
      'cost': 750000,
      'status': 'Pending',
    },
    {
      'id': 'ESC-002',
      'task': 'WO-2024002',
      'site': 'Gedung A Lantai 2',
      'engineer': 'Ahmad Rizky',
      'category': 'Material',
      'cost': 450000,
      'status': 'Approved',
    },
    {
      'id': 'ESC-003',
      'task': 'WO-2024003',
      'site': 'Site BTS-001',
      'engineer': 'Dewi Sartika',
      'category': 'Logistik',
      'cost': 600000,
      'status': 'Pending',
    },
    {
      'id': 'ESC-004',
      'task': 'WO-2024004',
      'site': 'Gedung B Lantai 3',
      'engineer': 'Eko Prasetyo',
      'category': 'Vendor',
      'cost': 300000,
      'status': 'Rejected',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'Manajemen Eskalasi',
          style: AppTypography.headingH6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB31216), Color(0xFFED1C24)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          _buildDataTable(),
          if (_isDrawerOpen && _selectedEscalation != null)
            _buildRightDrawer(),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Task')),
              DataColumn(label: Text('Site')),
              DataColumn(label: Text('Engineer')),
              DataColumn(label: Text('Kategori')),
              DataColumn(label: Text('Biaya')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: _escalations.map((escalation) {
              final cost = escalation['cost'] as int;
              final isOverLimit = cost > 500000;
              return DataRow(
                onSelectChanged: (selected) {
                  if (selected == true) {
                    setState(() {
                      _selectedEscalation = escalation;
                      _isDrawerOpen = true;
                    });
                  }
                },
                cells: [
                  DataCell(Text(escalation['id'] as String)),
                  DataCell(Text(escalation['task'] as String)),
                  DataCell(Text(escalation['site'] as String)),
                  DataCell(Text(escalation['engineer'] as String)),
                  DataCell(Text(escalation['category'] as String)),
                  DataCell(
                    Text(
                      'Rp ${cost.toString()}',
                      style: TextStyle(
                        color: isOverLimit ? Colors.red : AppColors.textDark,
                        fontWeight: isOverLimit ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  DataCell(_buildStatusChip(escalation['status'] as String)),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        setState(() {
                          _selectedEscalation = escalation;
                          _isDrawerOpen = true;
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Approved':
        color = Colors.green;
        break;
      case 'Rejected':
        color = Colors.red;
        break;
      case 'Pending':
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRightDrawer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDrawerOpen = false;
        });
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 400,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  _buildDrawerHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('ID Eskalasi', _selectedEscalation!['id'] as String),
                          _buildDetailRow('Task', _selectedEscalation!['task'] as String),
                          _buildDetailRow('Site', _selectedEscalation!['site'] as String),
                          _buildDetailRow('Engineer', _selectedEscalation!['engineer'] as String),
                          _buildDetailRow('Kategori', _selectedEscalation!['category'] as String),
                          _buildDetailRow('Biaya', 'Rp ${_selectedEscalation!['cost']}'),
                          const SizedBox(height: 24),
                          Text(
                            'Voice Note',
                            style: AppTypography.bodyMediumMedium.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildVoiceNotePlayer(),
                          const SizedBox(height: 24),
                          Text(
                            'Foto Bukti',
                            style: AppTypography.bodyMediumMedium.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildPhotoGrid(),
                        ],
                      ),
                    ),
                  ),
                  _buildDrawerActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB31216), Color(0xFFED1C24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Detail Eskalasi',
            style: AppTypography.headingH6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              setState(() {
                _isDrawerOpen = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Widget _buildVoiceNotePlayer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFB31216),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice Note',
                  style: AppTypography.bodySmallMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '02:34',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.volume_up, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            height: 100,
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
        );
      }),
    );
  }

  Widget _buildDrawerActions() {
    final status = _selectedEscalation!['status'] as String;
    final isPending = status == 'Pending';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isPending ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Approve'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: isPending ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Reject'),
            ),
          ),
        ],
      ),
    );
  }
}
