import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// Begin content of ball.dart
class MayBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  final bool hasGmeStarted;
  final bool isGameOver;

  const MayBall(
      {super.key,
      required this.ballX,
      required this.ballY,
      required this.hasGmeStarted,
      required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        height: 15,
        width: 15,
        decoration: const BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
// End content of ball.dart

// Begin content of bricks.dart
class MyBrick extends StatelessWidget {
  final double brickX;
  final double brickY;
  final double brickHeight;
  final double brickWidth;
  final bool brickBroken;

  const MyBrick(
      {super.key,
      required this.brickHeight,
      required this.brickWidth,
      required this.brickX,
      required this.brickY,
      required this.brickBroken});

  @override
  Widget build(BuildContext context) {
    return brickBroken
        ? Container()
        : Container(
            alignment:
                Alignment((2 * brickX + brickWidth) / (2 - brickWidth), brickY),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: MediaQuery.of(context).size.height * brickHeight / 2,
                width: MediaQuery.of(context).size.width * brickWidth / 2,
                color: Colors.deepPurple,
              ),
            ),
          );
  }
}
// End content of bricks.dart

// Begin content of coverscreen.dart
class CoverScreen extends StatelessWidget {
  final bool hasGmeStarted;
  final bool isGameOver;

  const CoverScreen(
      {super.key, required this.hasGmeStarted, required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return hasGmeStarted
        ? Container(
            alignment: const Alignment(0, -0.5),
            child: Text(
              isGameOver ? ' ' : 'BRICK BUSTER',
              style: TextStyle(
                color: Colors.deepPurple[200],
                fontFamily: 'EXOT350B',
              ),
            ),
          )
        : Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.5),
                child: Text(
                  'BRICK BUSTER',
                  style: TextStyle(
                    color: Colors.deepPurple[400],
                    fontFamily: 'EXOT350B',
                  ),
                ),
              ),
              Container(
                alignment: const Alignment(0, -0.1),
                child: Text(
                  'tap to play',
                  style: TextStyle(
                    color: Colors.deepPurple[400],
                    fontFamily: 'EXOT350B',
                  ),
                ),
              ),
            ],
          );
  }
}
// End content of coverscreen.dart

// Begin content of gameoverscreen.dart
class GameOverScreen extends StatelessWidget {
  final bool isGameOver;
  final VoidCallback? function;

  const GameOverScreen({super.key, required this.isGameOver, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.3),
                child: const Text(
                  'G A M E  O V E R',
                  style: TextStyle(
                    color: Color.fromARGB(255, 47, 3, 122),
                    fontFamily: 'EXOT350B',
                  ),
                ),
              ),
              Container(
                alignment: const Alignment(0, 0),
                child: GestureDetector(
                  onTap: function,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: const Text(
                        'P L A Y  A G A I N',
                        style: TextStyle(
                          color: Color.fromARGB(255, 42, 4, 109),
                          fontFamily: 'EXOT350B',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}

class MyPlayer extends StatelessWidget {
  final double palyerX;
  final double palyerWidth;

  const MyPlayer({super.key, required this.palyerX, required this.palyerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          Alignment((2 * palyerX + palyerWidth) / (2 - palyerWidth), 0.9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width * palyerWidth / 2,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
// End content of player.dart

// Begin content of homepage.dart

enum Direction { UP, DOWN, LEFT, RIGHT }

class BrickBreakerGame extends StatefulWidget {
  const BrickBreakerGame({super.key});

  @override
  _BrickBreakerGameState createState() => _BrickBreakerGameState();
}

class _BrickBreakerGameState extends State<BrickBreakerGame> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  double ballXincrements = 0.02;
  double ballYincrements = 0.01;
  Direction ballYDirection = Direction.DOWN;
  Direction ballXDirection = Direction.LEFT;

  // player variables
  double palyerX = -0.2;
  double palyerWidth = 0.4;

  // brick variable
  static double firstBrickX = -1 + wallGap;
  static double fisrtBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.01;
  static int numberOfBricksInRow = 3;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickGap);

  List<List<dynamic>> myBricks = [
    [firstBrickX + 0 * (brickWidth + brickGap), fisrtBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), fisrtBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), fisrtBrickY, false],
  ];

  // game settings
  bool hasGmeStarted = false;
  bool isGameOver = false;

  // game start
  void startGame() {
    hasGmeStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // update Direction
      updateDirection();

      // ball move
      moveBall();

      // check if player dead
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }
      checkForBrokenBricks();
    });
  }

  void checkForBrokenBricks() {
    for (int i = 0; i < myBricks.length; i++) {
      if (ballX >= myBricks[i][0] &&
          ballX <= myBricks[i][0] + brickWidth &&
          ballY >= myBricks[i][1] &&
          ballY <= myBricks[i][1] + brickHeight &&
          !myBricks[i][2]) {
        setState(() {
          myBricks[i][2] = true;

          double leftSideDist = (myBricks[i][0] - ballX).abs();
          double rightSideDist = (myBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (myBricks[i][1] - ballX).abs();
          double bottomSideDist = (myBricks[i][1] + brickHeight - ballY).abs();

          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);
          switch (min) {
            case 'left':
              ballXDirection = Direction.LEFT;
              break;
            case 'right':
              ballXDirection = Direction.RIGHT;
              break;
            case 'up':
              ballYDirection = Direction.UP;
              break;
            case 'down':
              ballYDirection = Direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];
    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'up';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'bottom';
    }
    return '';
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void moveBall() {
    setState(() {
      if (ballXDirection == Direction.LEFT) {
        ballX -= ballXincrements;
      } else if (ballXDirection == Direction.RIGHT) {
        ballX += ballXincrements;
      }

      if (ballYDirection == Direction.DOWN) {
        ballY += ballYincrements;
      } else if (ballYDirection == Direction.UP) {
        ballY -= ballYincrements;
      }
    });
  }

  // update Direction
  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= palyerX && ballX <= palyerX + palyerWidth) {
        ballYDirection = Direction.UP;
      } else if (ballY <= -1) {
        ballYDirection = Direction.DOWN;
      }
      if (ballX >= 1) {
        ballXDirection = Direction.LEFT;
      } else if (ballX <= -1) {
        ballXDirection = Direction.RIGHT;
      }
    });
  }

  // move left
  void moveLeft() {
    setState(() {
      if (!(palyerX - 0.2 <= -1)) {
        palyerX -= 0.2;
      }
    });
  }

  // move right
  void moveRight() {
    if (!(palyerX + palyerWidth >= 1)) {
      palyerX += 0.2;
    }
  }

  void resetGame() {
    setState(() {
      palyerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGmeStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
            child: Stack(
              children: [
                // tap to play
                CoverScreen(
                  hasGmeStarted: hasGmeStarted,
                  isGameOver: isGameOver,
                ),

                // game over screen
                GameOverScreen(
                  isGameOver: isGameOver,
                  function: resetGame,
                ),

                // ball
                MayBall(
                  ballX: ballX,
                  ballY: ballY,
                  hasGmeStarted: hasGmeStarted,
                  isGameOver: isGameOver,
                ),

                // player
                MyPlayer(
                  palyerX: palyerX,
                  palyerWidth: palyerWidth,
                ),

                MyBrick(
                  brickX: myBricks[0][0],
                  brickY: myBricks[0][1],
                  brickBroken: myBricks[0][2],
                  brickWidth: brickWidth,
                  brickHeight: brickHeight,
                ),
                MyBrick(
                  brickX: myBricks[1][0],
                  brickY: myBricks[1][1],
                  brickBroken: myBricks[1][2],
                  brickWidth: brickWidth,
                  brickHeight: brickHeight,
                ),
                MyBrick(
                  brickX: myBricks[2][0],
                  brickY: myBricks[2][1],
                  brickBroken: myBricks[2][2],
                  brickWidth: brickWidth,
                  brickHeight: brickHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// End content of homepage.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BrickBreakerGame(),
    );
  }
}
