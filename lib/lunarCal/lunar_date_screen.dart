// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:learn1/calendar/EightChar.dart';
import 'package:learn1/calendar/Lunar.dart';
import 'package:learn1/calendar/eightchar/DaYun.dart';
import 'package:learn1/calendar/eightchar/Yun.dart';

class LunarDateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example: Create a Solar date (current date for this example)
    DateTime now = DateTime.now();
    
    // Convert to Lunar date
    Lunar lunarInstance = Lunar.fromDate(now);

    // Create EightChar instance with Lunar instance
    EightChar eightChar = EightChar(lunarInstance);

    // Create Yun instance
    Yun yun = Yun(eightChar, 1);

    // Create DaYun instance
    DaYun daYun = DaYun(yun, 1);
    
    Lunar todayDate = Lunar.fromDate(DateTime(1990,4,16,14,37));

    // Print the full string of todayDate
    
     print('Today Date (Lunar): ${todayDate.getBaZi()}');
      print('Today Date (Lunar): ${todayDate.getDayGan()}');
    //指定阴历的某一天
    Lunar specificDate = Lunar.fromYmd(1986, 4, 21);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunar Date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start Year: ${daYun.getStartYear()}'),
              Text('End Year: ${daYun.getEndYear()}'),
              Text('Start Age: ${daYun.getStartAge()}'),
              Text('End Age: ${daYun.getEndAge()}'),
              const SizedBox(height: 20),
              Text('GanZhi: ${daYun.getGanZhi()}'),
              Text('Xun: ${daYun.getXun()}'),
              Text('XunKong: ${daYun.getXunKong()}'),
              const SizedBox(height: 20),
              Text('LiuNian:'),
              Text('Today: ${todayDate.toFullString()}'),
              const SizedBox(height: 10),
              Text('Solar Date: ${todayDate.getSolar().toFullString()}'),
              const SizedBox(height: 20),
              Text('Specific Date: ${specificDate.toFullString()}'),
              const SizedBox(height: 10),
              Text('Solar Date: ${specificDate.getSolar().toFullString()}'),
              Column(
                children: daYun.getLiuNian().map((liuNian) {
                  return Text('${liuNian.getYear()} - ${liuNian.getAge()}');
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text('XiaoYun:'),
              Column(
                children: daYun.getXiaoYun().map((xiaoYun) {
                  return Text('Index: ${xiaoYun.getIndex()}');
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
