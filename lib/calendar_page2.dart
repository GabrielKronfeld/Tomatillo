import 'package:calendar_view/calendar_view.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

class MyCalendarPage2 extends StatefulWidget {
  const MyCalendarPage2({super.key});

  @override
  State<MyCalendarPage2> createState() => MyCalendarPageState();
}

class MyCalendarPageState extends State<MyCalendarPage2> {
  


    //this is the fancier, more in-depth calendar import

  @override
  Widget build(BuildContext context) {


    List<TimePlannerTask> tasks = [
    TimePlannerTask(
      // background color for task
      color: Theme.of(context).cardColor,
      // day: Index of header, hour: Task will be begin at this hour
      // minutes: Task will be begin at this minutes
      dateTime: TimePlannerDateTime(day: 0, hour: 14, minutes: 30),
      // Minutes duration of task
      minutesDuration: 190,
      // Days duration of task (use for multi days task)
      daysDuration: 1,
      onTap: () {},
      child: Text(
        'this is a task',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
      ),
    ),
  ];


    Color bgColor = Theme.of(context).colorScheme.primaryContainer;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
      
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 8.0),
                  child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Home!'),
                  ),
                ),
                Expanded( child: WeekView(),),
          ],
        ),
      ),
    );
  }
}
