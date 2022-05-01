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

class _BoardState extends State<Board> with WidgetsBindingObserver {
  var numbers = [for (var i = 0; i <= 15; i++) i];
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  int moves = 0;
  Timer? timer;
  int seconds = 0;
  static const duration = Duration(seconds: 1);
  bool isStarted = false;
  bool isPlaying = false;
  final firstLoadedKey = "true";
  bool soundOn = true;
  bool musicStarted = false;
  @override
  void initState() {
    super.initState();
    numbers.shuffle();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (isPlaying) {
          _assetsAudioPlayer.play();
        }

        break;
      case AppLifecycleState.paused:
        if (isPlaying) {
          _assetsAudioPlayer.pause();
        }
        break;
      case AppLifecycleState.inactive:
        if (isPlaying) {
          _assetsAudioPlayer.pause();

        }
        break;
      case AppLifecycleState.detached:
        if (isPlaying) {
          _assetsAudioPlayer.stop();
          setState(() {
            musicStarted = false;
            isPlaying = false;
          });
        }
        break;
    }
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
            Menu(moves, size, seconds, toggleMusic, toggleSound, isPlaying,
                soundOn),
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
    if (!musicStarted) {
      _assetsAudioPlayer.open(
          Playlist(
            audios: [
              Audio("assets/audios/background_music.mp3"),
            ],
          ),
          loopMode: LoopMode.playlist,
          autoStart: true);
      setState(() {
        musicStarted = true;
        isPlaying = true;
      });
      return;
    }
    if (isPlaying) {
      _assetsAudioPlayer.playOrPause();
      setState(() {
        isPlaying = false;
      });
    } else {
      _assetsAudioPlayer.playOrPause();
      setState(() {
        isPlaying = true;
      });
    }
  }

  void toggleSound() {
    if (soundOn) {
      _assetsAudioPlayer.setVolume(0);
      setState(() {
        soundOn = false;
      });
    } else {
      _assetsAudioPlayer.setVolume(1);
      setState(() {
        soundOn = true;
      });
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
