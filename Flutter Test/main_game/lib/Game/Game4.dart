import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Clash',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'EXOT350B'),
        ),
      ),
      home: MemoryPuzzleGame(),
    );
  }
}

class MemoryPuzzleGame extends StatefulWidget {
  @override
  _MemoryPuzzleGameState createState() => _MemoryPuzzleGameState();
}

class _MemoryPuzzleGameState extends State<MemoryPuzzleGame> {
  List<String> images = [
    'lib/Game/images/img1.png',
    'lib/Game/images/img2.png',
    'lib/Game/images/img3.png',
    'lib/Game/images/img5.png',
    'lib/Game/images/img6.png',
    'lib/Game/images/img4.png',
  ];

  List<String> combinedImages = [];

  late List<bool> cardFlipped;
  late List<bool> cardMatched;
  int? firstSelectedCardIndex;
  int? secondSelectedCardIndex;
  int score = 0;
  bool gameStarted = false;
  Timer? gameTimer;
  int gameTime = 0;

  @override
  void initState() {
    super.initState();
    generateCombinedImages();
    cardFlipped = List<bool>.filled(combinedImages.length, false);
    cardMatched = List<bool>.filled(combinedImages.length, false);
    combinedImages.shuffle();
  }

  void generateCombinedImages() {
    combinedImages.addAll(images);
    combinedImages.addAll(images);
  }

  void startGame() {
    if (!mounted) return;
    setState(() {
      gameStarted = true;
      gameTime = 0;
      gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          gameTime++;
        });
      });
    });
  }

  void resetGame() {
    if (!mounted) return;
    setState(() {
      combinedImages.clear();
      generateCombinedImages();
      cardFlipped = List<bool>.filled(combinedImages.length, false);
      cardMatched = List<bool>.filled(combinedImages.length, false);
      firstSelectedCardIndex = null;
      secondSelectedCardIndex = null;
      score = 0;
      gameStarted = false;
      gameTimer?.cancel();
      gameTime = 0;
    });
  }

  void handleCardTap(int index) {
    if (!gameStarted) startGame();

    if (cardFlipped[index] || cardMatched[index]) return;

    setState(() {
      cardFlipped[index] = true;

      if (firstSelectedCardIndex == null) {
        firstSelectedCardIndex = index;
      } else if (secondSelectedCardIndex == null) {
        secondSelectedCardIndex = index;

        if (combinedImages[firstSelectedCardIndex!] ==
            combinedImages[secondSelectedCardIndex!]) {
          cardMatched[firstSelectedCardIndex!] = true;
          cardMatched[secondSelectedCardIndex!] = true;
          score += 1;
          firstSelectedCardIndex = null;
          secondSelectedCardIndex = null;

          if (cardMatched.every((matched) => matched)) {
            gameTimer?.cancel();
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Congratulations!',
                  style: TextStyle(fontFamily: 'EXOT350B'),
                ),
                content: Text(
                  'You completed the game.\nTime: $gameTime seconds',
                  style: TextStyle(fontFamily: 'EXOT350B'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      resetGame();
                    },
                    child: Text(
                      'Restart',
                      style: TextStyle(fontFamily: 'EXOT350B'),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          Timer(Duration(seconds: 1), () {
            if (!mounted) return;
            setState(() {
              cardFlipped[firstSelectedCardIndex!] = false;
              cardFlipped[secondSelectedCardIndex!] = false;
              firstSelectedCardIndex = null;
              secondSelectedCardIndex = null;
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom Header with Kawaii Style
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink[300]!,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Card Clash',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'EXOT350B',
                  shadows: [
                    Shadow(
                      color: Colors.pink[600]!,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Score and Time Box
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.yellow[100], // تغییر رنگ به زرد پاستلی
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow[700]!,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score: $score',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[900],
                    fontFamily: 'EXOT350B',
                  ),
                ),
                Text(
                  'Time: $gameTime',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[900],
                    fontFamily: 'EXOT350B',
                  ),
                ),
              ],
            ),
          ),
          // Cards Box
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 6;
                } else if (constraints.maxWidth > 800) {
                  crossAxisCount = 4;
                }

                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: combinedImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => handleCardTap(index),
                        child: CardFlipper(
                          isFlipped: cardFlipped[index] || cardMatched[index],
                          front: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[50]!.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  offset: Offset(0, 3),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: combinedImages[index],
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          back: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[50]!.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  offset: Offset(0, 3),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Card',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'EXOT350B',
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardFlipper extends StatefulWidget {
  final bool isFlipped;
  final Widget front;
  final Widget back;

  const CardFlipper({
    Key? key,
    required this.isFlipped,
    required this.front,
    required this.back,
  }) : super(key: key);

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 0.5),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.5, end: 1),
          weight: 50,
        ),
      ],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CardFlipper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle =
            _animation.value * 3.1415926535897932; // 180 degrees in radians

        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: _animation.value < 0.5
              ? widget.back
              : Transform(
                  transform: Matrix4.identity()..rotateY(3.1415926535897932),
                  alignment: Alignment.center,
                  child: widget.front,
                ),
        );
      },
    );
  }
}
