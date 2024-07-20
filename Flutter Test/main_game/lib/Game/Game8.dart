import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SuperMario(),
    );
  }
}

class SuperMario extends StatefulWidget {
  const SuperMario({super.key});

  bool canMoveTo(String direction, List<List<double>> noManLand, double x,
      double y, double step) {
    double stepX = 0;
    double stepY = 0;
    if (direction == 'Left') {
      stepX = step;
      stepY = 0;
    } else if (direction == 'Right') {
      stepX = -step;
      stepY = 0;
    } else if (direction == 'Up') {
      stepX = 0;
      stepY = step;
    } else if (direction == 'Down') {
      stepX = 0;
      stepY = -step;
    }
    for (int i = 0; i < noManLand.length; i++) {
      if ((cleanNum(noManLand[i][0]) == cleanNum(x + stepX)) &&
          (cleanNum(noManLand[i][1]) == cleanNum(y + stepY))) {
        return false;
      }
    }
    return true;
  }

  double cleanNum(double num) {
    return double.parse(num.toStringAsFixed(2));
  }

  @override
  State<SuperMario> createState() => _HomePageState();
}

class _HomePageState extends State<SuperMario> {
  double mapX = 1.125;
  double mapY = 0.65;

  double labMapX = 0;
  double labMapY = 0;

  String oakDirection = 'Down';

  bool chatStarted = false;
  int countPressingA = -1;

  int boySpriteCount = 0;
  String boyDirection = 'Down';

  String currentLocation = 'littleroot';
  double step = 0.25;
  static double stepLab = 0.43;
  List<List<double>> noMansLandLittleroot = [
    [0.625, 0.9],
    [0.625, -0.35],
    [0.375, -0.35],
    [0.125, -0.35],
    [1.625, -0.6],
    [1.375, -0.6],
    [1.125, -0.6],
    [0.875, -0.6],
    [0.625, -0.6],
    [0.375, -0.6],
    [0.125, -0.6],
    [1.625, -0.85],
    [1.375, -0.85],
    [1.125, -0.85],
    [0.875, -0.85],
    [0.625, -0.85],
    [0.375, -0.85],
    [0.125, -0.85],
    [1.625, -1.1],
    [1.375, -1.1],
    [1.125, -1.1],
    [0.875, -1.1],
    [0.625, -1.1],
    [0.375, -1.1],
    [0.125, -1.1],
    [1.625, -1.35],
    [1.375, -1.35],
    [1.125, -1.35],
    [0.875, -1.35],
    [0.625, -1.6],
    [-1.625, -1.6],
    [-2.125, -1.35],
    [-2.125, -1.1],
    [-0.625, 2.9],
    [-0.125, 3.15],
    [-0.375, 3.15],
    [1.875, 0.65],
    [0.875, 0.15],
    [1.125, 0.15],
    [1.375, 0.15],
    [1.625, 0.15],
    [1.875, 0.15],
    [1.875, -0.1],
    [1.875, -0.35],
    [1.875, -0.6],
    [1.875, -0.85],
    [-1.125, 0.4],
    [-1.375, 0.4],
    [-1.625, 0.4],
    [-1.875, 0.4],
    [-1.875, 0.15],
    [-1.875, -0.1],
    [-1.875, -0.35],
    [-1.875, -0.6],
    [-1.875, -0.85],
    [-1.625, -0.85],
    [-1.375, -0.85],
    [-1.375, -1.1],
    [-1.125, -1.1],
    [-1.125, -1.35],
    [-1.125, -1.6],
    [-0.875, -1.6],
    [-0.625, -1.6],
    [-0.375, -1.6],
    [-0.125, -1.6],
    [0.125, -1.6],
    [-0.625, -0.35],
    [-0.625, -0.1],
    [-0.625, 0.15],
    [-0.625, 0.4],
    [-0.875, 0.4],
    [-1.125, 0.4],
    [-1.375, 0.4],
    [-1.625, 0.4],
    [-1.875, 0.4],
    [-1.875, 0.65],
    [-1.875, 0.9],
    [-1.875, 1.15],
    [-1.875, 1.4],
    [-1.875, 1.65],
    [-1.875, 1.9],
    [-1.625, 1.9],
    [-1.375, 1.9],
    [-1.125, 1.9],
    [-0.875, 1.9],
    [-0.625, 1.9],
    [-0.375, 1.9],
    [-0.375, 1.65],
    [-0.375, 1.4],
    [-0.375, 1.15],
    [-0.375, 0.9],
    [-0.375, 0.65],
    [0.625, 0.65],
    [0.875, 0.65],
    [1.125, 0.65],
    [1.375, 0.65],
    [1.625, 0.65],
    [1.625, 0.9],
    [1.625, 1.15],
    [1.625, 1.4],
    [1.625, 1.65],
    [1.625, 1.9],
    [1.375, 1.9],
    [1.125, 1.9],
    [0.875, 1.9],
    [0.625, 1.9],
    [0.375, 1.9],
    [0.375, 1.65],
    [0.375, 1.4],
    [0.375, 1.15],
    [0.375, 0.9],
    [0.375, 0.65]
  ];

  List<List<double>> noMansLandPokeLab = [
    [0, -2.73],
    [0.375, -1.35],
    [0.625, 0.9],
    [0.625, -0.35],
    [0.375, -0.35],
    [0.125, -0.35],
    [1.625, -0.6],
    [1.375, -0.6],
    [1.125, -0.6],
    [0.875, -0.6],
    [0.625, -0.6],
    [0.375, -0.6],
    [0.125, -0.6],
    [1.625, -0.85],
    [1.375, -0.85],
    [1.125, -0.85],
    [0.875, -0.85],
    [0.625, -0.85],
    [0.375, -0.85],
    [0.125, -0.85],
    [1.625, -1.1],
    [1.375, -1.1],
    [1.125, -1.1],
    [0.875, -1.1],
    [0.625, -1.1],
    [0.375, -1.1],
    [0.125, -1.1],
    [1.625, -1.35],
    [1.375, -1.35],
    [1.125, -1.35],
    [0.875, -1.35],
    [0.625, -1.6],
    [-1.625, -1.6],
    [-2.125, -1.35],
    [-2.125, -1.1],
    [-0.625, 2.9],
    [-0.125, 3.15],
    [-0.375, 3.15],
    [1.875, 0.65],
    [0.875, 0.15],
    [1.125, 0.15],
    [1.375, 0.15],
    [1.625, 0.15],
    [1.875, 0.15],
    [1.875, -0.1],
    [1.875, -0.35],
    [1.875, -0.6],
    [1.875, -0.85],
    [-1.125, 0.4],
    [-1.375, 0.4],
    [-1.625, 0.4],
    [-1.875, 0.4],
    [-1.875, 0.15],
    [-1.875, -0.1],
    [-1.875, -0.35],
    [-1.875, -0.6],
    [-1.875, -0.85],
    [-1.625, -0.85],
    [-1.375, -0.85],
    [-1.375, -1.1],
    [-1.125, -1.1],
    [-1.125, -1.35],
    [-1.125, -1.6],
    [-0.875, -1.6],
    [-0.625, -1.6],
    [-0.375, -1.6],
    [-0.125, -1.6],
    [0.125, -1.6],
    [-0.625, -0.35],
    [-0.625, -0.1],
    [-0.625, 0.15],
    [-0.625, 0.4],
    [-0.875, 0.4],
    [-1.125, 0.4],
    [-1.375, 0.4],
    [-1.625, 0.4],
    [-1.875, 0.4],
    [-1.875, 0.65],
    [-1.875, 0.9],
    [-1.875, 1.15],
    [-1.875, 1.4],
    [-1.875, 1.65],
    [-1.875, 1.9],
    [-1.625, 1.9],
    [-1.375, 1.9],
    [-1.125, 1.9],
    [-0.875, 1.9],
    [-0.625, 1.9],
    [-0.375, 1.9],
    [-0.375, 1.65],
    [-0.375, 1.4],
    [-0.375, 1.15],
    [-0.375, 0.9],
    [-0.375, 0.65],
    [0.625, 0.65],
    [0.875, 0.65],
    [1.125, 0.65],
    [1.375, 0.65],
    [1.625, 0.65],
    [1.625, 0.9],
    [1.625, 1.15],
    [1.625, 1.4],
    [1.625, 1.65],
    [1.625, 1.9],
    [1.375, 1.9],
    [1.125, 1.9],
    [0.875, 1.9],
    [0.625, 1.9],
    [0.375, 1.9],
    [0.375, 1.65],
    [0.375, 1.4],
    [0.375, 1.15],
    [0.375, 0.9],
    [0.375, 0.65]
  ];
  void moveUp() {
    boyDirection = 'Up';
    if (currentLocation == 'littleroot') {
      if (widget.canMoveTo(
          boyDirection, noMansLandLittleroot, mapX, mapY, step)) {
        setState(() {
          mapY += step;
        });
      }
      if (double.parse((mapX).toStringAsFixed(4)) == 0.375 &&
          double.parse((mapY).toStringAsFixed(4)) == -1.35) {
        setState(() {
          currentLocation = 'pokelab';
          labMapX = 0.375;
          labMapY = -1.73;
        });
      }

      animateWalk();
    } else if (currentLocation == 'pokelab') {
      if (widget.canMoveTo(
          boyDirection, noMansLandPokeLab, labMapX, labMapY, stepLab)) {
        setState(() {
          labMapY += stepLab;
        });
      }
      animateWalk();
    }
  }

  void moveDown() {
    boyDirection = 'Down';
    if (currentLocation == 'littleroot') {
      if (widget.canMoveTo(
          boyDirection, noMansLandLittleroot, mapX, mapY, step)) {
        setState(() {
          mapY -= step;
        });
      }

      animateWalk();
    } else if (currentLocation == 'pokelab') {
      if (widget.canMoveTo(
          boyDirection, noMansLandPokeLab, labMapX, labMapY, stepLab)) {
        setState(() {
          labMapY -= stepLab;
        });
      }
      if (double.parse((mapX).toStringAsFixed(4)) == 0.375 &&
          double.parse((mapY).toStringAsFixed(4)) == -1.35) {
        setState(() {
          currentLocation = 'littleroot';
          labMapX = 0;
          labMapY = -1.73;
        });
      }
      animateWalk();
    }
  }

  void moveLeft() {
    boyDirection = 'Left';
    if (currentLocation == 'littleroot') {
      if (widget.canMoveTo(
          boyDirection, noMansLandLittleroot, mapX, mapY, step)) {
        setState(() {
          mapX += step;
        });
      }
      animateWalk();
    } else if (currentLocation == 'pokelab') {
      if (widget.canMoveTo(
          boyDirection, noMansLandPokeLab, labMapX, labMapY, stepLab)) {
        setState(() {
          labMapX += stepLab;
        });
      }
      animateWalk();
    }
  }

  void moveRight() {
    boyDirection = 'Right';
    if (currentLocation == 'littleroot') {
      if (widget.canMoveTo(
          boyDirection, noMansLandLittleroot, mapX, mapY, step)) {
        setState(() {
          mapX -= step;
        });
      }
      animateWalk();
    } else if (currentLocation == 'pokelab') {
      if (widget.canMoveTo(
          boyDirection, noMansLandPokeLab, labMapX, labMapY, stepLab)) {
        setState(() {
          labMapX -= stepLab;
        });
      }
      animateWalk();
    }
  }

  void pressedA() {}
  void pressedB() {}

  void animateWalk() {
    print('X : ' + mapX.toString() + ' Y : ' + mapY.toString());

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        boySpriteCount++;
      });
      if (boySpriteCount == 3) {
        boySpriteCount = 0;
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  if (currentLocation == 'littleroot')
                    LittleRoot(
                      x: mapX,
                      y: mapY,
                      currentMap: currentLocation,
                    ),
                  if (currentLocation == 'pokelab')
                    MyPokeLab(
                        x: labMapX, y: labMapY, currentMap: currentLocation),
                  Container(
                    alignment: const Alignment(0, 0),
                    child: MyBoy(
                      location: currentLocation,
                      boySpriteCount: boySpriteCount,
                      direction: boyDirection,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'G A M E B O Y',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'EXOT350B'),
                        ),
                        Text(
                          ' ❤ ',
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          'F L U T T E R',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'EXOT350B'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                                MyButton(
                                  text: '-',
                                  function: moveLeft,
                                ),
                                const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                MyButton(
                                  text: '↑',
                                  function: moveUp,
                                ),
                                const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                                MyButton(
                                  text: '↓',
                                  function: moveDown,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                                MyButton(
                                  text: '→',
                                  function: moveRight,
                                ),
                                const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                                MyButton(
                                  text: 'b',
                                  function: pressedB,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                MyButton(
                                  text: 'a',
                                  function: pressedA,
                                ),
                                const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback function;

  const MyButton({required this.text, required this.function, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: Text(text),
    );
  }
}

class MyBoy extends StatelessWidget {
  final int boySpriteCount;
  final String direction;
  final String location;

  const MyBoy({
    super.key,
    required this.boySpriteCount,
    required this.direction,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    double height = 20;

    if (location == 'littleroot') {
      height = 20.0;
    } else if (location == 'pokelab') {
      height = 30.0;
    } else if (location == 'battleground' ||
        location == 'attackoptions' ||
        location == 'battlefinishedscreen') {
      height = 0.0;
    }
    return SizedBox(
      height: height,
      child: Image.asset(
        'lib/Game/images/boy$direction$boySpriteCount.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class MyPokeLab extends StatelessWidget {
  final double x;
  final double y;
  final String currentMap;

  const MyPokeLab({
    super.key,
    required this.x,
    required this.y,
    required this.currentMap,
  });

  @override
  Widget build(BuildContext context) {
    if (currentMap == 'pokelab') {
      return Container(
        alignment: Alignment(x, y),
        child: Image.asset(
          'lib/Game/images/pokelab.png',
          width: MediaQuery.of(context).size.width * 0.75,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container();
    }
  }
}

class LittleRoot extends StatelessWidget {
  double x;
  double y;
  String currentMap;

  LittleRoot(
      {super.key, required this.y, required this.x, required this.currentMap});

  @override
  Widget build(BuildContext context) {
    if (currentMap == 'littleroot') {
      return Container(
        alignment: Alignment(x, y),
        child: Image.asset(
          'lib/Game/images/battleground.png',
          width: MediaQuery.of(context).size.width * 0.75,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container();
    }
  }
}
