import 'package:flutter/material.dart';
import 'package:learn1/calendar/Lunar.dart' as lunar;

import 'new_member.dart'; // Import NewMember class

class BaziPage extends StatelessWidget {
  final DateTime? birthday;
  final String? time;

  const BaziPage({Key? key, required this.birthday, this.time}) : super(key: key);

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

    // Parse the time if available
    TimeOfDay? parsedTime = NewMember.stringToTimeOfDay(time);

    // Combine date and time for Lunar calculation
    DateTime combinedDateTime = DateTime(
      birthday!.year,
      birthday!.month,
      birthday!.day,
      parsedTime?.hour ?? 0,
      parsedTime?.minute ?? 0,
    );

    lunar.Lunar lunarDate = lunar.Lunar.fromDate(combinedDateTime);

    print('Parsed Time: $parsedTime');
    print('Combined DateTime: $combinedDateTime');

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
