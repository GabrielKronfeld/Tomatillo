import 'main.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

class MyCalendarPage2 extends StatefulWidget {
  const MyCalendarPage2({super.key});

  @override
  State<MyCalendarPage2> createState() => MyCalendarPageState();
}

class MyCalendarPageState extends State<MyCalendarPage2> {
  

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('return to home yippeeee'),
                ),
              ),
          Expanded(
            child:TimePlanner(
              // time will be start at this hour on table
              startHour: 6,
              // time will be end at this hour on table
              endHour: 23,
              setTimeOnAxis: true,
              // each header is a column and a day
              headers: [
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
                TimePlannerTitle(
                  date: "",
                  title: "Saturday")
              ],
              // List of task will be show on the time planner
              tasks: tasks,
            ),
          ),
        ],
      ),
    );
  }
}
