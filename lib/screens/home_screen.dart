import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reminder/bloc/reminder_bloc.dart';
import 'package:reminder/model/reminder.dart';
import 'package:reminder/widget/reminder_field.dart';
import 'package:reminder/widget/comman_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void removeReminder(Reminder reminder) {
    context.read<ReminderBloc>().add(RemoveReminder(reminder));
  }

  void alterReminder(int index) {
    context.read<ReminderBloc>().add(AlterReminder(index));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: customAppBar("Reminder"),
      ),
      body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          if (state.status == ReminderStatus.success) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: size.width,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Reminders',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${state.reminders.length}",
                                    style: GoogleFonts.poppins(fontSize: 22),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(FontAwesomeIcons.bell),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final reminder = state.reminders[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: size.width,
                            height: 100,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: reminder.priority == 'High'
                                      ? Colors.red
                                      : reminder.priority == 'Medium'
                                          ? Colors.orange
                                          : Colors.amber,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reminder.title,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Text(
                                          reminder.description,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReminderField(
                                          reminder: reminder,
                                          isEditMode: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.edit),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    removeReminder(reminder);
                                  },
                                  child: const Icon(Icons.delete),
                                ),
                                Checkbox(
                                  value: reminder.isDone,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    alterReminder(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.reminders.length,
                  ),
                ),
              ],
            );
          } else if (state.status == ReminderStatus.initial) {
            return const Center();
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: Colors.blue[200],
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReminderField(),
            ),
          );
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }
}
