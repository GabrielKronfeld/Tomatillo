import 'dart:core';
import 'dart:ffi';
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
  // ignore: prefer_const_constructors_in_immutables
  EventForm({super.key, required this.notifyParent});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {

  @override
  void initState() {
    super.initState();
    database = openDB();
  }

  var database;
  String title = "";
  String Day = "";
  DateTime startTime = DateTime.now();
  DateTime duration = DateTime.now();
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
                //we use the map function to iterate over the days list, and for each value
                //(we call the iterated value "day", we assign it to value and label in
                //a new DropdownMenuEntry object, and then push that object to a new list)
                //need to set the DAY of the Datetime to this day now.
                dropdownMenuEntries: days
                    .map((day) => DropdownMenuEntry(value: day, label: day))
                    .toList(),
                onSelected: (value) {
                  //NOTE! Possibly causing a bug here. will need an error catch for null value either here or at the end.
                  Day=value!;
                  print('value$value');
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
                            //does this not work properly? or does it?
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
                        print('Day$Day');
                        print('starttime$startTime');
                        print('duration$duration');
                        print('bool$oneTimeEventBool');
                        print(1==true);
                        print(0==false);
                        print(2==true);
                        print(2==false);
                        _formKey.currentState!.save();

                        insertTPTask(
                          //NEED TO ADD THE PROPER DATE TIME DATA!!!
                            TPTask(
                              id: await returnIntPref('CalendarEntries') ,
                              title: title,
                              minutesDuration:
                                  duration.hour * 60 + duration.minute,
                              dateTime: TimePlannerDateTime(
                                //days.indexOf(Day) theorectically could cause a bug
                                  day: days.indexOf(Day),
                                  hour: startTime.hour,
                                  minutes: startTime.minute),
                              oneTimeEvent: oneTimeEventBool ? 1 : 0,
                            ),
                            database);
                            //increment CalendarEntries
                            int data = (prefs.getInt('CalendarEntries') ?? 0) + 1;
                            prefs.setInt('CalendarEntries', data);//update shared preferences
                            MyHomePageState.mainVars['CalendarEntries']=prefs.getInt('CalendarEntries');//update mainVars for future

                        print(TPTasks(database));
                      }
                      MyCalendarPage.sampletext = title;


                      widget.notifyParent();
                      //not SUPER sure about mounted, but it gets rid
                      //of the linter, I guess !mounted when still waiting for async data?
                      //re: mounted docs on flutter.dev
                      if(context.mounted){
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
  Future<int> returnIntPref(String string) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(string)!;
  }
  Future<String> returnStrPref(String string) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(string)!;
  }
}
