import 'package:flutter/material.dart';

//Just a black bar with some padding, keeps things nicely clean.
class BlackBarPadding extends StatelessWidget {
  const BlackBarPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: const Color.fromARGB(150, 0, 100, 0),
        height: 2.0,
        width: double.infinity,
      ),
    );
  }
}
