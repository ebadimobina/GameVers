import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEASER SUDOKU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            const SizedBox(
              height: 350.0,
              child: Image(
                image: AssetImage('lib/assets/background.jpg'),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Ready To Play?',
              style: TextStyle(
                fontSize: 30.0,
                color: Color.fromRGBO(57, 30, 69, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SudokuGame()),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  const Color.fromRGBO(251, 142, 141, 1.0),
                ),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                textStyle: WidgetStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 20.0)),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 40.0)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              child: const Text(
                'Start Game',
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIconButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Colors.white),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class SudokuGame extends StatefulWidget {
  const SudokuGame({super.key});

  @override
  State<SudokuGame> createState() => _SudokuGameState();
}

const double RADIUS_CORNER = 12;
const int VALUE_NONE = 0;
const int COUNT_ROW_SUB_TABLE = 3;
const int COUNT_COL_SUB_TABLE = 3;

class SudokuChannel {
  bool enableMove;
  bool enableWarning;
  var value;

  SudokuChannel(
      {this.value = 0, this.enableMove = true, this.enableWarning = false});
}

class SudokuSubTable {
  int indexRowInTable;
  int indexColInTable;
  late List<List<SudokuChannel>> subTable;

  SudokuSubTable(
      {required this.indexRowInTable, required this.indexColInTable});

  init() {
    subTable = [];
    for (int row = 1; row <= COUNT_ROW_SUB_TABLE; row++) {
      List<SudokuChannel> list = [];
      for (int col = 1; col <= COUNT_COL_SUB_TABLE; col++) {
        list.add(SudokuChannel(value: 0));
      }
      subTable.add(list);
    }
  }

  setValue({int row = 0, int col = 0, int value = 0, bool enableMove = true}) {
    subTable[row][col] = SudokuChannel(value: value, enableMove: enableMove);
  }

  int randomNumber() {
    Random r = Random();
    return r.nextInt(10);
  }
}

class SudokuTable {
  late List<List<SudokuSubTable>> table;

  init() {
    table = [];
    for (int row = 0; row < COUNT_ROW_SUB_TABLE; row++) {
      List<SudokuSubTable> list = [];
      for (int col = 0; col < COUNT_COL_SUB_TABLE; col++) {
        SudokuSubTable subTable =
            SudokuSubTable(indexRowInTable: row, indexColInTable: col);
        subTable.init();
        list.add(subTable);
      }
      table.add(list);
    }
  }
}

class _SudokuGameState extends State<SudokuGame> {
  Color colorBorderTable = Colors.white;
  Color colorBackgroundApp = const Color.fromARGB(255, 228, 157, 226);

  Color colorBackgroundChannelEmpty1 = const Color(0xffe3e3e3);
  Color colorBackgroundChannelEmpty2 = Colors.white30;
  Color colorBackgroundNumberTab = Colors.white;
  Color colorTextNumber = Colors.white;
  Color colorBackgroundChannelValue = const Color.fromARGB(255, 113, 46, 83);

  Color colorBackgroundChannelValueFixed =
      const Color.fromARGB(255, 251, 201, 85);

  late SudokuTable sudokuTable;
  bool conflictMode = false;
  double channelSize = 0;
  double fontScale = 1;
  late Timer _timer;
  int _countdown = 10 * 5; // 10 minutes
  @override
  void initState() {
    initSudokuTable();
    initTableFixed();
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void restart() {
    setState(() {
      _timer.cancel();
      _countdown = 10 * 60;
      initSudokuTable();
      initTableFixed();
      updateFixedNumbers(); // به‌روزرسانی اعداد اصلی
      _startTimer();
    });
  }

  void updateFixedNumbers() {
    for (int i = 0; i < COUNT_ROW_SUB_TABLE; i++) {
      for (int j = 0; j < COUNT_COL_SUB_TABLE; j++) {
        SudokuSubTable subTable = sudokuTable.table[i][j];
        for (int row = 0; row < COUNT_ROW_SUB_TABLE; row++) {
          for (int col = 0; col < COUNT_COL_SUB_TABLE; col++) {
            SudokuChannel channel = subTable.subTable[row][col];
            if (!channel.enableMove) {
              int newValue = subTable.randomNumber();
              subTable.setValue(
                  row: row, col: col, value: newValue, enableMove: false);
            }
          }
        }
      }
    }
  }

  void checkGameCompletion() {
    // Replace with your logic to check if the game is completed
    // For example, if all cells are filled correctly
    bool isGameCompleted = true; // Example logic

    if (isGameCompleted) {
      setState(() {
        var gameCompleted = true;
      });

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('برنده شدی! 🎉'),
          duration:
              const Duration(seconds: 3), // Optional, how long it stays visible
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Some action to take when 'OK' is pressed
              // For example, navigate back or reset the game
              setState(() {
                var gameCompleted = false; // Reset game state
              });
            },
          ),
        ),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer.cancel();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Game Over'),
                content: const Text('Time is up!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  void initSudokuTable() {
    sudokuTable = SudokuTable();
    sudokuTable.init();
  }

  void initTableFixed() {
    SudokuSubTable subTableLeftTop = sudokuTable.table[0][0];
    subTableLeftTop.setValue(row: 0, col: 2, value: 5, enableMove: false);
    subTableLeftTop.setValue(row: 1, col: 0, value: 1, enableMove: false);
    subTableLeftTop.setValue(row: 1, col: 2, value: 2, enableMove: false);

    SudokuSubTable subTableTop = sudokuTable.table[0][1];
    subTableTop.setValue(row: 0, col: 0, value: 9, enableMove: false);
    subTableTop.setValue(row: 1, col: 1, value: 6, enableMove: false);
    subTableTop.setValue(row: 1, col: 2, value: 8, enableMove: false);
    subTableTop.setValue(row: 2, col: 0, value: 2, enableMove: false);

    SudokuSubTable subTableRightTop = sudokuTable.table[0][2];
    subTableRightTop.setValue(row: 0, col: 1, value: 1, enableMove: false);
    subTableRightTop.setValue(row: 1, col: 0, value: 4, enableMove: false);
    subTableRightTop.setValue(row: 2, col: 0, value: 7, enableMove: false);

    SudokuSubTable subTableLeft = sudokuTable.table[1][0];
    subTableLeft.setValue(row: 0, col: 0, value: 2, enableMove: false);
    subTableLeft.setValue(row: 0, col: 1, value: 1, enableMove: false);
    subTableLeft.setValue(row: 1, col: 1, value: 4, enableMove: false);
    subTableLeft.setValue(row: 1, col: 2, value: 8, enableMove: false);
    subTableLeft.setValue(row: 2, col: 1, value: 5, enableMove: false);

    SudokuSubTable subTableCenter = sudokuTable.table[1][1];
    subTableCenter.setValue(row: 0, col: 0, value: 8, enableMove: false);
    subTableCenter.setValue(row: 0, col: 2, value: 6, enableMove: false);
    subTableCenter.setValue(row: 1, col: 1, value: 9, enableMove: false);
    subTableCenter.setValue(row: 2, col: 0, value: 4, enableMove: false);
    subTableCenter.setValue(row: 2, col: 2, value: 3, enableMove: false);

    SudokuSubTable subTableRight = sudokuTable.table[1][2];
    subTableRight.setValue(row: 0, col: 1, value: 3, enableMove: false);
    subTableRight.setValue(row: 1, col: 0, value: 6, enableMove: false);
    subTableRight.setValue(row: 1, col: 1, value: 5, enableMove: false);
    subTableRight.setValue(row: 2, col: 1, value: 7, enableMove: false);
    subTableRight.setValue(row: 2, col: 2, value: 8, enableMove: false);

    SudokuSubTable subTableBottomLeft = sudokuTable.table[2][0];
    subTableBottomLeft.setValue(row: 0, col: 2, value: 4, enableMove: false);
    subTableBottomLeft.setValue(row: 1, col: 2, value: 3, enableMove: false);
    subTableBottomLeft.setValue(row: 2, col: 1, value: 6, enableMove: false);

    SudokuSubTable subTableBottom = sudokuTable.table[2][1];
    subTableBottom.setValue(row: 0, col: 2, value: 2, enableMove: false);
    subTableBottom.setValue(row: 1, col: 0, value: 6, enableMove: false);
    subTableBottom.setValue(row: 1, col: 1, value: 8, enableMove: false);
    subTableBottom.setValue(row: 2, col: 2, value: 4, enableMove: false);

    SudokuSubTable subTableBottomRight = sudokuTable.table[2][2];
    subTableBottomRight.setValue(row: 1, col: 0, value: 5, enableMove: false);
    subTableBottomRight.setValue(row: 1, col: 2, value: 1, enableMove: false);
    subTableBottomRight.setValue(row: 2, col: 0, value: 3, enableMove: false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double shortestSize = size.shortestSide;
    double width = size.width;
    double height = size.height;

    // Tablet case
    if (shortestSize >= 600) {
      fontScale = 1.7;
      if (width > height) {
        // Tablet landscape
        channelSize = shortestSize / 9 - 30;
      } else {
        // tablet portrait
        channelSize = shortestSize / 9 - 10;
      }
    } else {
      // phone case (portrait only)
      channelSize = shortestSize / 9 - 10;
    }

    return Scaffold(
        body: Container(
            constraints: const BoxConstraints.expand(),
            color: colorBackgroundApp,
            child: Column(children: <Widget>[
              buildMenu(),
              Container(
                  height: 8, color: const Color.fromARGB(255, 228, 157, 226)),
              Expanded(
                  child: Container(
                      constraints: const BoxConstraints.expand(),
                      child: Center(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: colorBorderTable,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        buildSubTable(sudokuTable.table[0][0],
                                            colorBackgroundChannelEmpty1),
                                        buildSubTable(sudokuTable.table[0][1],
                                            colorBackgroundChannelEmpty2),
                                        buildSubTable(sudokuTable.table[0][2],
                                            colorBackgroundChannelEmpty1),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        buildSubTable(sudokuTable.table[1][0],
                                            colorBackgroundChannelEmpty2),
                                        buildSubTable(sudokuTable.table[1][1],
                                            colorBackgroundChannelEmpty1),
                                        buildSubTable(sudokuTable.table[1][2],
                                            colorBackgroundChannelEmpty2),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        buildSubTable(sudokuTable.table[2][0],
                                            colorBackgroundChannelEmpty1),
                                        buildSubTable(sudokuTable.table[2][1],
                                            colorBackgroundChannelEmpty2),
                                        buildSubTable(sudokuTable.table[2][2],
                                            colorBackgroundChannelEmpty1),
                                      ],
                                    )
                                  ]),
                            )
                          ])))),
              Container(
                  height: 8, color: const Color.fromARGB(255, 228, 157, 226)),
              Container(
                  padding: const EdgeInsets.all(12),
                  color: colorBackgroundNumberTab,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildNumberListTab()))
            ])));
  }

  Container buildMenu() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 8, right: 16, left: 16),
      constraints: const BoxConstraints.expand(height: 80),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "TEASE SUDOKU",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontFamily: 'EXOT350B', // Set the default font family here

              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0, // فاصله بین حروف
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Color.fromRGBO(57, 30, 69, 1),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: const Color.fromRGBO(251, 142, 141, 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "New Game",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'EXOT350B', // Set the default font family here

                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            onPressed: () {
              restart();
            },
          ),
        ],
      ),
    );
  }

  Container buildSubTable(SudokuSubTable subTable, Color color) {
    return Container(
        padding: const EdgeInsets.all(2),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildRowChannel(subTable, 0, color)),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildRowChannel(subTable, 1, color)),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildRowChannel(subTable, 2, color))
        ]));
  }

  List<Widget> buildRowChannel(
      SudokuSubTable subTable, int rowChannel, Color color) {
    List<SudokuChannel> dataRowChanel = subTable.subTable[rowChannel];
    List<Widget> listWidget = [];
    for (int col = 0; col < 3; col++) {
      Widget widget = buildChannel(rowChannel, dataRowChanel[col], color,
          onNumberAccept: (data) {
        setState(() {
          sudokuTable.table[subTable.indexRowInTable][subTable.indexColInTable]
              .subTable[rowChannel][col] = SudokuChannel(value: data);
        });
      }, onRemove: () {
        setState(() {
          sudokuTable.table[subTable.indexRowInTable][subTable.indexColInTable]
              .subTable[rowChannel][col] = SudokuChannel();
        });
      }, onHover: (value) {
        setState(() {
          showWaringConflictChannel(subTable.indexRowInTable,
              subTable.indexColInTable, rowChannel, col, value);
        });
      }, onHoverEnd: () {
        clearWaringConflictChannel();
      });
      listWidget.add(widget);
    }
    return listWidget;
  }

  Widget buildChannel(int rowChannel, SudokuChannel channel, Color color,
      {required Function(dynamic) onNumberAccept,
      required Function() onRemove,
      required Function(dynamic) onHover,
      required Function onHoverEnd}) {
    if (channel.value == 0) {
      return DragTarget(builder: (context, candidateData, rejectedData) {
        print("candidateData = " + candidateData.toString());
        return buildChannelEmpty();
      }, onWillAccept: (data) {
        dynamic number = data;
        bool accept = false;
        if (number >= 1 && number <= 9) {
          accept = true;
        }
        if (accept) {
          if (!conflictMode) {
            onHover(data);
          }
        }
        return accept;
      }, onAccept: (data) {
        onNumberAccept(data);
        onHoverEnd();
      }, onLeave: (data) {
        onHoverEnd();
      });
    } else {
      if (channel.enableMove) {
        return DragTarget(builder: (context, candidateData, rejectedData) {
          return Draggable(
            child: buildChannelValue(channel),
            feedback: Material(
                type: MaterialType.transparency,
                child: buildChannelValue(channel)),
            childWhenDragging: buildChannelEmpty(),
            onDragCompleted: () {
              onRemove();
            },
            onDraggableCanceled: (v, o) {
              onRemove();
            },
            data: channel.value,
          );
        }, onWillAccept: (data) {
          dynamic number = data;
          return number >= 0 && number <= 9;
        }, onAccept: (data) {
          onNumberAccept(data);
        });
      } else {
        return buildChannelValueFixed(channel);
      }
    }
  }

  Container buildChannelEmpty() {
    return Container(
      margin: const EdgeInsets.all(1),
      width: channelSize,
      height: channelSize,
      decoration: BoxDecoration(
          color: colorBackgroundChannelEmpty1,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
    );
  }

  Widget buildChannelValue(SudokuChannel channel) {
    return Container(
      margin: const EdgeInsets.all(1),
      width: channelSize,
      height: channelSize,
      decoration: BoxDecoration(
          color: getColorIfWarning(channel, colorBackgroundChannelValue),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Center(
          child: Text(channel.value.toString(),
              textScaleFactor: fontScale,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900))),
    );
  }

  Color getColorIfWarning(SudokuChannel channel, Color colorDefault) {
    if (channel.enableWarning) {
      return Colors.pink;
    }
    return colorDefault;
  }

  Widget buildChannelValueFixed(SudokuChannel channel) {
    return Container(
      margin: const EdgeInsets.all(1),
      width: channelSize,
      height: channelSize,
      decoration: BoxDecoration(
          color: getColorIfWarning(channel, colorBackgroundChannelValueFixed),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Center(
          child: Text(channel.value.toString(),
              textScaleFactor: fontScale,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'EXOT350B', // Set the default font family here

                  fontSize: 20,
                  fontWeight: FontWeight.w900))),
    );
  }

  List<Widget> buildNumberListTab() {
    List<Widget> listWidget = [];
    for (int i = 1; i <= 9; i++) {
      Widget widget = buildNumberBoxWithDraggable(i);
      listWidget.add(widget);
    }
    return listWidget;
  }

  Widget buildNumberBoxWithDraggable(int i) {
    return Draggable(
      child: buildNumberBox(i),
      feedback:
          Material(type: MaterialType.transparency, child: buildNumberBox(i)),
      data: i,
      onDragEnd: (d) {
        setState(() {
          clearWaringConflictChannel();
        });
      },
    );
  }

  Container buildNumberBox(int i) {
    return Container(
        width: channelSize,
        height: channelSize,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
            color: colorBackgroundChannelValue,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text("$i",
                textScaleFactor: fontScale,
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'EXOT350B', // Set the default font family here

                    color: colorTextNumber,
                    fontWeight: FontWeight.w900))));
  }

  void showWaringConflictChannel(int rowSubTable, int colSubTable,
      int rowChannel, int colChannel, int value) {
    for (int i = 0; i < COUNT_ROW_SUB_TABLE; i++) {
      for (int j = 0; j < COUNT_ROW_SUB_TABLE; j++) {
        SudokuChannel channel =
            sudokuTable.table[rowSubTable][i].subTable[rowChannel][j];
        sudokuTable.table[rowSubTable][i].subTable[rowChannel][j]
            .enableWarning = channel.value == value;
        print("" + channel.value.toString());
      }
    }

    for (int i = 0; i < COUNT_COL_SUB_TABLE; i++) {
      for (int j = 0; j < COUNT_COL_SUB_TABLE; j++) {
        SudokuChannel channel =
            sudokuTable.table[i][colSubTable].subTable[j][colChannel];
        sudokuTable.table[i][colSubTable].subTable[j][colChannel]
            .enableWarning = channel.value == value;
        print("" + channel.value.toString());
      }
    }
    conflictMode = true;
  }

  void clearWaringConflictChannel() {
    for (int i = 0; i < COUNT_ROW_SUB_TABLE; i++) {
      for (int j = 0; j < COUNT_ROW_SUB_TABLE; j++) {
        for (int k = 0; k < COUNT_ROW_SUB_TABLE; k++) {
          for (int m = 0; m < COUNT_ROW_SUB_TABLE; m++) {
            sudokuTable.table[i][j].subTable[k][m].enableWarning = false;
          }
        }
      }
    }

    conflictMode = false;
  }
}
