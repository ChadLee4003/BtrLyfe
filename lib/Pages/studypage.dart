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

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,

                title: const Text("Event Name"),

                content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _eventController,
                    decoration: const InputDecoration(
                      hintText: "Enter event name",
                    ),
                  ),
                ),

                actions: [
                  ElevatedButton(
                    onPressed: () {
                      final eventName = _eventController.text.trim();

                      if (eventName.isEmpty) {
                        return;
                      }

                      final date = _dateOnly(_selectedDay!);

                      context.read<Items>().addEvent(
                        date,
                        eventName,
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
            "Sleep",
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
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),

                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),

                      child: ListTile(
                        title: Text(
                          '${events[index]}',
                        ),

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),

                          onPressed: () {
                            calendar.deleteEvent(
                              _selectedDay!,
                              index,
                            );
                          },
                        ),
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
