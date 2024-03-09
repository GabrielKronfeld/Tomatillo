import 'main.dart';
import 'package:flutter/material.dart';



class MyCalendarPage extends StatefulWidget{
  const MyCalendarPage({super.key});
  

  @override
  State<MyCalendarPage> createState() => MyCalendarPageState();
}


class MyCalendarPageState extends State<MyCalendarPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Column(children: [



          Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
          
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('data'),
          ),


          Padding(padding: EdgeInsets.symmetric()),


          Container(
            color: Colors.amber,
          )




      ]),



    );

  }
}
    