import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'home_page.dart';
import 'new_member.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Isar and open the NewMember collection
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NewMemberSchema],
    directory: dir.path,
  );

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
    );
  }
}

