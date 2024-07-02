import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'new_member.dart';
import 'package:learn1/lunarCal/lunar_date_screen.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar using NewMemberDatabase
  final isar = await NewMemberDatabase.initialize();

  runApp(MainApp(isar: isar));
}

class MainApp extends StatelessWidget {
  final Isar isar;

  const MainApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(isar: isar),
    //  home: LunarDateScreen(),
    );
  }
}

