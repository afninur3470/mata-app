import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _currentPage = 1;
  final int _rowsPerPage = 10;
  // ignore: unused_field
  String _sortColumn = 'date';
  // ignore: unused_field
  bool _sortAscending = true;

  final List<Map<String, dynamic>> _analyticsData = [
    {'id': 1, 'task': 'WO-2024001', 'engineer': 'Budi Santoso', 'sla': '95%', 'cost': 450000, 'date': '2024-01-01'},
    {'id': 2, 'task': 'WO-2024002', 'engineer': 'Ahmad Rizky', 'sla': '88%', 'cost': 320000, 'date': '2024-01-02'},
    {'id': 3, 'task': 'WO-2024003', 'engineer': 'Dewi Sartika', 'sla': '92%', 'cost': 580000, 'date': '2024-01-03'},
    {'id': 4, 'task': 'WO-2024004', 'engineer': 'Eko Prasetyo', 'sla': '97%', 'cost': 290000, 'date': '2024-01-04'},
    {'id': 5, 'task': 'WO-2024005', 'engineer': 'Budi Santoso', 'sla': '91%', 'cost': 410000, 'date': '2024-01-05'},
    {'id': 6, 'task': 'WO-2024006', 'engineer': 'Ahmad Rizky', 'sla': '89%', 'cost': 350000, 'date': '2024-01-06'},
    {'id': 7, 'task': 'WO-2024007', 'engineer': 'Dewi Sartika', 'sla': '94%', 'cost': 520000, 'date': '2024-01-07'},
    {'id': 8, 'task': 'WO-2024008', 'engineer': 'Eko Prasetyo', 'sla': '96%', 'cost': 280000, 'date': '2024-01-08'},
    {'id': 9, 'task': 'WO-2024009', 'engineer': 'Budi Santoso', 'sla': '93%', 'cost': 470000, 'date': '2024-01-09'},
    {'id': 10, 'task': 'WO-2024010', 'engineer': 'Ahmad Rizky', 'sla': '90%', 'cost': 380000, 'date': '2024-01-10'},
    {'id': 11, 'task': 'WO-2024011', 'engineer': 'Dewi Sartika', 'sla': '98%', 'cost': 310000, 'date': '2024-01-11'},
    {'id': 12, 'task': 'WO-2024012', 'engineer': 'Eko Prasetyo', 'sla': '87%', 'cost': 550000, 'date': '2024-01-12'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'Analytics',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartsGrid(),
            const SizedBox(height: 24),
            _buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildLineChart(),
        _buildStackedBarChart(),
        _buildHorizontalBarChart(),
        _buildCostAnalysisChart(),
      ],
    );
  }

  Widget _buildLineChart() {
    return _buildChartCard(
      'SLA 30 Hari',
      LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 85),
                FlSpot(1, 88),
                FlSpot(2, 92),
                FlSpot(3, 90),
                FlSpot(4, 94),
                FlSpot(5, 96),
                FlSpot(6, 93),
              ],
              isCurved: true,
              color: const Color(0xFFED1C24),
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedBarChart() {
    return _buildChartCard(
      'Domain',
      BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 30,
                  color: const Color(0xFF0369A1),
                  width: 16,
                ),
                BarChartRodData(
                  toY: 20,
                  color: const Color(0xFF0284C7),
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 25,
                  color: const Color(0xFF0369A1),
                  width: 16,
                ),
                BarChartRodData(
                  toY: 35,
                  color: const Color(0xFF0284C7),
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 40,
                  color: const Color(0xFF0369A1),
                  width: 16,
                ),
                BarChartRodData(
                  toY: 15,
                  color: const Color(0xFF0284C7),
                  width: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalBarChart() {
    return _buildChartCard(
      'Leaderboard Engineer',
      BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 28,
                  color: Colors.amber,
                  width: 20,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 24,
                  color: Colors.grey,
                  width: 20,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 22,
                  color: Colors.brown,
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostAnalysisChart() {
    return _buildChartCard(
      'Analisis Biaya',
      BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 450,
                  color: const Color(0xFFED1C24),
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 320,
                  color: const Color(0xFFED1C24),
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 580,
                  color: const Color(0xFFED1C24),
                  width: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            title,
            style: AppTypography.headingH6.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data Analytics',
                  style: AppTypography.headingH6.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                  label: const Text('ID'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumn = 'id';
                      _sortAscending = ascending;
                    });
                  },
                ),
                const DataColumn(label: Text('Task')),
                const DataColumn(label: Text('Engineer')),
                DataColumn(
                  label: const Text('SLA'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumn = 'sla';
                      _sortAscending = ascending;
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Biaya'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumn = 'cost';
                      _sortAscending = ascending;
                    });
                  },
                ),
                const DataColumn(label: Text('Tanggal')),
              ],
              rows: _getPaginatedData().map((data) {
                return DataRow(
                  cells: [
                    DataCell(Text(data['id'].toString())),
                    DataCell(Text(data['task'] as String)),
                    DataCell(Text(data['engineer'] as String)),
                    DataCell(Text(data['sla'] as String)),
                    DataCell(Text('Rp ${data['cost']}')),
                    DataCell(Text(data['date'] as String)),
                  ],
                );
              }).toList(),
            ),
          ),
          _buildPagination(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPaginatedData() {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _analyticsData.sublist(
      startIndex,
      endIndex > _analyticsData.length ? _analyticsData.length : endIndex,
    );
  }

  Widget _buildPagination() {
    final totalPages = (_analyticsData.length / _rowsPerPage).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Halaman $_currentPage dari $totalPages',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
              ),
              ...List.generate(totalPages, (index) {
                final page = index + 1;
                final isActive = page == _currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFED1C24) : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          page.toString(),
                          style: TextStyle(
                            color: isActive ? Colors.white : AppColors.textDark,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < totalPages
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
