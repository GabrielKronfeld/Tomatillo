import 'dart:core';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'calendar_form.dart';
import 'calendar_page.dart';
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

class ModifyEventForm extends StatefulWidget {
  final Function() notifyParent;
  int id = -1;
  String title = "";
  // ignore: prefer_const_constructors_in_immutables
  ModifyEventForm(
      {super.key,
      required this.notifyParent,
      required this.id,
      required this.title});

  @override
  State<ModifyEventForm> createState() => _ModifyEventFormState();
}

class _ModifyEventFormState extends State<ModifyEventForm> {
  @override
  void initState() {
    super.initState();
    database = openDB();
  }

  var database;
  late var myid = widget.id;
  late var mytitle = widget.title;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mytitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    //replace the form with new form to update material, reuse calendar_form, but sub in the ID with the current ID.
                    //when returnTPTask completes the async part, the returned value gets sent to updateTPTasks
                    //this took me like an hour to make 2 lines. dear lord.
                    //returnTPTask(database, myid)
                    //   .then((value) => updateTPTasks(value, database));
                    Navigator.of(context).pop();
                    await showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  EventForm(
                                      notifyParent: widget.notifyParent,
                                      modifiedID: myid),
                                ],
                              ),
                            ));
                    print('buttonmodify');
                  },
                  //add padding here, and later remove the + button for a nav bar at the bottom
                  child: const Text("Modify task"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  onLongPress: () {
                    //delete task, update the events page, then pop the context to return to parent.
                    deleteTPTasks(myid, database);
                    widget.notifyParent();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Delete task: hold button"),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/main');
                    },
                    icon: Icon(Icons.punch_clock_rounded),
                    label: Text('Pomodoro for this event')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
