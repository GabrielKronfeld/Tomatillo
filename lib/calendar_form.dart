import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_planner/time_planner.dart';
import 'package:tomatillo_flutter/calendar_page.dart';
import 'main.dart';
import 'settings_page.dart';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


//TODO move the cupertinoButtons into a new widget for cleanliness
//When you save, post all the data to a sqlite db.

class EventForm extends StatefulWidget {
  const EventForm({super.key});

  @override
  State<EventForm> createState() => _EventFormState();
}


class _EventFormState extends State<EventForm>  {
  String title = "";
  String Day = "";
  DateTime startTime = DateTime.now();
  DateTime duration = DateTime.now();
  bool oneTimeEvent = false;
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      //Title, Day, Time (when to when), Color
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Add new event to calendar',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Flexible(
                child: TextFormField(
              decoration: const InputDecoration(helperText: 'Event Title'),
              onSaved: (newValue) => title=newValue??"Unnamed Block",
            )),
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownMenu<String>(
                //we use the map function to iterate over the days list, and for each value
                //(we call the iterated value "day", we assign it to value and label in
                //a new DropdownMenuEntry object, and then push that object to a new list)
                dropdownMenuEntries: days
                    .map((day) => DropdownMenuEntry(value: day, label: day))
                    .toList(),
                onSelected: (value) {
                  print(value);
                },
              ),
            ),
            Row(
              //should separate the CupertinoButton into a separate widget since you call it twice almost identically.
              //TODO later, little tired. 
              children: [
                //cupertinoButton to add way to change time for value saved in tiems
                CupertinoButton(
                  child: Text('Start Time'),
                  onPressed: () => showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => Container(
                      height: 216,
                      padding: const EdgeInsets.only(top: 6.0),
                      // The Bottom margin is provided to align the popup above the system
                      // navigation bar.
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      // Provide a background color for the popup.
                      color:
                          CupertinoColors.systemBackground.resolveFrom(context),
                      // Use a SafeArea widget to avoid system overlaps.
                      child: SafeArea(
                        top: false,
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          // This is called when the user changes the time.
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => startTime = newTime);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Text('${startTime.hour}:${startTime.minute}'),
              ],
            ),
            Row(
              children: [
                //cupertinoButton to add way to change time for value saved in tiems
                CupertinoButton(
                  child: Text('Duration'),
                  onPressed: () => showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => Container(
                      height: 216,
                      padding: const EdgeInsets.only(top: 6.0),
                      // The Bottom margin is provided to align the popup above the system
                      // navigation bar.
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      // Provide a background color for the popup.
                      color:
                          CupertinoColors.systemBackground.resolveFrom(context),
                      // Use a SafeArea widget to avoid system overlaps.
                      child: SafeArea(
                        top: false,
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          // This is called when the user changes the time.
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => duration = newTime);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Text('${duration.hour}:${duration.minute}'),
              ],
            ),
            Row(
              children: [
                const Text('One-time event?'),
                Switch(
                    value: oneTimeEvent,
                    onChanged: (bool newval) {
                      setState(() {
                        oneTimeEvent = newval;
                      });
                    })
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(2)),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('object');
                        _formKey.currentState!.save();
                      }
                      MyCalendarPage.sampletext=title;

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
