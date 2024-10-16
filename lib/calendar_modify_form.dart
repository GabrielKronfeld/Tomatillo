import 'dart:core';
import 'package:flutter/material.dart';
import 'calendar_form.dart';
import 'package:tomatillo_flutter/database.dart';
import 'main.dart';

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
    returnTPTask(database, myid)
        .then((value) => timeToRun = value.minutesDuration*60)
        .whenComplete(() => cycles =
            (timeToRun ~/ // ~/ operator is: division, drop remainder
                (MyHomePageState.mainVars['Work Time'] +
                        MyHomePageState.mainVars['Break Time'])
                    .toInt()));
  }

  var database;
  late var myid = widget.id;
  late var mytitle = widget.title;
  late var timeToRun;
  late var cycles;

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
                //for now this doesn't work. we'll keep it off.
                /*
                ElevatedButton.icon(
                    onPressed: ()  {
                      //literally does not work as intended.
                      setState(() {
                      MyMainPageState().mytable['runinstantTimer']=true;
                      MyMainPageState().mytable['timetorun']=timeToRun;
                      MyMainPageState().mytable['cycles']=cycles;
                      print(MyMainPageState().mytable);
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                      print(MyMainPageState().mytable);
                      });

                    },
                    icon: Icon(Icons.punch_clock_rounded),
                    label: Text('Pomodoro for this event')
                    ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
