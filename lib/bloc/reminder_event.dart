part of 'reminder_bloc.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object?> get props => [];
}

class ReminderStarted extends ReminderEvent {}

class AddReminder extends ReminderEvent {
  final Reminder reminder;
  const AddReminder(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

class RemoveReminder extends ReminderEvent {
  final Reminder reminder;
  const RemoveReminder(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

class AlterReminder extends ReminderEvent {
  final int index;
  const AlterReminder(this.index);

  @override
  List<Object?> get props => [index];
}

class EditReminder extends ReminderEvent {
  final Reminder reminder;
  const EditReminder(this.reminder);

  @override
  List<Object?> get props => [reminder];
}
