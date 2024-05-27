import 'package:flutter/cupertino.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';
import 'calendar_form.dart';
import 'database.dart';
import 'tptask.dart';

//DONE Add a way to add events
//DONE pop-out widget, with a toggle for one-time/repeating event.
//DONE add a way to SAVE the forms
//DONE based off saved forms, generate a new calendar event
//DONE save the calendar event persistently

//TODO:

//load all saved calendar events on app-open
//^pull all events from database, add them to tasks list.
//add way to delete tasks!
//add way to get rid of one-time events. hard when we don't have a proper date/time management handler here...
//  add a CLEAN way to show the time/date (yeah fair.)
//  update each week based on tehe time
//add a way to pinch/zoom out to see the whole schedule (low prio)
//maybe find a way to shrink the height of the time (rows?) (low prio)

class MyCalendarPage extends StatefulWidget {
  MyCalendarPage({super.key});

  DateTime timeofDay = DateTime.now();
  static String sampletext = "sampletext";

  @override
  State<MyCalendarPage> createState() => MyCalendarPageState();
}

class MyCalendarPageState extends State<MyCalendarPage> {
  late Future<List<TPTask>> futureTasksList;

  @override
  void initState() {
    super.initState();
    futureTasksList = TPTasks(openDB());
  }

  //update CalendarPage state when child widget passes new data
  refresh() {
    setState(() {});
  }

// List<TimePlannerTask> getTasksList() {
//   //list of all database tasks
//   List<TimePlannerTask> templist=[];
//   //remove the as List, and then rebuild with a futureBuilder.
//   for (var i in tasks as List<TPTask>){
//     templist.add(
//       TimePlannerTask(
//         // background color for task
//         color: Theme.of(context).cardColor,
//         // day: Index of header, hour: Task will be begin at this hour
//         // minutes: Task will be begin at this minutes
//         dateTime: TimePlannerDateTime(
//             day: i.dateTime.day,
//             hour: i.dateTime.hour,
//             minutes: i.dateTime.minutes),
//         // Minutes duration of task
//         minutesDuration: i.minutesDuration,

//         // Days duration of task (use for multi days task)
//         daysDuration: 1,
//         onTap: () {
//           setState(() {});
//         },
//         child: Text(
//           i.title,
//           style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
//         ),
//       )
//     );
//   }
//   return templist;

// }

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
    var textforTask = 'this is a task';
    //update the list of tasks based on the database.
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
          textforTask,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
        ),
      ),
    ];
    // tasks.addAll(getTasksList());
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
                      children: <Widget>[
                        EventForm(notifyParent: refresh),
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
            Text(MyCalendarPage.sampletext),
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
            Expanded(
                child: FutureBuilder<List<TPTask>>(
              future: futureTasksList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<TPTask>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    ),
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ];
                } else {
                  children = const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
