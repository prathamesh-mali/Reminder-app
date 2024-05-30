import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:reminder/bloc/reminder_bloc.dart';
import 'package:reminder/model/reminder.dart';
import 'package:reminder/widget/comman_widgets.dart';

class ReminderField extends StatefulWidget {
  final Reminder? reminder;
  final bool isEditMode;

  const ReminderField({super.key, this.reminder, this.isEditMode = false});

  @override
  State<ReminderField> createState() => _ReminderFieldState();
}

class _ReminderFieldState extends State<ReminderField> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String priority = "Low";
  addReminder(Reminder reminder) {
    context.read<ReminderBloc>().add(
          AddReminder(reminder),
        );
  }

  editReminder(Reminder reminder) {
    context.read<ReminderBloc>().add(EditReminder(reminder));
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode && widget.reminder != null) {
      _titleController.text = widget.reminder!.title;
      _descriptionController.text = widget.reminder!.description;
      priority = widget.reminder!.priority;
      selectedDate = widget.reminder!.date;
      selectedTime = widget.reminder!.time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child:
            customAppBar(widget.isEditMode ? "Edit Reminder" : "Add Reminder"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _titleController,
              decoration: inputDecoration("Title"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: IntrinsicHeight(
              child: TextField(
                controller: _descriptionController,
                minLines: 1,
                maxLines: null,
                decoration: inputDecoration("Description"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: ["Low", "Medium", "High"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    borderRadius: BorderRadius.circular(15),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          priority = newValue;
                        });
                      }
                    },
                    value: priority,
                    hint: const Text("Select Priority"),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePickerDialog(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2025));

                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                          );
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade700,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: selectedDate == null
                          ? const Text("Select Date")
                          : Text(
                              DateFormat('dd-MM-yyyy').format(selectedDate!)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePickerDialog(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now());
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade700,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: selectedTime == null
                            ? const Text("Select Time")
                            : Text(formatTimeOfDay(selectedTime!))),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GestureDetector(
              onTap: () {
                if (_titleController.text.isEmpty) {
                  showToastMsg("Enter title");
                } else if (_descriptionController.text.isEmpty) {
                  showToastMsg("Enter Description");
                } else if (selectedDate == null) {
                  showToastMsg("Please Select Date");
                } else if (selectedTime == null) {
                  showToastMsg("Please Select Time");
                } else if (widget.isEditMode == true) {
                  editReminder(
                    Reminder(
                      title: _titleController.text,
                      time: selectedTime!,
                      date: selectedDate!,
                      priority: priority,
                      description: _descriptionController.text,
                      isDone: false,
                    ),
                  );

                  showToastMsg("Reminder edited successfully");
                  Navigator.pop(context);
                } else {
                  addReminder(
                    Reminder(
                      title: _titleController.text,
                      time: selectedTime!,
                      date: selectedDate!,
                      description: _descriptionController.text,
                      priority: priority,
                      isDone: false,
                    ),
                  );

                  showToastMsg("Reminder added successfully");
                  Navigator.pop(context);
                }
              },
              child: AnimatedContainer(
                  alignment: Alignment.center,
                  width: size.width,
                  height: 50,
                  duration: const Duration(milliseconds: 5000),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: Text(
                    widget.isEditMode ? "Edit Reminder" : "Add Reminder",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void showToastMsg(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            secondary: Colors.black,
            onSecondary: Colors.blue,
            error: Colors.red,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );

    return selectedDate;
  }

  Future<TimeOfDay?> showTimePickerDialog({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) async {
    initialTime ??= TimeOfDay.fromDateTime(DateTime.now());

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    return selectedTime;
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }
}
