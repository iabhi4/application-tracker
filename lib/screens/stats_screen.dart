import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/preferences_service.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<BarChartGroupData> barData = [];
  String selectedFilter = 'Daily'; // Daily | Weekly | Monthly
  List<String> groupedKeys = []; // To use as labels

  int currentPage = 0; // Pagination: 0 = latest
  int itemsPerPage = 7;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    final stats = await PreferencesService.getDailyStats();
    final now = DateTime.now();

    Map<String, int> groupedStats = {};

    for (String entry in stats) {
      final parts = entry.split(':');
      if (parts.length != 2) continue;

      final date = DateTime.tryParse(parts[0]);
      final count = int.tryParse(parts[1]) ?? 0;
      if (date == null) continue;

      String key;
      if (selectedFilter == 'Weekly') {
        key = _getWeekKey(date);
      } else if (selectedFilter == 'Monthly') {
        key = DateFormat('yyyy-MM').format(date);
      } else {
        key = DateFormat('yyyy-MM-dd').format(date);
      }

      groupedStats[key] = (groupedStats[key] ?? 0) + count;
    }

    final allKeys = groupedStats.keys.toList()..sort();
    final start = (allKeys.length - (currentPage + 1) * itemsPerPage)
        .clamp(0, allKeys.length);
    final end =
        (allKeys.length - currentPage * itemsPerPage).clamp(0, allKeys.length);
    final visibleKeys = allKeys.sublist(start, end);

    List<BarChartGroupData> chartData = [];

    for (int i = 0; i < visibleKeys.length; i++) {
      final count = groupedStats[visibleKeys[i]] ?? 0;

      chartData.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                toY: count.toDouble(), width: 18, color: Colors.cyan),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    setState(() {
      barData = chartData;
      groupedKeys = visibleKeys;
    });
  }

  String _getWeekKey(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysPassed = date.difference(firstDayOfYear).inDays;
    final weekNumber = ((daysPassed + firstDayOfYear.weekday) / 7).ceil();
    return '${date.year}-W${weekNumber.toString().padLeft(2, '0')}';
  }

  void _changePage(int delta) {
    setState(() {
      currentPage += delta;
    });
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Application Stats")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: currentPage <
                          ((groupedKeys.length + itemsPerPage - 1) ~/
                                  itemsPerPage) -
                              1
                      ? () => _changePage(1)
                      : null,
                  child: Text("< Prev"),
                ),
                Spacer(),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: ['Daily', 'Weekly', 'Monthly']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedFilter = val;
                        currentPage = 0;
                      });
                      _loadStats();
                    }
                  },
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: currentPage > 0 ? () => _changePage(-1) : null,
                  child: Text("Next >"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: barData.isEmpty
                  ? Center(child: Text("Not enough data yet."))
                  : BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value % 1 != 0)
                                  return Container(); // skip decimal ticks
                                return Text('${value.toInt()}');
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value % 1 != 0)
                                  return Container(); // skip decimal ticks
                                return Text('${value.toInt()}');
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                  _formatLabel(value.toInt()),
                                  style: TextStyle(fontSize: 10)),
                            ),
                          ),
                        ),
                        barGroups: barData,
                      ),
                      swapAnimationDuration: Duration(milliseconds: 300),
                      swapAnimationCurve: Curves.easeInOut,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLabel(int index) {
    if (index < 0 || index >= groupedKeys.length) return '';
    final key = groupedKeys[index];
    if (selectedFilter == 'Daily') {
      return DateFormat('MM/dd').format(DateTime.parse(key));
    }
    return key; // Weekly and Monthly already formatted
  }
}
