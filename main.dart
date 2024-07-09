import 'package:flutter/material.dart';
import 'financial_graph_screen.dart';


void main() {
  runApp(const KR11App());
}


class KR11App extends StatelessWidget {
  const KR11App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KR11 Financial Graph',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FinancialGraphScreen(),
    );
  }
}
