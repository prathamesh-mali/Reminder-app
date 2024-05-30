import 'package:flutter/material.dart';

class Reminder {
  String title;
  TimeOfDay time;
  DateTime date;
  String description;
  String priority;
  bool isDone;

  Reminder({
    required this.title,
    required this.time,
    required this.date,
    required this.description,
    required this.priority,
    required this.isDone,
  });

  Reminder copyWith({
    String? title,
    TimeOfDay? time,
    DateTime? date,
    String? priority,
    String? description,
    bool? isDone,
  }) {
    return Reminder(
      title: title ?? this.title,
      time: time ?? this.time,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> timeOfDayToJson(TimeOfDay time) {
    return {
      'hour': time.hour,
      'minute': time.minute,
    };
  }

  static TimeOfDay timeOfDayFromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
        title: json['title'],
        time: timeOfDayFromJson(json['time']),
        date: DateTime.parse(json['date']),
        priority: json['priority'],
        description: json['description'],
        isDone: json['isDone']);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "time": timeOfDayToJson(time),
      "date": date.toIso8601String(),
      "description": description,
      "priority": priority,
      "isDone": isDone,
    };
  }
}
