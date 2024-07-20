import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const SnakeGame());

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Sprint',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontFamily: 'EXOT350B',
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
          bodyLarge: TextStyle(
              fontFamily: 'EXOT350B', fontSize: 20, color: Colors.white),
          labelLarge: TextStyle(
              fontFamily: 'EXOT350B', fontSize: 20, color: Colors.white),
          titleMedium: TextStyle(
              fontFamily: 'EXOT350B', fontSize: 16, color: Colors.white),
          titleSmall: TextStyle(
              fontFamily: 'EXOT350B', fontSize: 16, color: Colors.black),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/Game/images/bg.jpg'),
            fit: BoxFit.contain,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Snake Sprint',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const GamePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 19, 20, 19),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Let's Go",
                  style: TextStyle(fontFamily: 'EXOT350B'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int rowCount = 20;
  static const int columnCount = 20;
  static const int squareSize = 20; // Increase the square size
  final Duration duration = const Duration(milliseconds: 300);

  List<Offset> snake = [const Offset(0, 0)];
  Offset food = const Offset(5, 5);
  String direction = 'right';
  Timer? timer;
  bool isPlaying = false; // Track whether the game is playing

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    if (!mounted) return;
    setState(() {
      snake = [const Offset(0, 0)];
      food = generateFood();
      direction = 'right';
      isPlaying = true;
      timer?.cancel();
      timer = Timer.periodic(duration, (Timer t) {
        if (!mounted) return;
        setState(() {
          moveSnake();
          checkGameOver();
        });
      });
    });
  }

  void stopGame() {
    timer?.cancel();
    if (!mounted) return;
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Offset generateFood() {
    final random = Random();
    return Offset(
      random.nextInt(rowCount).toDouble(),
      random.nextInt(columnCount).toDouble(),
    );
  }

  void moveSnake() {
    Offset newHead = getNewHead();
    if (newHead == food) {
      snake.add(food);
      food = generateFood();
    } else {
      snake.add(newHead);
      snake.removeAt(0);
    }
  }

  Offset getNewHead() {
    Offset head = snake.last;
    switch (direction) {
      case 'up':
        return Offset(head.dx, head.dy - 1);
      case 'down':
        return Offset(head.dx, head.dy + 1);
      case 'left':
        return Offset(head.dx - 1, head.dy);
      case 'right':
        return Offset(head.dx + 1, head.dy);
      default:
        return head;
    }
  }

  void checkGameOver() {
    Offset head = snake.last;
    if (head.dx < 0 ||
        head.dx >= rowCount ||
        head.dy < 0 ||
        head.dy >= columnCount) {
      stopGame();
      showGameOverDialog();
    }
    for (int i = 0; i < snake.length - 1; i++) {
      if (snake[i] == head) {
        stopGame();
        showGameOverDialog();
      }
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('You scored ${snake.length}!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
            ),
          ],
        );
      },
    );
  }

  void changeDirection(String newDirection) {
    if (direction == 'up' && newDirection == 'down' ||
        direction == 'down' && newDirection == 'up' ||
        direction == 'left' && newDirection == 'right' ||
        direction == 'right' && newDirection == 'left') {
      return;
    }
    direction = newDirection;
  }

  Widget buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        onPressed: onPressed,
        iconSize: 32,
      ),
    );
  }

  Widget buildPlayButton() {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.play_arrow),
        color: Colors.white,
        onPressed: startGame,
        iconSize: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Sprint'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: rowCount / columnCount,
              child: GridView.builder(
                itemCount: rowCount * columnCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                ),
                itemBuilder: (BuildContext context, int index) {
                  int x = index % columnCount;
                  int y = (index / columnCount).floor();
                  Offset offset = Offset(x.toDouble(), y.toDouble());
                  bool isSnake = snake.contains(offset);
                  bool isHead = snake.last == offset;
                  bool isFood = offset == food;
                  return Container(
                    width:
                        squareSize.toDouble(), // Increase the size of each cell
                    height: squareSize.toDouble(),
                    decoration: BoxDecoration(
                      color: isHead
                          ? Colors.blue
                          : isSnake
                              ? Colors.green
                              : isFood
                                  ? Colors.red
                                  : Colors.grey[200],
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            color: Colors.grey[300], // Add background color to the control area
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                buildControlButton(Icons.arrow_upward, () {
                  if (isPlaying) changeDirection('up');
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildControlButton(Icons.arrow_back, () {
                      if (isPlaying) changeDirection('left');
                    }),
                    const SizedBox(
                        width:
                            20.0), // Add space between left and right buttons
                    buildPlayButton(), // Add Play button in the center
                    const SizedBox(
                        width:
                            20.0), // Add space between Play and right buttons
                    buildControlButton(Icons.arrow_forward, () {
                      if (isPlaying) changeDirection('right');
                    }),
                  ],
                ),
                buildControlButton(Icons.arrow_downward, () {
                  if (isPlaying) changeDirection('down');
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
