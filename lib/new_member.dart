import 'package:isar/isar.dart';
import 'package:flutter/material.dart';

part 'new_member.g.dart';

@collection
class NewMember {
  Id id = Isar.autoIncrement;

  late String name;
  late bool isMale;
  DateTime? birthday;
  String? time; // Store time as a string

  NewMember({
    required this.name,
    required this.isMale,
    this.birthday,
    this.time,
  });

  // Helper methods for TimeOfDay
  static TimeOfDay? stringToTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String? timeOfDayToString(TimeOfDay? time) {
    if (time == null) return null;
    return '${time.hour}:${time.minute}';
  }
}
