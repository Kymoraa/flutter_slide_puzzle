import 'package:flutter/material.dart';
import 'package:sliding_puzzle/widgets/moves.dart';
import 'package:sliding_puzzle/widgets/clock.dart';
import 'package:sliding_puzzle/widgets/play_pause.dart';
import 'package:sliding_puzzle/widgets/sound.dart';

class Menu extends StatelessWidget {
  final VoidCallback toggleMusic;
  final VoidCallback toggleSound;
  final bool isPlaying;
  final bool soundOn;
  int moves;
  int seconds;
  var size;

  Menu(this.moves, this.size, this.seconds, this.toggleMusic, this.toggleSound,
      this.isPlaying, this.soundOn,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.10,
      child: Column(
        children: <Widget>[
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Sound(toggleSound, soundOn),
              PlayPause(
                toggleMusic,
                isPlaying,
              ),
              Clock(seconds),
              Moves(moves),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
