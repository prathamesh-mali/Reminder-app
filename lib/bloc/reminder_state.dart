part of 'reminder_bloc.dart';

enum ReminderStatus { initial, loading, success, error }

class ReminderState {
  final List<Reminder> reminders;
  final List<Reminder> filteredReminders;

  final ReminderStatus status;
  ReminderState({
    this.reminders = const <Reminder>[],
    this.filteredReminders = const <Reminder>[],
    this.status = ReminderStatus.initial,
  });

  ReminderState copyWith({
    List<Reminder>? reminders,
    List<Reminder>? filteredReminders,
    ReminderStatus? status,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      filteredReminders: filteredReminders ?? this.filteredReminders,
      status: status ?? this.status,
    );
  }

  @override
  factory ReminderState.fromJson(Map<String, dynamic> json) {
    try {
      var listOfReminders = (json['reminder'] as List<dynamic>)
          .map((e) => Reminder.fromJson(e as Map<String, dynamic>))
          .toList();

      return ReminderState(
          reminders: listOfReminders,
          status: ReminderStatus.values.firstWhere(
              (element) => element.name.toString() == json['status']));
    } catch (e) {
      rethrow;
    }
  }
  Map<String, dynamic> toJson() {
    return {'reminder': reminders, 'status': status.name};
  }

  List<Object?> get props => [reminders, status];
}
