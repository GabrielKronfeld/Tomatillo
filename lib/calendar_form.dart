import 'dart:core';
import 'dart:ffi';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_planner/time_planner.dart';
import 'package:tomatillo_flutter/calendar_page.dart';
import 'package:tomatillo_flutter/database.dart';
import 'package:tomatillo_flutter/tptask.dart';
import 'main.dart';
import 'settings_page.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//When you save, post all the data to a sqlite db.
//make a new timed-event object, near-identical to the timer_indicator. separate file.
//THEN, export the filled data into the database
//THEN load all data from db into the timer-indicator time
//DONE^^^

//TODO move the cupertinoButtons into a new widget for cleanliness
// ^ or change the style of buttons etc to make it look nicer. later.
//TODO give UID based on previous UID in db? this would be done by finding the greatest UID , and +1ing that,
//I guess we kind of already do that with the method we use NOW, what with the sharedprefs tracking it, keeping it O(1)
class EventForm extends StatefulWidget {
  final Function() notifyParent;
  var modifiedID;
  // ignore: prefer_const_constructors_in_immutables
  EventForm({super.key, required this.notifyParent, this.modifiedID});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  @override
  void initState() {
    super.initState();
    database = openDB();
  }

  late Future<Database> database;
  String title = "";
  String day = "";
  TimeOfDay startTime = TimeOfDay.now();
  //will need to move to TimeoFDay when leaving cupertino
  TimeOfDay duration = const TimeOfDay(hour: 1, minute: 0);

  bool oneTimeEventBool = false;
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
    print('duration ${startTime}');
    print(DateTime.now().weekday);
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
              onSaved: (newValue) => title = newValue ?? "Unnamed Block",
            )),
            Padding(
              padding: const EdgeInsets.all(8),
              
              child: DropdownMenu<String>(
                //DateTime/now().weekday outputs 1-7, I want 0-6, so we shift the value
                initialSelection: days[DateTime.now().weekday%7],
                //we use the map function to iterate over the days list, and for each value
                //(we call the iterated value "day", we assign it to value and label in
                //a new DropdownMenuEntry object, and then push that object to a new list)
                //need to set the DAY of the Datetime to this day now.
                dropdownMenuEntries: days
                    .map((day) => DropdownMenuEntry(value: day, label: day))
                    .toList(),
                onSelected: (value) {
                  //NOTE! Possibly causing a bug here. will need an error catch for null value either here or at the end.
                  day = value!;
                  print('value$value');
                },
              ),
            ),
            TextButton(
                child: Text(
                    'Start Time: ${startTime.hour} : ${startTime.minute} '),
                onPressed: () async {
                  final TimeOfDay? starttime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {
                    startTime = starttime ?? TimeOfDay.now();
                  });
                  
                  print(startTime);
                }),
            TextButton(
                child: Text(
                    'Duration: ${duration.hour} hours ${duration.minute} minutes'),
                onPressed: () async {
                  final TimeOfDay? tempduration = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.input,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  setState(() {
                    duration = tempduration ?? duration;
                  print(duration);
                  });
                  
                }),
            Row(
              children: [
                const Text('One-time event?'),
                Switch(
                    value: oneTimeEventBool,
                    onChanged: (bool newval) {
                      setState(() {
                        oneTimeEventBool = newval;
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
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      if (_formKey.currentState!.validate()) {
                        print('VALIDATED');
                        print('title$title');
                        print('Day$day');
                        print('starttime$startTime');
                        print('duration$duration');
                        print('bool$oneTimeEventBool');
                        print(1 == true);
                        print(0 == false);
                        print(2 == true);
                        print(2 == false);
                        _formKey.currentState!.save();
                        if (day == "") {
                          day = days[DateTime.now().weekday];
                        }
                        //if it's a new task
                        if (widget.modifiedID == null) {
                          insertTPTask(
                              //NEED TO ADD THE PROPER DATE TIME DATA!!!
                              TPTask(
                                id: await returnIntPref('CalendarEntries'),
                                title: title,
                                minutesDuration:
                                    duration.hour * 60 + duration.minute,
                                dateTime: TimePlannerDateTime(
                                    //days.indexOf(Day) theorectically could cause a bug
                                    day: days.indexOf(day),
                                    hour: startTime.hour,
                                    minutes: startTime.minute),
                                oneTimeEvent: oneTimeEventBool ? 1 : 0,
                              ),
                              database);
                          //increment CalendarEntries
                          int data = (prefs.getInt('CalendarEntries') ?? 0) + 1;
                          prefs.setInt('CalendarEntries',
                              data); //update shared preferences
                          MyHomePageState.mainVars['CalendarEntries'] =
                              prefs.getInt(
                                  'CalendarEntries'); //update mainVars for future

                          print(TPTasks(database));
                        }
                        //we have a modifiedID, passed from modify_form, meaning this is updating a task
                        else {
                          updateTPTasks(
                              //NEED TO ADD THE PROPER DATE TIME DATA!!!
                              TPTask(
                                id: widget.modifiedID,
                                title: title,
                                minutesDuration:
                                    duration.hour * 60 + duration.minute,
                                dateTime: TimePlannerDateTime(
                                    //days.indexOf(Day) theorectically could cause a bug
                                    day: days.indexOf(day),
                                    hour: startTime.hour,
                                    minutes: startTime.minute),
                                oneTimeEvent: oneTimeEventBool ? 1 : 0,
                              ),
                              database);
                        }
                      }
                      MyCalendarPage.sampletext = title;

                      widget.notifyParent();
                      //^doesn't seem to work though...
                      //not SUPER sure about mounted, but it gets rid
                      //of the linter, I guess !mounted when still waiting for async data?
                      //re: mounted docs on flutter.dev
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
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

//these are unneeded, in future we'll put these in a separate file and
  /// distribute here and in settings_page too. make the project cleaner.
  Future<int> returnIntPref(String string) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(string)!;
  }

  Future<String> returnStrPref(String string) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(string)!;
  }
}
