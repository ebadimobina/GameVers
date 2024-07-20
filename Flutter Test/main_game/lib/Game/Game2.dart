import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyBall extends StatelessWidget {
  final double bX;
  final double bY;

  const MyBall({super.key, required this.bX, required this.bY});

  @override
  Widget build(BuildContext context) {
    Color randomColor() {
      Random random = Random();
      int red = 100 + random.nextInt(156);
      int green = 100 + random.nextInt(156);
      int blue = 100 + random.nextInt(156);
      return Color.fromRGBO(red, green, blue, 1.0);
    }

    return Container(
      alignment: Alignment(bX, bY),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.03, // کاهش اندازه دایره
        height: MediaQuery.of(context).size.width * 0.03, // کاهش اندازه دایره
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: randomColor(),
          border: Border.all(
            color: Colors.black,
            width:
                MediaQuery.of(context).size.width * 0.005, // کاهش اندازه حاشیه
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final IconData icon;
  final Function() function;

  const MyButton({super.key, required this.icon, required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey[800],
          width: MediaQuery.of(context).size.width * 0.08, // کاهش اندازه دکمه
          height: MediaQuery.of(context).size.width * 0.08, // کاهش اندازه دکمه
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size:
                  MediaQuery.of(context).size.width * 0.04, // کاهش اندازه آیکون
            ),
          ),
        ),
      ),
    );
  }
}

class MyMissile extends StatelessWidget {
  final double height;
  final double mX;

  const MyMissile({super.key, required this.height, required this.mX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(mX, 1),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.005, // کاهش اندازه موشک
        height: height,
        color: Colors.brown[300],
      ),
    );
  }
}

class MyPlayer extends StatelessWidget {
  final double X;

  const MyPlayer({super.key, required this.X});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(X, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // کاهش اندازه تکه از 25 به 20
        child: Image.asset(
          'lib/Game/images/slime.png',
          height: MediaQuery.of(context).size.width *
              0.10, // کاهش اندازه از 0.2 به 0.15
          width: MediaQuery.of(context).size.width *
              0.10, // کاهش اندازه از 0.2 به 0.15
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

enum Direction { LEFT, RIGHT }

class BubbleTroubleMain extends StatefulWidget {
  const BubbleTroubleMain({super.key});

  @override
  State<BubbleTroubleMain> createState() => _BubbleTroubleMain();
}

class _BubbleTroubleMain extends State<BubbleTroubleMain> {
  double X = 0;
  double mX = 0;
  double mH = 10;
  bool midShot = false;
  double bX = 0.5;
  double bY = 1;
  var ballDirection = Direction.LEFT;
  int score = 0;
  Timer? gameTimer;

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60;

    gameTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = -5 * time * time + velocity * time;
      if (height < 0) {
        time = 0;
      }

      if (!mounted) return;

      setState(() {
        bY = heightToCoordinate(height);
      });

      if (bX - 0.005 < -1) {
        ballDirection = Direction.RIGHT;
      } else if (bX + 0.005 > 1) {
        ballDirection = Direction.LEFT;
      }
      if (ballDirection == Direction.LEFT) {
        if (!mounted) return;
        setState(() {
          bX -= 0.005;
        });
      } else if (ballDirection == Direction.RIGHT) {
        if (!mounted) return;
        setState(() {
          bX += 0.005;
        });
      }

      if (playerOut()) {
        timer.cancel();
        if (!mounted) return;
        _showDialog();
      }

      time += 0.1;
    });
  }

  void _showDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 209, 238, 20),
          title: const Center(
            child: Text(
              "You've Lost!",
              style: TextStyle(fontFamily: 'EXOT350B'),
            ),
          ),
          content: const Text(
            "Do you want to restart the game?",
            style: TextStyle(fontFamily: 'EXOT350B'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                restartGame();
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text(
                "Restart",
                style: TextStyle(fontFamily: 'EXOT350B'),
              ),
            ),
          ],
        );
      },
    );
  }

  void moveLeft() {
    if (!mounted) return;
    setState(() {
      if (X - 0.1 < -1) {
      } else {
        X -= 0.1;
      }
      if (!midShot) {
        mX = X;
      }
    });
  }

  void moveRight() {
    if (!mounted) return;
    setState(() {
      if (X + 0.1 > 1) {
      } else {
        X += 0.1;
      }
      if (!midShot) {
        mX = X;
      }
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        midShot = true;
        if (!mounted) return;
        setState(() {
          mH += MediaQuery.of(context).size.height * 0.01;
        });
        if (mH > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }
        if (bY > heightToCoordinate(mH) && (bX - mX).abs() < 0.03) {
          resetMissile();
          bX = 5;
          timer.cancel();
          if (!mounted) return;
          setState(() {
            score += 1;
          });
        }
        if (mH >= MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }
      });
    }
  }

  double heightToCoordinate(double height) {
    double totalH = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalH;
    return position;
  }

  void resetMissile() {
    mX = X;
    mH = 0;
    midShot = false;
  }

  bool playerOut() {
    if ((bX - X).abs() < 0.05 && bY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  void restartGame() {
    if (!mounted) return;
    setState(() {
      X = 0;
      mX = X;
      mH = 10;
      midShot = false;
      bX = 0.5;
      bY = 1;
      ballDirection = Direction.LEFT;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double titleFontSize = constraints.maxWidth > 600
              ? MediaQuery.of(context).size.width * 0.1
              : MediaQuery.of(context).size.width * 0.08;

          return Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.grey[800],
                  child: Stack(
                    children: [
                      MyBall(bX: bX, bY: bY),
                      MyMissile(height: mH, mX: mX),
                      MyPlayer(X: X),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: 0,
                        right: 0,
                        child: const Center(
                          child: Text(
                            'Smash Ball',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'EXOT350B'),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Score: $score',
                          style: const TextStyle(fontFamily: 'EXOT350B'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyButton(icon: Icons.play_arrow, function: startGame),
                          MyButton(icon: Icons.arrow_back, function: moveLeft),
                          MyButton(
                              icon: Icons.arrow_upward, function: fireMissile),
                          MyButton(
                              icon: Icons.arrow_forward, function: moveRight),
                          MyButton(
                              icon: Icons.restart_alt, function: restartGame),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTextStyle(
      style: TextStyle(fontFamily: 'EXOT350B'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BubbleTroubleMain(),
      ),
    );
  }
}
