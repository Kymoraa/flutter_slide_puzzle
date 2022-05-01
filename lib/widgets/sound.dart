import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Sound extends StatelessWidget {
  final VoidCallback toggleSound;

final bool soundOn;
  const Sound(this.toggleSound,this.soundOn ,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleSound,
      icon: soundOn ? const Icon(
        CupertinoIcons.speaker_1_fill,
        size: 20.0,
        color: Colors.deepPurpleAccent,
      ) :
      const Icon(
        CupertinoIcons.speaker_slash_fill,
        size: 20.0,
        color: Colors.grey,
      ),
    );
  }
}
