import 'package:flutter/material.dart';
import 'package:learn1/calendar/Lunar.dart' as lunar;

class BaziPage extends StatelessWidget {
  final DateTime? birthday;

  const BaziPage({Key? key, required this.birthday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (birthday == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('八字'),
        ),
        body: const Center(
          child: Text('No birthday data available.'),
        ),
      );
    }

    lunar.Lunar lunarDate = lunar.Lunar.fromDate(birthday!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('八字'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BaZi: ${lunarDate.getBaZi()}'),
            Text('Day Gan: ${lunarDate.getDayGan()}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
