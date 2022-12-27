import 'dart:developer';

import 'package:candlestick_chart/models/interval.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:provider/provider.dart';

import '../providers/candles_provider.dart';
import '../services/candles_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    CandlesService candlesService = CandlesService();
    CandlesProvider candlesProvider =
        Provider.of<CandlesProvider>(context, listen: false);
    candlesService.fetchCandles().then((candles) {
      candlesProvider.setCandles(candles);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CandlesProvider candlesProvider = Provider.of<CandlesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Candles Chart"),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: candlesProvider.selectedIntervalOption,
              iconEnabledColor: Colors.black,
              style: const TextStyle(fontSize: 16),
              items: List.generate(
                  candlesProvider.options.length,
                  (index) => DropdownMenuItem<CandleInterval>(
                      value: candlesProvider.options[index],
                      child: Text(candlesProvider.options[index].title,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16)))),
              onChanged: (value) {
                candlesProvider.setIntervalOption(value!);
                CandlesService candlesService = CandlesService();
                candlesService
                    .fetchCandles(
                        startDateTimestamp: candlesProvider
                                .datePeriod.start.millisecondsSinceEpoch ~/
                            1000,
                        endDateTimestamp: candlesProvider
                                .datePeriod.end.millisecondsSinceEpoch ~/
                            1000,
                        interval: value.code)
                    .then((candles) {
                  candlesProvider.setCandles(candles);
                });
              },
            ),
          ),
          TextButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setStateDialog) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RangePicker(
                            firstDate: new DateTime(2010),
                            lastDate: new DateTime(2030),
                            selectedPeriod: candlesProvider.datePeriod,
                            onChanged: (dates) {
                              try {
                                if (dates.end != dates.start) {
                                  setStateDialog(() {
                                    candlesProvider.changeDatePeriod(dates);
                                  });
                                  CandlesService candlesService =
                                      CandlesService();
                                  candlesService
                                      .fetchCandles(
                                    startDateTimestamp:
                                        dates.start.millisecondsSinceEpoch ~/
                                            1000,
                                    endDateTimestamp:
                                        dates.end.millisecondsSinceEpoch ~/
                                            1000,
                                  )
                                      .then((candles) {
                                    candlesProvider.setCandles(candles);
                                  });
                                }
                              } catch (e) {
                                log("Error Selection Date Period $e");
                              }
                            },
                          ),
                        ),
                      );
                    });
                  });
            },
            child: Text(
              "${candlesProvider.startDate} To ${candlesProvider.endDate}",
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: Center(
        child: Candlesticks(
          candles: candlesProvider.candles,
        ),
      ),
    );
  }
}
