
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'calendar_page.dart';
import 'calendar_page2.dart';
import 'timer_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
//MAKE SURE ALL AUDIO IS IN FLUTTER ASSETS IN THE PUBSPEC.YAML
import 'package:audioplayers/audioplayers.dart';
import 'package:calendar_view/calendar_view.dart';
import 'timer_logic.dart';
import 'all_theme_colors.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

/**
 * 
 * required this.minutesDuration,
      required this.dateTime,
      this.daysDuration,
      this.color,
      this.onTap,
      this.child,
      this.leftSpace,
      this.widthTask})
 */


class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => MyMainPageState();
}
//maybe make 2 new classes and whole pages for settings and calendar, and just build them like that?
//I guess we'll find out if the session is paused, interupted, or continues as normal while in a different widget.

class MyMainPageState extends State<MyMainPage> {

  //logic vars
  int mainTimerCount = 0; //main timer count for pomodoro timer
  int totalTimeForCycleinSeconds = 0;
  int cyclesRemaining = 0;
  int timeRemaining = 0; //overflow time when jump to pause/break time.
  bool onBreak = false; //are we on a break or on a work session?
  bool setPaused = false;
  bool timerExists = false; //does a timer currently exist/are we on a cycle?
//we can probably replace this with if mainVars['Total Cycles']>1? no. if we pause the timer then we need to
//save time remaining, kill timer, run remaining time on a single timer, then run regular timer again, right?
//maybe we go for that a little later.
  bool forceEnd = false;
  //testing vars
  String tempDidWeFinish =
      ''; //acts as a way to display state so we have our prototype
  //before we start working on adding widget changes and building new components based on state.
  //I think we'll need to change the var names and structure a bit for clarity. onBreak vs setPaused vs timerExists are very similar and should be made
  //more DISTINCT.

  final player = AudioPlayer();

  //what we do on start. Just so we can add things to the start of the work session if need be.
  //TIMER EXISTS WHEN WE WANT TO END THE BREAK EARLY! WORK SESSSION DOES NOT GO!
  _startPomodoro() {
    if (!timerExists) {
      tempDidWeFinish = 'onPomodoro!';
      _startWorkSession(MyHomePageState.mainVars['Work Time'], MyHomePageState.mainVars['Total Cycles']);
    }
  }

  //using recursion to sort this shit out. garbage code. very bad. D--
  _startTimer(timeToRun, cycles) {
    //once every second, decrease the time by a second (duh)
    setState(() {
      timerExists = true;
    });
    mainTimerCount =
        timeToRun + (MyHomePageState.mainVars['Overflow Time'] ? timeRemaining : 0);
    totalTimeForCycleinSeconds = mainTimerCount;
    timeRemaining = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      print('timer count: $mainTimerCount');
      setState(() {
        if (!(mainTimerCount < 1 || setPaused)) {
          //if we don't have an end condition, tick a second.
          mainTimerCount--;
        } else {
          //all end conditions/swap state logic
          if (setPaused) {
            timeRemaining =
                mainTimerCount; //if we set pause, we add remaining time to next break time
            //now we have to make sure we go to the break.
            //we can do onBreak=!onBreak to skip both sides this way. that way
            //the button becomes less toBREAK and more end-early, saving time.
            //currently ALWAYS goes to a break and stacks break time. not the worst idea for now.
            setPaused = false;
            onBreak = false;
          }
          timer.cancel();
          timerExists = false;
          print('$cycles, $onBreak,$setPaused ');

          if (forceEnd) {
            //force end event.
            forceEnd = false; //maybe this could cause issues? I don't think so.
            onBreak = false;
            setPaused = false;
            cyclesRemaining = 0;
            timeRemaining = 0;
            mainTimerCount = 0;
            tempDidWeFinish = "forced the end!";
          } else if (cycles > 1) {
            //if we have a cycle left, then we do a work/break cycle. else, we only do a work cycle.
            if (onBreak) {
              _startWorkSession(MyHomePageState.mainVars['Work Time'], cycles - 1);
              onBreak = false;
              tempDidWeFinish = "currently at work";
            } else {
              _startBreak(MyHomePageState.mainVars['Break Time'], cycles);
              setPaused = false;
              onBreak = true;
              tempDidWeFinish = "currently on a break";
            }
          } else {
            tempDidWeFinish = "finished a whole set!";
            //completion event. if no more cycles, and we finish.
            //this can only happen during a _startBreak session which doesn't make much sense.
            //why force yourself to sit through the break?
          }
        }
      });
    });
    print('ENDED _startTimer()');
  } //Seems that the timer we WANT is timer.periodic,
  //since we can update the visual value along with it.
  // the original timer is just a one-of thing for events I think.

  _startWorkSession(int time, int cycle) {
    setState(() {
      cyclesRemaining = cycle - 1;
    });
    _startTimer(time, cycle);

    //add chime
    player.play(AssetSource('audio/bing.mp3'));
  }

  _startBreak(int time, int cycle) {
    player.play(AssetSource('audio/onBreak.mp3'));
    _startTimer(time, cycle); //this doesn't seem right,...
    //add *chime* I don't want to play a chime at the start, but when a cycle FINISHES...
  }

  _endPomodoro() {
    //immediately ends the session (no more work, no more break)
    setState(() {
      mainTimerCount = 0;
      forceEnd = true;
    });
  } //possibly unneeded

  _pausePomodoro() {
    //immediately jumps to the break for the cycle, extra remaining time is added to the break
    setState(() {
      setPaused = true;
    });
  }

  //WIDGET BUILD
  breakOrAlterSession(onBreak) {
    print('timer: $timerExists');
    if (!timerExists) {
      return (ElevatedButton.icon(
        onPressed: () {
          _startPomodoro();
        },
        icon: const Icon(Icons.access_alarm),

        //add padding here, and later remove the + button for a nav bar at the bottom
        label: const Text("Begin Session"),
      ));
    } else {
      return (Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              _endPomodoro();
            },
            icon: const Icon(Icons.stop_circle),
            label: const Text("End Session Early"),
          ),
          (!onBreak)
              ? (ElevatedButton.icon(
                  onPressed: () {
                    _pausePomodoro();
                  },
                  icon: const Icon(Icons.pause_circle_outline),
                  label: const Text("Start Break Early"),
                ))
              : (ElevatedButton.icon(
                  onPressed: () {
                    print("object");
                    setState(() {
                      onBreak = false;
                      _startPomodoro();
                    });
                  },
                  icon: const Icon(Icons.pause_circle_outline),
                  //TODO: ADD LOGIC SO WHEN WE RESTART AFTER THE BREAK WE DON'T LOSE OUR TIME.
                  //the whole end break early logic doesn't work, I think.
                  //if we start a break early, it just appends the time to the next timer. not next break, but even next set.
                  label: const Text("End Break Early"),
                )),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    int minutes = (mainTimerCount / 60).floor();
    int seconds = mainTimerCount % 60;
    int currentIndex = 1;
    Widget beginOrAlterSession = breakOrAlterSession(onBreak);

    return Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SizedBox.expand(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    tempDidWeFinish,
                  ),
                ),
                //hiding TimerIndicator when not in use
                timerExists
                    ? TimerIndicator(
                        totalTimeinSeconds: totalTimeForCycleinSeconds,
                        minutes: minutes,
                        seconds: seconds,
                      )
                    : Container(width: 50, height: 50),
                Padding(padding: EdgeInsetsDirectional.symmetric()),
                Text(
                  'breaks remaining: $cyclesRemaining',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20.0)),
                beginOrAlterSession,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    //we should find a way to add a 5 minute break specifically for this.
                    onPressed:(){
                      _startTimer(1200,3);
                    }, 
                    icon: const Icon(Icons.punch_clock), 
                    label: Text("Quick Hour")
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // row of buttons for the main page
                    ElevatedButton.icon(
                      //this brings us to the calendar page
                      onPressed: () {
                        //navigate to Calendar Page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCalendarPage()));
                      },
                      icon: const Icon(Icons.calendar_month),

                      //add padding here, and later remove the + button for a nav bar at the bottom
                      label: const Text("Calendar"),
                    ),
                    const Padding(padding: EdgeInsets.all(8)),

                    ElevatedButton.icon(
                      //this brings us to the calendar page
                      onPressed: () {
                        //navigate to Calendar Page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyCalendarPage2()));
                      },
                      icon: const Icon(Icons.calendar_today),

                      //add padding here, and later remove the + button for a nav bar at the bottom
                      label: const Text("Calendar"),
                    ),
                    const Padding(padding: EdgeInsets.all(8)),

                    ElevatedButton.icon(
                      onPressed: () {
                        //navigate to Setting Page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MySettingsPage()));
                      },
                      icon: const Icon(Icons.settings),

                      //add padding here, and later remove the + button for a nav bar at the bottom
                      label: const Text("Settings"),
                    ),
                    /*ElevatedButton.icon(
                      onPressed: () {
                        //navigate to Setting Page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyWidget()));
                      },
                      icon: const Icon(Icons.settings),

                      //add padding here, and later remove the + button for a nav bar at the bottom
                      label: const Text("color"),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
        ),
     );
  }
}
