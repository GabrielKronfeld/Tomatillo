//DONE First, make sure we don't already have a periodic timer running; we don't want concurrent runs
//DONE guarantee we have single, UNIQUE timer to be running at any given time.
//DONE check if there is currently a timer. if there IS, then do nothing FOR NOW.
//DONE if there isn't any, then we want to add one.
//DONE in future, let's add some logic so if we have one, then we can force stop, or go right to a break.
//ALL LOGIC DONE FOR NOW lmao. I thought.
//TIME TO ADD NEW UI 🤮
//DONE we can do this by adjusting the UI to remove begin session and add 2 more buttons.
//DONE we should do this on a separate row of buttons.
//DONE add Settings page
//DONE add overflow time option functionality
//DONE add background functionality
// bg func is done, without adding anything? leaves me confused but very pleased.
// Brush up the logic
//  check for extreme conditions FIRST, so check if we've forced the end FIRST, that kind of stuff.
//Add sound
// DONE-ISH -chime when timers finish
// unneeded tbh, for now. -on button press?
//DONE-for the most part-test sound samples
//DONE add Calendar  page
//DONE above done, just set it to minute:second format.
//DONE add animation for the timer
//DONE reformat displays to show minute:second time.
//DONE chime on start/end of event
//DONE import data to db
//DONE??add better memory management
//kind of a passive/persistent thing right?
//DONE make timer invisible when there is no timer running.
//DONE find out why the color seed isn't loaded properly <-- should be because V V V
//        //colorscheme isn't updating the proper color from the seed color.
//REFERENCE ORIGINAL THEME.of(context).* not context).colorscheme.* FOR THE DEEPER SHADES

//DONE replace overflow time and invisible timer with switches

//DONE pull events from db into calendar.

//DONE EXPORT data from db to calendar
//DONE hide semicircle when calendar isn't running

//DONE add way to delete calendar event
//DONEreplace form CupertinoButton with TimePicker

//TODO:

    //high priority
//classic pomodoro button
//readjust the calendar, currently everything is shifted by an hour. NOT GOOD!!
//make calendar properly update when we update db, without needing to leave and return to widget.
//update buttons in with switches in settings and NavigationBar for menu/returns. <----save for later, very important but I'm struggling
//add a way to add minutes without needing to tap 60 times.
//implement UNITS setting, //make units value work properly.

    //low priority
//make more elegant method to keep track of time. in what way? for the timer function? yeah.
//fix start break early button
//Add a dark mode!!
//make app be able to operate in background\
//widget-icon overlay thing from the top for notifications.
//add a random color to each event, giving it a random HSV of any,0-30,100-75 from HSVColor class
//add proper dings, not my voice.
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:tomatillo_flutter/main_page.dart';
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

void main() async {
  //added all
  // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  //we don't actually need to open the DB at the very
// Open the database and store the reference.
  // final database = openDatabase(
  //   // Set the path to the database. Note: Using the `join` function from the
  //   // `path` package is best practice to ensure the path is correctly
  //   // constructed for each platform.
  //   join(await getDatabasesPath(), 'calendar_events.db'),
  //   onCreate: (db, version) {
  //     // Run the CREATE TABLE statement on the database.
  //     return db.execute(
  //       'CREATE TABLE events(id INTEGER PRIMARY KEY, name TEXT, minutesduration INTEGER, startDay INTEGER, startHour INTEGER, startMinute INTEGER)',
  //     );
  //   },
  //   // Set the version. This executes the onCreate function and provides <--good to know!
  //   // a path to perform database upgrades and downgrades.
  //   version: 1,
  // );
  //loading the DB BEFORE we run the app. ...maybe inefficient actually. might wanna swap order.
  runApp(const MyApp());
}
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

class MyApp extends StatelessWidget {
  //maybe should be statefulWidget?
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: Colors.green,
    );
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        title: 'Tomatillo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              //colorscheme isn't updating the proper color from the seed color.
              //REFERENCE ORIGINAL THEME.of(context).* not context).colorscheme.* FOR THE DEEPER SHADES
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 25, 68, 26)),
        ),
        home: const MyHomePage(title: 'Tomatillo\n🐸🍅🐸🍅🐸🍅🐸'),
      ),
      // Your initialization for material app.
    );
    // return MaterialApp(
    //   title: 'Tomatillo',
    //   theme: ThemeData(
    //     useMaterial3: true,
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    //   ),
    //   home: const MyHomePage(title: 'Tomatillo\n🐸🍅🐸🍅🐸🍅🐸'),
    // );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}
//maybe make 2 new classes and whole pages for settings and calendar, and just build them like that?
//I guess we'll find out if the session is paused, interupted, or continues as normal while in a different widget.

class MyHomePageState extends State<MyHomePage> {
//instead of having all these vars like this, put them all in a dictionary!!
  static Map mainVars = {
    'Work Time': 10, //total time for work session
    'Break Time': 5, //total time for break session
    'Total Cycles': 3, //total work/break cycles to run
    'CalendarEntries':
        0, //how many entries ever made for Calendar. Used for UID in db.
    'Overflow Time': true,
    'Invisible Timer': false,
    'Units': 'seconds',
  };

//next we want to put these into persistent memory
//NOTE: ALL PERSISTENT MEMORY KEYS **MUST** MATCH mainVars KEYS
//pulls data for our map from persistent memory
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //if we ever have more than like 10 vars, we'll need to properly systematize this. use iteration and type checking.
      // mainVars['Work Time'] = prefs.getInt('Work Time') ?? mainVars['Work Time'];
      // mainVars['Break Time'] = prefs.getInt('Break Time') ?? mainVars['Break Time'];
      // mainVars['Total Cycles'] = prefs.getInt('Total Cycles') ?? mainVars['Total Cycles'];
      // mainVars['Overflow Time'] = prefs.getBool('Overflow Time') ?? mainVars['Overflow Time'];
//If the stored data is null, update it with the base data. otherwise, update the base data with the stored data.
      prefs.getInt('Work Time') == null
          ? (prefs.setInt('Work Time', mainVars['Work Time']))
          : (mainVars['Work Time'] = prefs.getInt('Work Time'));

      prefs.getInt('Break Time') == null
          ? (prefs.setInt('Break Time', mainVars['Break Time']))
          : (mainVars['Break Time'] = prefs.getInt('Break Time'));

      prefs.getInt('Total Cycles') == null
          ? (prefs.setInt('Total Cycles', mainVars['Total Cycles']))
          : (mainVars['Total Cycles'] = prefs.getInt('Total Cycles'));

      prefs.getInt('CalendarEntries') == null
          ? (prefs.setInt('CalendarEntries', mainVars['CalendarEntries']))
          : (mainVars['CalendarEntries'] = prefs.getInt('CalendarEntries'));

      prefs.getBool('Overflow Time') == null
          ? (prefs.setBool('Overflow Time', mainVars['Overflow Time']))
          : (mainVars['Overflow Time'] = prefs.getBool('Overflow Time'));

      prefs.getBool('Invisible Timer') == null
          ? (prefs.setBool('Invisible Timer', mainVars['Invisible Timer']))
          : (mainVars['Invisible Timer'] = prefs.getBool('Invisible Timer'));

      prefs.getString('Units') == null
          ? (prefs.setString('Units', mainVars['Units']))
          : (mainVars['Units'] = prefs.getString('Units'));
    });
  }

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //WIDGET BUILD
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    int currentIndex = 1;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context)
            .colorScheme
            .primaryContainer, //not updating color properly?? idk why.
        selectedIndex: currentIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: "Schedule"),
          NavigationDestination(icon: Icon(Icons.timelapse), label: "Home"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
            print('index:AAAA$currentIndex');
            //this WORKS but it's not what we want to have happen
            //does it??? yes, but we aren't updating the currentindex onclick for some reason...
          });
        },
      ),
      body: <Widget>[
        MyCalendarPage(),
        MyMainPage(),
        MySettingsPage(),
      ][currentIndex],//can I not just pop whatever I want?
    );
  }
}
