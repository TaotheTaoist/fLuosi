import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'new_member.g.dart';

@Collection()
class NewMember {
  Id? id;
  String name;
  bool isMale;
  DateTime? birthday;
  String? time; // Store time as a string

  NewMember({
    required this.name,
    required this.isMale,
    this.birthday,
    this.time,
  });

  // Helper method to convert TimeOfDay to String
  static String? timeOfDayToString(TimeOfDay? time) {
    if (time == null) return null;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper method to convert String to TimeOfDay
  static TimeOfDay? stringToTimeOfDay(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}

class NewMemberDatabase {
  static Future<Isar> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [NewMemberSchema],
      directory: dir.path,
    );
    return isar;
  }
}
