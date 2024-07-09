import 'package:flutter/material.dart';
import 'api_service.dart';
import 'candlestick_chart.dart';

class FinancialGraphScreen extends StatefulWidget {
  @override
  _FinancialGraphScreenState createState() => _FinancialGraphScreenState();
}

class _FinancialGraphScreenState extends State<FinancialGraphScreen> {
  final ApiService apiService = ApiService();
  List<CandleData> dataPoints = [];
  String selectedTimeRange = '1D';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await apiService.fetchStockData('AAPL');
    final timeSeries = data['Time Series (5min)'];
    List<CandleData> points = [];
    timeSeries.forEach((timestamp, values) {
      points.add(CandleData(
        DateTime.parse(timestamp),
        double.parse(values['1. open']),
        double.parse(values['2. high']),
        double.parse(values['3. low']),
        double.parse(values['4. close']),
      ));
    });
    setState(() {
      dataPoints = points;
    });
  }

  void onTimeRangeChanged(String range) {
    setState(() {
      selectedTimeRange = range;
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF7775F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7775F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Column(
          children: [
            Text(
              'APPLE ₹443',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              '+1.80 (4.32%)',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/icon.jpg', width: 24, height: 24),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1), // Add space at the top
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              child: dataPoints.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : CandlestickChart(dataPoints),
            ),
            SizedBox(height: screenHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TimeRangeButton('1D', selectedTimeRange, onTimeRangeChanged),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TimeRangeButton('3D', selectedTimeRange, onTimeRangeChanged),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TimeRangeButton('5D', selectedTimeRange, onTimeRangeChanged),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TimeRangeButton('1W', selectedTimeRange, onTimeRangeChanged),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TimeRangeButton('1M', selectedTimeRange, onTimeRangeChanged),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TimeRangeButton('1Y', selectedTimeRange, onTimeRangeChanged),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeRangeButton extends StatelessWidget {
  final String range;
  final String selectedRange;
  final ValueChanged<String> onPressed;

  TimeRangeButton(this.range, this.selectedRange, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        backgroundColor: selectedRange == range ? Colors.orange : Colors.white,
        foregroundColor: selectedRange == range ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      onPressed: () => onPressed(range),
      child: Text(
        range,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
