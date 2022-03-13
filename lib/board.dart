import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/widgets/grid.dart';
import 'package:sliding_puzzle/widgets/menu.dart';
import 'package:sliding_puzzle/widgets/shuffle.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var numbers = [for (var i = 0; i <= 15; i++) i];
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  int moves = 0;
  Timer? timer;
  int seconds = 0;
  static const duration = Duration(seconds: 1);
  bool isStarted = false;
  bool isPlaying = false;
  final firstLoadedKey = "true";

  @override
  void initState() {
    super.initState();
    numbers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    timer ??= Timer.periodic(duration, (t) {
      startTimer();
    });
    Future.delayed(Duration.zero, () => showTutorialDialog(context));
    return SafeArea(
      child: Container(
        height: size.height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Menu(moves, size, seconds, toggleMusic, isPlaying),
            Grid(numbers, size, clickGrid),
            Shuffle(shuffle),
          ],
        ),
      ),
    );
  }

  showTutorialDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLoaded = prefs.getBool(firstLoadedKey);
    if (isFirstLoaded == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Slide Puzzle Tutorial",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                "This is a puzzle consisting of a 4x4 grid of shuffled numbers. \n"
                "\n"
                "Your goal is to solve this puzzle by sorting the numbers. \n"
                "\n"
                "The top menu consists of sound - toggle on and off for background music,"
                "seconds lapsed - showing you how much time you have been actively playing and "
                "moves - indicating the number of moves/times you have moved the grid. \n"
                "\n"
                "Press RESET at the bottom to shuffle the tiles and start again :)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    isFirstLoaded = false;
                    prefs.setBool(firstLoadedKey, false);

                  },
                  child: const Text(
                    "GOT IT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  color: Colors.deepPurpleAccent,
                ),
              ],
            );
          });
    }
  }

  void clickGrid(index) {
    if (seconds == 0) {
      isStarted = true;
    }
    if (index - 1 >= 0 && numbers[index - 1] == 0 && index % 4 != 0 ||
        index + 1 < 16 && numbers[index + 1] == 0 && (index + 1) % 4 != 0 ||
        (index - 4 >= 0 && numbers[index - 4] == 0) ||
        (index + 4 < 16 && numbers[index + 4] == 0)) {
      setState(() {
        numbers[numbers.indexOf(0)] = numbers[index];
        numbers[index] = 0;
        moves++;
      });
    }
    isWinner();
  }

  void shuffle() {
    setState(() {
      numbers.shuffle();
      moves = 0;
      isStarted = false;
      seconds = 0;
    });
  }

  void startTimer() {
    if (isStarted) {
      setState(() {
        seconds += 1;
      });
    }
  }

  bool isSorted(List list) {
    int prev = list.first;
    for (var i = 1; i < list.length - 1; i++) {
      int next = list[i];
      if (prev > next) return false;
      prev = next;
    }
    return true;
  }

  void toggleMusic() {
    if (isPlaying) {
      _assetsAudioPlayer.stop();
      isPlaying = false;
    } else {
      _assetsAudioPlayer.open(
        Playlist(
          audios: [
            Audio("assets/audios/background_music.mp3"),
          ],
        ),
        loopMode: LoopMode.playlist,
        autoStart: true,
        showNotification: true,
      );

      isPlaying = true;
    }
  }

  void isWinner() {
    if (isSorted(numbers)) {
      isStarted = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "You have solved the puzzle!",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 200.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "EXIT",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
