import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {

            return Stack(
              
              children: [
                Container(
                  width: constraints.maxWidth * 0.8,
                  height: constraints.maxHeight * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TableCalendar(
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2022, 1, 1),
                    lastDay: DateTime(2025, 12, 31),
                    headerVisible: false,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.red),
                      weekendStyle: TextStyle(color: Colors.green),
                    ),
                    headerStyle: HeaderStyle(
                      titleTextStyle: TextStyle(fontSize: 20),
                    ),
                    rowHeight: constraints.maxHeight * 0.10,
                    daysOfWeekHeight: constraints.maxHeight * 0.1,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      print('Ajouter événement à $_selectedDay');
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
