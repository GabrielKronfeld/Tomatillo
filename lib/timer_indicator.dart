import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimerIndicator extends StatefulWidget {

  int time;
  int minutes=0;
  int seconds=0;
  TimerIndicator({super.key, required this.time});

  @override
  State<TimerIndicator> createState() => _TimerIndicatorState();
}

class _TimerIndicatorState extends State<TimerIndicator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: 
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 5.0,
          percent: 1.0,
          center: Text(
                  '${widget.minutes}:${widget.seconds}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
          progressColor: Colors.green,
        ),
    );
  }
}
