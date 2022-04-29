import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayPause extends StatelessWidget {
  final bool isPlaying;
  const PlayPause(   this.togglePlay,
    this.isPlaying,
      {
    Key? key,
  }) : super(key: key);
  final VoidCallback togglePlay;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: togglePlay,
      icon: isPlaying
          ? const Icon(
              CupertinoIcons.pause_fill,
              size: 20.0,
              color: Colors.deepPurpleAccent,
            )
          : const Icon(
              CupertinoIcons.play_fill,
              size: 20.0,
              color: Colors.deepPurpleAccent,
            ),
    );
  }
}
