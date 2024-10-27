import 'package:expense_app/data/database.dart';
import 'package:expense_app/utilities/category_class_utility.dart';
import 'package:expense_app/utilities/category_tile_horizontal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class Reports extends StatefulWidget {
  final String title;

  Reports({Key? key, this.title = "Reports"}) : super(key: key);

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  int touchedIndex = -1;

  final _myBox = Hive.box('expenseTrackerBox');
  ExpenseTrackerDataBase db = ExpenseTrackerDataBase();

  @override
  void initState() {
    if (_myBox.isEmpty) {
      db.createInitialData();
    } else {
      db.loadData();
      db.loadExpenseData();
    }
    super.initState();
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'M';
        break;
      case 1:
        text = 'T';
        break;
      case 2:
        text = 'W';
        break;
      case 3:
        text = 'Th';
        break;
      case 4:
        text = 'F';
        break;
      case 5:
        text = 'Sa';
        break;
      case 6:
        text = 'Su';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> generateBarGroups() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));

    final recentExpenses = db.expenses.where((expense) {
      final date = expense[2];
      return date.isAfter(sevenDaysAgo) && date.isBefore(now);
    }).toList();

    final Map<int, double> dailySums = {};
    for (var expense in recentExpenses) {
      final date = expense[2];
      final dayOfYear = int.parse(DateFormat('D').format(date));

      dailySums[dayOfYear] = (dailySums[dayOfYear] ?? 0) + expense[0];
    }

    return List.generate(7, (index) {
      final dayOfYear = int.parse(
          DateFormat('D').format(now.subtract(Duration(days: index))));
      final expense = dailySums[dayOfYear] ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: expense,
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: generateBarGroups(),
                  gridData: const FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 1.3,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: db.categories.length,
                      itemBuilder: (context, index) {
                        Category category = db.categories[index];
                        return CategoryHorizontal(
                          categoryName: category.name,
                          categoryColor: category.color,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          startDegreeOffset: 180,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 1,
                          centerSpaceRadius: 0,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    Map<String, double> categorySums = {};
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(Duration(days: 30));

    final recentExpenses = db.expenses.where((expense) {
      final date = expense[2] as DateTime;
      return date.isAfter(thirtyDaysAgo) && date.isBefore(now);
    }).toList();

    double totalSum = recentExpenses.fold(0.0, (sum, expense) {
      final value = expense[0];
      return sum + (value is double ? value : (value as int).toDouble());
    });

    for (var expense in recentExpenses) {
      double value =
          expense[0] is int ? (expense[0] as int).toDouble() : expense[0];
      String category = expense[4];
      categorySums[category] = (categorySums[category] ?? 0.0) + value;
    }

    return List.generate(db.categories.length, (i) {
      final isTouched = i == touchedIndex;
      final Category category = db.categories[i];
      final double percentage =
          (categorySums[category.name] ?? 0) / totalSum * 100;

      return PieChartSectionData(
        color: category.color,
        value: percentage.isNaN ? 0 : percentage,
        title: '',
        radius: isTouched ? 80 : 70,
        titlePositionPercentageOffset: 0.55,
        borderSide: isTouched
            ? const BorderSide(color: Colors.white, width: 6)
            : BorderSide(color: Colors.white.withOpacity(0)),
      );
    });
  }
}
