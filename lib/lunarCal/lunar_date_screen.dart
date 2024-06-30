import 'package:flutter/material.dart';
import 'package:learn1/Lunar.dart';

class LunarDateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //今天
    Lunar todayDate = Lunar.fromDate(DateTime.now());

    //指定阴历的某一天
    Lunar specificDate = Lunar.fromYmd(1986, 4, 21);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunar Date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today: ${todayDate.toFullString()}'),
            const SizedBox(height: 10),
            Text('Solar Date: ${todayDate.getSolar().toFullString()}'),
            const SizedBox(height: 20),
            Text('Specific Date: ${specificDate.toFullString()}'),
            const SizedBox(height: 10),
            Text('Solar Date: ${specificDate.getSolar().toFullString()}'),
          ],
        ),
      ),
    );
  }
}
