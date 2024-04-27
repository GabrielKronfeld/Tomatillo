import 'package:time_planner/time_planner.dart';




class TPTask extends TimePlannerTask{
  final int id;
  final String title;



  const TPTask({
    super.key,
    required this.id,
    required this.title,
    required super.minutesDuration,
    required super.dateTime,
    

   
});

//need *a* function to turn an obj to a map to insert in db
Map<String, Object> toMap(){
  return{
    'id':id,
    'title':title,
    'minutesDuration': minutesDuration,
    'dateTimeDay':dateTime.day,
    'dateTimeHour':dateTime.hour,
    'dateTimeMinutes':dateTime.minutes,
    //'color':(color??'0x00000').toString(),//unsure of this. don't feel like implementing color atm.

  };
}

  //@override
  //this brings an error, likely a bug in dart though.
  //unnecessary, but helps us visualize data. specifically when printing the list of Dog, vs printing the list of <String,Object?> of the raw db.
  //   String toString() {
  //   return '''Dog{
  //     id: $id, 
  //     title: $title, 
  //     minutesDuration: $minutesDuration,
  //     dateTimeDay: $dateTime.day
  //     dateTimeHour: $dateTime.hour,
  //     dateTimeMinutes: $dateTime.minutes,
  //     color:$color,
  //   }''';
  // }


}