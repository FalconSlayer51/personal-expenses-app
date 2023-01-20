import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chartBar.dart';

class Chart extends StatefulWidget {
  //* //////////////////////////////////////////////////////////////////////////////
  final List<Transactions> recentTransaction;
  final Function chartrender;
  const Chart({
    Key? key,
    required this.recentTransaction,
    required this.chartrender,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 1), (timer) => widget.chartrender());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> get groupedTransactionValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (var i = 0; i < widget.recentTransaction.length; i++) {
        if (widget.recentTransaction[i].time.day == weekDay.day &&
            widget.recentTransaction[i].time.month == weekDay.month &&
            widget.recentTransaction[i].time.year == weekDay.year) {
          totalSum += widget.recentTransaction[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValue.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  //* //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValue.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data['day'] as String,
                spendingAmount: data['amount'] as double,
                spendingPctOfTotal: totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
