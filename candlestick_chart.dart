import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class CandlestickChart extends StatelessWidget {
  final List<CandleData> dataPoints;

  CandlestickChart(this.dataPoints);

  @override
  Widget build(BuildContext context) {
    DateTime minDate = dataPoints.first.date;
    DateTime maxDate = dataPoints.last.date;
    double minPrice = dataPoints.map((data) => data.low).reduce((a, b) => a < b ? a : b);
    double maxPrice = dataPoints.map((data) => data.high).reduce((a, b) => a > b ? a : b);


    double yAxisMax = maxPrice + (maxPrice - minPrice) * 0.1;

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0.5),
        intervalType: DateTimeIntervalType.months,
        dateFormat: DateFormat.MMM(),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorTickLines: const MajorTickLines(size: 0),
        axisLine: const AxisLine(width: 0),
        minimum: minDate,
        maximum: maxDate,
      ),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: const MajorGridLines(width: 0.5),
        majorTickLines: const MajorTickLines(size: 0),
        axisLine: const AxisLine(width: 0),
        labelPosition: ChartDataLabelPosition.outside,
        minimum: 0,
        maximum: yAxisMax, // Adjusted maximum price range
      ),
      series: <ChartSeries>[
        CandleSeries<CandleData, DateTime>(
          dataSource: dataPoints,
          xValueMapper: (CandleData data, _) => data.date,
          lowValueMapper: (CandleData data, _) => data.low,
          highValueMapper: (CandleData data, _) => data.high,
          openValueMapper: (CandleData data, _) => data.open,
          closeValueMapper: (CandleData data, _) => data.close,
          bearColor: Colors.black, // Color for the bearish (decreasing) candles
          bullColor: Colors.green, // Color for the bullish (increasing) candles
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}

class CandleData {
  CandleData(this.date, this.open, this.high, this.low, this.close);
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
}
