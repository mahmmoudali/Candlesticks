import 'package:candlestick_chart/models/interval.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';

class CandlesProvider extends ChangeNotifier {
  List<Candle> candles = [];
  List<CandleInterval> options = [
    CandleInterval("Day", '1d'),
    CandleInterval("Week", '1wk'),
    CandleInterval("Month", '1mo'),
  ];
  late CandleInterval selectedIntervalOption = options[0];
  String startDate = "4-10";
  String endDate = "4-10";
  DatePeriod datePeriod =
      DatePeriod(DateTime(2021, 10, 4), DateTime(2022, 10, 4));

  void setCandles(List<Candle> candles) {
    this.candles = [];
    this.candles = candles;
    notifyListeners();
  }

  void setIntervalOption(CandleInterval interval) {
    this.selectedIntervalOption = interval;
    notifyListeners();
  }

  changeDatePeriod(DatePeriod datePeriod) {
    this.datePeriod = datePeriod;
    startDate = DateFormat("d-M").format(datePeriod.start);
    endDate = DateFormat("d-M").format(datePeriod.end);
    notifyListeners();
  }
}
