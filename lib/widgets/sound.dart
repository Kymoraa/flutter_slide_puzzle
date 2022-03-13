import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Sound extends StatelessWidget {
  final VoidCallback toggleMusic;
  final bool isPlaying;

  const Sound(this.toggleMusic, this.isPlaying, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleMusic,
      icon: isPlaying ? const Icon(
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
