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

class ModifyEventForm extends StatefulWidget {
  final Function() notifyParent;
  int id=-1;
  // ignore: prefer_const_constructors_in_immutables
  ModifyEventForm({super.key, required this.notifyParent, required this.id});

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
  late var myid= widget.id;


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
            Text('Add new event to calendar event $myid',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
