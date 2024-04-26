import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_item.dart';
import 'package:intl/intl.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  DateTime? _selectedDay;
  List<CalendarItem> calendarItems = [];

  @override
  void initState() {
    super.initState();
    fetchEvent();
  }

  Future<void> fetchEvent() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/calendar/get'));

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          calendarItems = data
              .map<CalendarItem>((item) => CalendarItem(
                    id: item['EventId'].toString(),
                    eventName: item['EventName'].toString(),
                    eventDate: DateTime.parse(item['EventDate']),
                  ))
              .toList();
        });
      } else {
        calendarItems = [];
      }
    } else {
      throw Exception('Failed to load event');
    }
  }

  Future<void> addEvent(String eventName, DateTime eventDate) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(eventDate);
      final url = Uri.parse(
          'http://localhost:8000/calendar/create?name=$eventName&date=$formattedDate');
      final response = await http.post(url);
      if (response.statusCode == 200) {
        fetchEvent();
      } else {
        throw Exception('Failed to add event');
      }
    } catch (error) {
      print('Error adding event: $error');
    }
  }

  void _showAddEventDialog(BuildContext context) {
    String eventName = '';
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un événement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nom de l\'événement'),
                onChanged: (value) {
                  eventName = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                child: Text('Sélectionner l\'heure'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (eventName.isNotEmpty && _selectedDay != null) {
                  final eventDate = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  addEvent(eventName, eventDate);
                  Navigator.of(context).pop();
                } else {}
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  bool hasEventsForDay(DateTime day) {
    return calendarItems.any((item) =>
        item.eventDate.year == day.year &&
        item.eventDate.month == day.month &&
        item.eventDate.day == day.day);
  }

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
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
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
                    availableCalendarFormats: {
                      CalendarFormat.month: 'Mois',
                      CalendarFormat.twoWeeks: '2 Semaines',
                      CalendarFormat.week: 'Semaine',
                    },
                    eventLoader: (day) => hasEventsForDay(day) ? [day] : [],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      _showAddEventDialog(context);
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
