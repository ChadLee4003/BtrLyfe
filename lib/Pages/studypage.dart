import 'package:btrlyfe/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:btrlyfe/items.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  late DateTime today;
  DateTime? _selectedDay;

  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  String _category = 'Study';

  @override
  void initState() {
    super.initState();

    today = _dateOnly(DateTime.now());
    _selectedDay = today;
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    final selectedDate = _dateOnly(day);

    setState(() {
      today = selectedDate;
      _selectedDay = selectedDate;
    });
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColors>();

    Color primarycolor = colors.primaryColor;
    Color secondarycolor = colors.secondaryColor;
    Color tertiarycolor = colors.tertiaryColor;

    return Scaffold(
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primarycolor,
              tertiarycolor,
            ],
          ),
        ),

        child: SafeArea(
          child: content(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _eventController.clear();
          _minutesController.clear();
          _category = 'Study';

          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text("Add Event"),

                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _eventController,
                          decoration: const InputDecoration(
                            labelText: "Event Name",
                            hintText: "Enter event name",
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: _minutesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Time to Spend",
                            hintText: "Enter time in minutes",
                            suffixText: "min",
                          ),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: _category,
                          decoration: const InputDecoration(
                            labelText: "Category",
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Study',
                              child: Text('Study'),
                            ),
                            DropdownMenuItem(
                              value: 'Sports',
                              child: Text('Sports'),
                            ),
                            DropdownMenuItem(
                              value: 'Meetings',
                              child: Text('Meetings'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                _category = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),

                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          final eventName = _eventController.text.trim();
                          final minutes =
                              int.tryParse(_minutesController.text.trim());

                          if (eventName.isEmpty || minutes == null || minutes <= 0) {
                            return;
                          }

                          final date = _dateOnly(_selectedDay!);

                          context.read<Items>().addEvent(
                            date,
                            eventName,
                            minutes,
                            _category,
                          );

                          Navigator.of(context).pop();
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }

  Widget content() {
    TextStyle mainFont(TextStyle value) {
      return GoogleFonts.titanOne(textStyle: value);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        90,
      ),

      child: Column(
        children: [
          // TITLE
          Text(
            "Study",
            style: mainFont(
              const TextStyle(
                color: Colors.white,
                fontSize: 55,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),

            padding: const EdgeInsets.all(8),

            child: TableCalendar(
              calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(
                  color: Colors.white, 
                ),
                weekendTextStyle: TextStyle(
                  color: Colors.white,
                ),
                outsideTextStyle: TextStyle(
                  color: Color.fromARGB(255, 206, 206, 206), 
                ),
              ),

              locale: "en_US",

              rowHeight: 43,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color:Colors.white
                ),
                weekendStyle: TextStyle(
                  color:Colors.white
                )
              ),

              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(color:Colors.white, fontSize: 20)
              ),

              availableGestures: AvailableGestures.all,

              selectedDayPredicate: (day) {
                return isSameDay(day, today);
              },

              focusedDay: today,

              firstDay: DateTime.utc(
                2010,
                10,
                16,
              ),

              lastDay: DateTime.utc(
                2030,
                3,
                1,
              ),

              onDaySelected: _onDaySelected,

              eventLoader: (day) {
                return context
                    .read<Items>()
                    .getEventsForDay(day);
              },
            ),
          ),

          const SizedBox(height: 10,),


          //Items Display_________________________________________________________________________________________________________________________________________________________

          Expanded(
            child: Consumer<Items>(
              builder: (context, calendar, child) {
                final events = calendar.getEventsForDay(
                  _selectedDay!,
                );

                if (events.isEmpty) {
                  return const Center(
                    child: Text(
                      "No events for this day",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: events.length,

                  itemBuilder: (context, index) {
                    final event = events[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: event.category == 'Study'
                          ? Colors.yellow
                          : event.category == 'Sports'
                              ? Colors.green
                              : event.category == 'Meetings'
                                  ? Colors.orange
                                  : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          Text(
                            "${event.minutes} min",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              context.read<Items>().deleteEvent(
                                _selectedDay!,
                                index,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
