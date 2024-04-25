import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calendar_item.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
                    eventDate: item['EventDate'].toString(),
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
    final url = Uri.parse('http://localhost:8000/calendar/create').replace(
      queryParameters: {
        'eventName': eventName,
        'eventDate': eventDate.toString(),
      },
    );

    final response = await http.post(url);
    if (response.statusCode == 200) {
      fetchEvent();
    } else {
      throw Exception('Failed to add event');
    }
  }

  void _showAddEventDialog(BuildContext context) {
    String eventName = '';
    DateTime? eventDate;

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
              TextButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2025),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        eventDate = selectedDate;
                      });
                    }
                  });
                },
                child: Text(
                  eventDate != null
                      ? 'Date: ${eventDate!.day}/${eventDate!.month}/${eventDate!.year}'
                      : 'Sélectionner une date',
                ),
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
                if (eventName.isNotEmpty && eventDate != null) {
                  addEvent(eventName, eventDate!);
                  Navigator.of(context).pop();
                } else {
                 
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
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
