import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  int seconds;

  Clock(this.seconds, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(
        "Seconds lapsed: ${seconds}",
        style: const TextStyle(
          color: Colors.deepPurpleAccent,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

    );
  }
}
