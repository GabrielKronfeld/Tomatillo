import 'package:flutter/material.dart';
import 'main.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimerIndicator extends StatefulWidget {

  int totalTimeinSeconds;//as seconds
  int minutes=0;
  int seconds=0;
  TimerIndicator({super.key, required this.totalTimeinSeconds, this.minutes=0, this.seconds=0});

  @override
  State<TimerIndicator> createState() => _TimerIndicatorState();
}

class _TimerIndicatorState extends State<TimerIndicator> {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 15.0,
          percent: ((widget.totalTimeinSeconds-((widget.minutes*60)+widget.seconds))/widget.totalTimeinSeconds),
          progressColor: Colors.green,
          circularStrokeCap: CircularStrokeCap.round,
          reverse: true,
          center: Text(
                  '${widget.minutes}:${widget.seconds}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),

        ),
      ],
    );
    // return Scaffold(
    //   backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    //   body: 
    //     CircularPercentIndicator(
    //       radius: 20.0,
    //       lineWidth: 5.0,
    //       percent: ((widget.minutes*60)+widget.seconds)/widget.totalTimeinSeconds,
          
    //       progressColor: Colors.green,
    //       circularStrokeCap: CircularStrokeCap.round,
    //       center: Text(
    //               '${widget.minutes}:${widget.seconds}',
    //               style: Theme.of(context).textTheme.headlineLarge,
    //             ),
    //     ),
    // );
  }
}
