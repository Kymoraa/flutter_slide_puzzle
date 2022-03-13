import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Shuffle extends StatelessWidget {
  final VoidCallback shuffle;

  const Shuffle(this.shuffle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: shuffle,
      icon: const Icon(
        CupertinoIcons.restart,
        size: 20.0,
      ),
      label: const Text(
        "RESET ",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: TextButton.styleFrom(
        primary: Colors.white,
        shape: const StadiumBorder(),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
