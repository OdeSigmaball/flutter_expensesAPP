import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/database_provider.dart';

class ExpenseChart extends StatefulWidget {
  final String category;
  const ExpenseChart(this.category, {super.key});

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var maxY = db.calculateEntriesAndAmount(widget.category)['totalAmount'] ?? 0.0;
      var list = db.calculateWeekExpenses().reversed.toList();

      return BarChart(
        BarChartData(
          barTouchData: BarTouchData(enabled: true),
          minY: 0,
          maxY: maxY == 0 ? 10 : maxY, // Hindari chart tidak tampil jika 0
          barGroups: list.asMap().entries.map((entry) {
            int index = entry.key;
            var e = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: e['amount'] ?? 0.0,
                  width: 20.0,
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index >= 0 && index < list.length) {
                    final date = list[index]['day'];
                    if (date is DateTime) {
                      return Text(DateFormat.E().format(date));
                    }
                  }
                  return const Text('');
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
