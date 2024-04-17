import 'package:flutter/cupertino.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';
import 'calendar_form.dart';

//TODO:
//Add a way to add events
// DONE pop-out widget, with a toggle for one-time/repeating event.
//add a way to SAVE the forms
//based off saved forms, generate a new calendar event
//save the calendar event persistently
//load all saved calendar events on app-open
//  add a CLEAN way to show the time/date
//  update each week based on tehe time
//add a way to pinch/zoom out to see the whole schedule
//maybe find a way to shrink the height of the time (rows?)

class MyCalendarPage extends StatefulWidget {
  MyCalendarPage({super.key});

  DateTime timeofDay = DateTime.now();
  static String sampletext = "a";

  @override
  State<MyCalendarPage> createState() => MyCalendarPageState();
}

class MyCalendarPageState extends State<MyCalendarPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    Color bgColor = Theme.of(context).colorScheme.primaryContainer;

    TimePlannerStyle style = TimePlannerStyle(
      backgroundColor: bgColor,
      showScrollBar: true,
      cellHeight: 40,
      cellWidth: 90,
      dividerColor: theme.background,
      //horizontalTaskPadding: 8.0,
    );

    List<TimePlannerTask> tasks = [
      TimePlannerTask(
        // background color for task
        color: Theme.of(context).cardColor,
        // day: Index of header, hour: Task will be begin at this hour
        // minutes: Task will be begin at this minutes
        dateTime: TimePlannerDateTime(
            day: 1,
            hour: widget.timeofDay.hour,
            minutes: widget.timeofDay.minute),
        // Minutes duration of task
        minutesDuration: 190,

        // Days duration of task (use for multi days task)
        daysDuration: 1,
        onTap: () {
          setState(() {});
        },
        child: Text(
          'this is a task',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
        ),
      ),
    ];

   return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).cardColor,
        focusColor: Theme.of(context).cardColor,
        child: const Icon(Icons.add),
        onPressed: () async {
          await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                    content: Stack(
                      clipBehavior: Clip.none,
                      children: const <Widget>[
                        EventForm(),
                      ],
                    ),
                  ));
        },
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('return to home yippeeee'),
              ),
             
            ),
            Text('${MyCalendarPage.sampletext}'),
            Expanded(
              child: TimePlanner(
                style: style,
                // time will be start at this hour on table
                startHour: 6,
                // time will be end at this hour on table
                endHour: 23,
                setTimeOnAxis: false,

                // each header is a column and a day
                headers: const [
                  TimePlannerTitle(
                    date: "3/10/2021",
                    title: "Sunday",
                  ),
                  TimePlannerTitle(
                    date: "3/2024",
                    title: "Monday",
                  ),
                  TimePlannerTitle(
                    date: "3/12/2021",
                    title: "Tuesday",
                  ),
                  TimePlannerTitle(
                    date: "3/10/2021",
                    title: "Wednesday",
                  ),
                  TimePlannerTitle(
                    date: "3/11/2021",
                    title: "Thursday",
                  ),
                  TimePlannerTitle(
                    date: "3/12/2021",
                    title: "Friday",
                  ),
                  TimePlannerTitle(date: "", title: "Saturday"),
                ],

                // List of task will be show on the time planner
                tasks: tasks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
