import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

void main() {
  runApp(FlappyBirdApp());
}

class FlappyBirdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: FlappyBirdGame(),
      ),
    );
  }
}

class FlappyBirdGame extends StatefulWidget {
  @override
  _FlappyBirdGameState createState() => _FlappyBirdGameState();
}

class _FlappyBirdGameState extends State<FlappyBirdGame>
    with SingleTickerProviderStateMixin {
  double birdY = 0;
  double initialBirdY = 0;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;
  double birdWidth = 0.3;
  double birdHeight = 0.3;

  bool gameHasStarted = false;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.2;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  int score = 0;
  double backgroundX1 = 0;
  double backgroundX2 = 1;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    resetGame();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    )..repeat();
    _controller.addListener(() {
      setState(() {
        backgroundX1 -= 0.005;
        backgroundX2 -= 0.005;
        if (backgroundX1 <= -1) {
          backgroundX1 = 1;
        }
        if (backgroundX2 <= -1) {
          backgroundX2 = 1;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void jump() {
    setState(() {
      time = 0;
      initialBirdY = birdY;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialBirdY - height;

        for (int i = 0; i < barrierX.length; i++) {
          barrierX[i] -= 0.05;
          if (barrierX[i] < -1.5) {
            barrierX[i] += 3;
            barrierHeight[i] = [
              Random().nextDouble() * 0.6,
              Random().nextDouble() * 0.6
            ];
            score++;
          }
        }

        if (birdIsDead()) {
          timer.cancel();
          gameHasStarted = false;
          _showDialog();
        }
      });
    });
  }

  bool birdIsDead() {
    if (birdY > 1 || birdY < -1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] * birdHeight ||
              birdY + birdHeight >= 1 - barrierHeight[i][1] * birdHeight)) {
        return true;
      }
    }

    return false;
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "GAME OVER",
              style: TextStyle(fontFamily: 'EXOT350B'),
            ),
            content: Text(
              "Your Score: $score",
              style: const TextStyle(fontFamily: 'EXOT350B'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "PLAY AGAIN",
                  style: TextStyle(fontFamily: 'EXOT350B'),
                ),
                onPressed: () {
                  resetGame();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void resetGame() {
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialBirdY = birdY;
      barrierX = [2, 2 + 1.5];
      barrierHeight = [
        [0.6, 0.4],
        [0.4, 0.6]
      ];
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'EXOT350B'),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Stack(
                children: <Widget>[
                  // بک‌گراند ثابت
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/Game/images/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 0),
                          alignment: Alignment(0, birdY),
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'lib/Game/images/bird.png'), // تصویر پرنده ثابت
                                fit: BoxFit.contain,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width *
                                birdWidth /
                                2,
                            height: MediaQuery.of(context).size.height *
                                birdHeight /
                                2,
                          ),
                        ),
                        MyBarrier(
                          barrierX: barrierX[0],
                          barrierHeight: barrierHeight[0][0],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[0],
                          barrierHeight: barrierHeight[0][1],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: true,
                        ),
                        MyBarrier(
                          barrierX: barrierX[1],
                          barrierHeight: barrierHeight[1][0],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[1],
                          barrierHeight: barrierHeight[1][1],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: true,
                        ),
                        Container(
                          alignment: const Alignment(0, -0.3),
                          child: gameHasStarted
                              ? const Text("")
                              : const Text(
                                  "TAP TO PLAY",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                        ScoreDisplay(score: score), // نمایش نمره
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Center(
                  child: Text(
                    "Score: $score",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBarrier extends StatelessWidget {
  final double barrierHeight;
  final double barrierWidth;
  final double barrierX;
  final bool isThisBottomBarrier;

  MyBarrier(
      {required this.barrierHeight,
      required this.barrierWidth,
      required this.barrierX,
      required this.isThisBottomBarrier});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isThisBottomBarrier ? 1 : -1),
      child: Container(
        decoration: BoxDecoration(
          border: isThisBottomBarrier
              ? const Border(
                  top: BorderSide(color: Colors.transparent),
                  right: BorderSide(color: Colors.black, width: 100.0),
                  bottom: BorderSide(color: Colors.black, width: 1.0),
                  left: BorderSide(color: Colors.black, width: 1.0),
                )
              : const Border(
                  top: BorderSide(color: Colors.black, width: 1.0),
                  right: BorderSide(color: Colors.black, width: 1.0),
                  bottom: BorderSide(color: Colors.transparent),
                  left: BorderSide(color: Colors.black, width: 1.0),
                ),
          color: isThisBottomBarrier ? Colors.green : Colors.green,
          borderRadius: isThisBottomBarrier
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4), // رنگ سایه
              spreadRadius: 3.5, // انتشار سایه
              blurRadius: 7, // شفافیت سایه
              offset: const Offset(0, 3), // جابجایی سایه به سمت پایین
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * barrierWidth / 1.2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      ),
    );
  }
}

class ScoreDisplay extends StatelessWidget {
  final int score;

  ScoreDisplay({required this.score});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Score: $score",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
