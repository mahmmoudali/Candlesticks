import 'package:candlestick_chart/providers/candles_provider.dart';
import 'package:candlestick_chart/ui/auth_screen.dart';
import 'package:candlestick_chart/ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CandlesProvider())
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: AuthScreen()),
    );
  }
}
