import 'dart:developer';
import 'package:candlesticks/candlesticks.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class CandlesService {
  List<List<dynamic>> rowsAsListOfValues = [];
  Future<List<Candle>> fetchCandles(
      {int startDateTimestamp = 1633381200,
      int endDateTimestamp = 1664917199,
      String interval = '1d'}) async {
    final uri = Uri.parse(
        "https://query1.finance.yahoo.com/v7/finance/download/SPUS?period1=$startDateTimestamp&period2=$endDateTimestamp&interval=$interval&events=history&crumb=5YTX%2FgVGBmg");
    try {
      final res = await http.get(uri);
      rowsAsListOfValues = const CsvToListConverter()
          .convert(res.body, fieldDelimiter: ',', eol: '\n');
      rowsAsListOfValues.removeAt(0);
    } catch (e) {
      log("Error on transforming json $e");
    }

    return rowsAsListOfValues
        .map((e) {
          return Candle(
              date: DateTime.parse(e[0]),
              high: e[2],
              low: e[3],
              open: e[1],
              close: e[4],
              volume: (e[6] as int).toDouble());
        })
        .toList()
        .reversed
        .toList();
  }
}
