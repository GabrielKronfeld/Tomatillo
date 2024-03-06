import 'package:flutter/material.dart';
import 'black_bar_padding.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MySettingsPage extends StatefulWidget{
  const MySettingsPage({super.key});
  

  @override
  State<MySettingsPage> createState() => MySettingsPageState();
}


class MySettingsPageState extends State<MySettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SafeArea(
          child: Column(
            children:[
              const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
              ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Home!'),
              ),

              const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),

              SizedBox(
                height:45.0,
                child: SettingsModifierWidget(valueName: 'Work Time')//this might get a bit messy and hard to upscale. but it works.

              ),
              const BlackBarPadding(),
              SizedBox(
                height:45.0,
                child: SettingsModifierWidget(valueName: 'Break Time')//is this the way to do this?

              ),
              const BlackBarPadding(),

              SizedBox(
                height:45.0,
                child: SettingsModifierWidget(valueName: 'Total Cycles',)

              ),
              const BlackBarPadding(),

              SizedBox(
                height:45.0,
                child: SettingsModifierWidget(valueName: 'Units',)

              ),
              const BlackBarPadding(),

              SizedBox(
                height:45.0,
                child: SettingsModifierWidget(valueName: 'Overflow Time',)

              ),
            
            //  SettingsModifierWidget(),
            ]
          ),
        )
        /*
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Home!'),
        )*/
      )
    ); 
  }
}






// ignore: must_be_immutable
class SettingsModifierWidget extends StatefulWidget{
  String valueName='';

  SettingsModifierWidget({super.key, required this.valueName});

  @override
  State<SettingsModifierWidget> createState() => SettingsModifierWidgetState();
}

class SettingsModifierWidgetState extends State<SettingsModifierWidget>{

  Widget buildSettingsRow(mainVarsKey){

    if(MyHomePageState.mainVars[mainVarsKey] is int){
      //
      return Row(
      children: <Widget> [
        const Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
        Center(child: Text(widget.valueName.toString())),
        const Expanded(child: Padding(padding: EdgeInsets.symmetric())),
        //PLUS VAR
        ElevatedButton(
          onPressed: () {
            _increaseData(widget.valueName);
          }, 
          child: const Icon(Icons.add),
        ),
        //CENTERED VALUE OF VAR
        SizedBox(
          width: 40.0,
          child: Center(
            child: Text(MyHomePageState.mainVars[widget.valueName].toString())
          ),
        ),
        //MINUS VAR
        ElevatedButton(
          onPressed: () {
            _decreaseData(widget.valueName);
          },  
          child: const Icon(Icons.remove),
        ), 
      const Padding(padding: EdgeInsets.fromLTRB(0, 0, 20, 0)),
      ],
      );
    }

    if(MyHomePageState.mainVars[mainVarsKey] is bool){
      return Row(
      children: <Widget> [
        const Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
        Center(child: Text(widget.valueName.toString())),
        const Expanded(child: Padding(padding: EdgeInsets.symmetric())),
      
        //Bool Swap
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _swapLogicData(mainVarsKey);
            });
            print(mainVarsKey);
            print(MyHomePageState.mainVars);
          },  
          icon: const Icon(Icons.trending_flat),
          label: Text(MyHomePageState.mainVars[mainVarsKey].toString()),
        ), 
      const Padding(padding: EdgeInsets.fromLTRB(0, 0, 20, 0)),
      ],
      );
    }

    if(MyHomePageState.mainVars[mainVarsKey] is String){
      //
      return Row(
      children: <Widget> [
        const Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
        Center(child: Text(widget.valueName.toString())),
        const Expanded(child: Padding(padding: EdgeInsets.symmetric())),
        //PLUS VAR
        ElevatedButton(
          onPressed: () {
            _nextStringData(widget.valueName);
          }, 
          child: const Icon(Icons.add),
        ),
        //CENTERED VALUE OF VAR
        SizedBox(
          width: 40.0,
          child: Center(
            child: Text(MyHomePageState.mainVars[widget.valueName].toString())
          ),
        ),
        //MINUS VAR
        ElevatedButton(
          onPressed: () {
            _prevStringData(widget.valueName);
          },  
          child: const Icon(Icons.remove),
        ), 
      const Padding(padding: EdgeInsets.fromLTRB(0, 0, 20, 0)),
      ],
      );
    }

    else{
      //in case of null type somehow.
      return Row(
      children: <Widget> [
        const Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),

        Center(child: Text('${widget.valueName} IS NULL, SOMETHING BROKE!')),
            
        const Expanded(child: Padding(padding: EdgeInsets.symmetric())),
        const Padding(padding: EdgeInsets.fromLTRB(0, 0, 20, 0)),
      ],
      );
    }
  }

  @override
  Widget build(BuildContext context){

    Widget mainBodyofSettingsModifier = buildSettingsRow(widget.valueName);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      
      body: mainBodyofSettingsModifier,
    ); 
  }
  Future<void> _increaseData(String dataName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //this should be completely replaced with the getInt/SetInt stuff? I think. Maybe not.
      if(MyHomePageState.mainVars[dataName] is int ){
        print(prefs.getInt(dataName));
        int data = (prefs.getInt(dataName) ?? 0) + 1;//from shared preferences, this adds 1 to the int with key dataName.
        print(data);
        prefs.setInt(dataName, data); //this then updates the int with key dataName with the new int. basically a 2 line ++.
        MyHomePageState.mainVars[dataName]=prefs.getInt(dataName);
      }
    });
  }
  Future<void> _decreaseData(String dataName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //so we can't go below 1 second or 1 break.
      if(MyHomePageState.mainVars[dataName] is int && MyHomePageState.mainVars[dataName]>1){
        int data = (prefs.getInt(dataName) ?? 0) - 1;//from shared preferences, this subtracts 1 to the int with key dataName.
        prefs.setInt(dataName, data); //this then updates the int with key dataName with the new int. basically a 2 line --.
        MyHomePageState.mainVars[dataName]=prefs.getInt(dataName);//we still need to actually update the mainVars.
      }
      
    });
  }
  Future<void> _swapLogicData(String dataName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //this should be completely replaced with the getInt/SetInt stuff? I think. Maybe not.
      //currently abusing an already built widget instead of modifying it properly. could be done easily by
      //checking name of value passed, and then modifying what is in it.
      if(MyHomePageState.mainVars[dataName] is bool ){
        bool data = (prefs.getBool(dataName) ?? true);
        prefs.setBool(dataName, !data);//swap truth of the boolean
        MyHomePageState.mainVars[dataName]=prefs.getBool(dataName);
      } 
    });
  }


  Future<void> _nextStringData(String dataName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //so we can't go below 1 second or 1 break.
      if(MyHomePageState.mainVars[dataName] is int && MyHomePageState.mainVars[dataName]>1){
        int data = (prefs.getInt(dataName) ?? 0) - 1;//from shared preferences, this subtracts 1 to the int with key dataName.
        prefs.setInt(dataName, data); //this then updates the int with key dataName with the new int. basically a 2 line --.
        MyHomePageState.mainVars[dataName]=prefs.getInt(dataName);//we still need to actually update the mainVars.
      }
      
    });
  }


  Future<void> _prevStringData(String dataName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //so we can't go below 1 second or 1 break.
      if(MyHomePageState.mainVars[dataName] is int && MyHomePageState.mainVars[dataName]>1){
        int data = (prefs.getInt(dataName) ?? 0) - 1;//from shared preferences, this subtracts 1 to the int with key dataName.
        prefs.setInt(dataName, data); //this then updates the int with key dataName with the new int. basically a 2 line --.
        MyHomePageState.mainVars[dataName]=prefs.getInt(dataName);//we still need to actually update the mainVars.
      }
      
    });
  }

}
