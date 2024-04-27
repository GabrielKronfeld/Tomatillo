import 'package:time_planner/time_planner.dart';

import 'tpTask.dart';
import 'package:sqflite/sqflite.dart';

//DONE: replace Dogs with the new timed-event Obj
//Need to generate a random ID for the tpTask that doesn't conflict.
//make a persistent counter, every time an object is made we increment the counter
//that counter is the ID, if 2^64 is reached we overflow and then we start erasing objects. not
//a big deal since we would need 2^64 memory addresses to fit it all.
// 2^64= approx 2k petabytes
//2^64 different addresses on a 64 bit pc would be 128k petabytes, 128 exabytes.
//*technically* an unadressed bug, but come on. not worth worrying about. 

//returns a list of TPTask objects from the database
Future<List<TPTask>> TPTasks(Future<Database> database) async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the TPTasks.
  final List<Map<String, Object?>> TPTaskMaps = await db.query('TPTasks');

  List<TPTask> TPTaskList = [];

  // Convert the list of each TPTask's fields into a list of `TPTask` objects.

//iterating over the list to make the returning List explicitly, as the example doesn't work in the guide
  for (var i = 0; i < TPTaskMaps.length; i++) {
    TPTaskList.add(
      TPTask(
          id: TPTaskMaps[i]['id'] as int,
          title: TPTaskMaps[i]['title'] as String,
          minutesDuration: TPTaskMaps[i]['minutesDuration'] as int,
          dateTime: TimePlannerDateTime(
            day: TPTaskMaps[i]['DateTimeDay'] as int, 
            hour: TPTaskMaps[i]['DateTimeHour'] as int, 
            minutes: TPTaskMaps[i]['DateTimeMinutes'] as int),
      ),

    );
  }

  return TPTaskList;
  /* doesn't work, idk why, idk why you'd even want to use the shortcut tbh.
return [
    for (final {
          'id': id as int,
          'name': name as String,
          'age': age as int,
        } in TPTaskMaps)
      TPTask(id: id, name: name, age: age),
  ];*/
}

Future<void> insertTPTask(TPTask TPTask, Future<Database> database) async {
  final db = await database;

  //need to map the vals to acceptable format
  //table to insert into, row to be inserted
  db.insert(
    'TPTasks',
    TPTask.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateTPTasks(TPTask TPTask, Future<Database> database) async {
  final db = await database;

  db.update(
    'TPTasks',
    TPTask.toMap(),
    where: 'id = ?',
    whereArgs: [TPTask.id],
  );
}

//delete a row based off the provided ID.
Future<void> deleteTPTasks(int id, Future<Database> database) async {
  final db = await database;

  db.delete('TPTasks', where: 'id=?', whereArgs: [id]);
}
