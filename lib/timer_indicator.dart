import 'package:flutter/material.dart';
import 'main.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimerIndicator extends StatefulWidget {
  //DONE: call parent class to refresh so we can have the timer be invisible until the timer starts, so we get 
  //rid of that super weird looking 2/3 circle.
  //^Just needed to wrap the var change for TimerExists in a setState. duh.

  int totalTimeinSeconds=1;//as seconds
  int minutes=0;
  int seconds=0;
  TimerIndicator({super.key, required this.totalTimeinSeconds, required this.minutes, required this.seconds});

  @override
  State<TimerIndicator> createState() => _TimerIndicatorState();
}

class _TimerIndicatorState extends State<TimerIndicator> {
  final color=true;

  @override
  Widget build(BuildContext context) {



    return Column(
      
      children: [
        
        //MyHomePageState().timerExists?
        CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 15.0,
          percent: (widget.totalTimeinSeconds-((widget.minutes*60)+widget.seconds))/widget.totalTimeinSeconds,
          //if we have invisible timer set to true, we use bg color, else we use green. will need to pay attention for dark mode
          progressColor: MyHomePageState.mainVars['Invisible Timer']?Theme.of(context).colorScheme.primaryContainer:(Colors.green),
          circularStrokeCap: CircularStrokeCap.round,
          //
          //linear gradient doesn't really work properly with arcType.FULL
          //linearGradient: LinearGradient(colors: [Theme.of(context).colorScheme.primaryContainer,Colors.green]),
          //rotateLinearGradient: true,
          animation: true,
          //curve: Curves.linear,
          animationDuration: 1000,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          arcType: ArcType.FULL,
          animateFromLastPercent: true,
          center: (Text(
                  //adds leading zero to seconds <9
                  widget.seconds>9?
                    '${widget.minutes}:${widget.seconds}':'${widget.minutes}:0${widget.seconds}',
                  style: Theme.of(context).textTheme.headlineLarge,
                )),

        // ):Container(
        //   width: 100,
        //   height: 100,
        //   color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ],
    );
  }
}
