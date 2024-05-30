import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:reminder/model/reminder.dart';
import 'package:reminder/service/notification_service.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends HydratedBloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderState()) {
    on<ReminderStarted>(_onStarted);
    on<AddReminder>(_onAddReminder);
    on<EditReminder>(_onEditReminder);
    on<RemoveReminder>(_onRemoveReminder);
    on<AlterReminder>(_onAlterReminder);
  }

  void _onStarted(
    ReminderStarted event,
    Emitter<ReminderState> emit,
  ) {
    if (state.status == ReminderStatus.success) return;
    emit(state.copyWith(
        reminders: state.reminders, status: ReminderStatus.success));
  }

  void _onAddReminder(
    AddReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(state.copyWith(status: ReminderStatus.loading));
    try {
      List<Reminder> temp = [];
      temp.addAll(state.reminders);
      temp.insert(0, event.reminder);
      emit(state.copyWith(reminders: temp, status: ReminderStatus.success));
      await NotificationService.scheduleReminderNotification(event.reminder);
    } catch (e) {
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }

  void _onRemoveReminder(
    RemoveReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(state.copyWith(status: ReminderStatus.loading));
    try {
      state.reminders.remove(event.reminder);
      emit(state.copyWith(
          reminders: state.reminders, status: ReminderStatus.success));
      await NotificationService.cancelReminderNotification(event.reminder);
    } catch (e) {
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }

  void _onEditReminder(
    EditReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(state.copyWith(status: ReminderStatus.loading));
    try {
      int index = state.reminders
          .indexWhere((reminder) => reminder.title == event.reminder.title);

      if (index != -1) {
        List<Reminder> updatedReminders = List.from(state.reminders);

        updatedReminders[index] = event.reminder;

        emit(state.copyWith(
            reminders: updatedReminders, status: ReminderStatus.success));

        await NotificationService.cancelReminderNotification(event.reminder);
        await NotificationService.scheduleReminderNotification(event.reminder);
      } else {
        emit(state.copyWith(status: ReminderStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }

  void _onAlterReminder(
    AlterReminder event,
    Emitter<ReminderState> emit,
  ) {
    emit(state.copyWith(status: ReminderStatus.loading));
    try {
      state.reminders[event.index].isDone =
          !state.reminders[event.index].isDone;
      emit(state.copyWith(
          reminders: state.reminders, status: ReminderStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }

  @override
  ReminderState? fromJson(Map<String, dynamic> json) {
    return ReminderState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ReminderState state) {
    return state.toJson();
  }
}
