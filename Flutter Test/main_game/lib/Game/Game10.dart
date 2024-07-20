import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 23, 22, 22),
        fontFamily: 'EXOT350B',
      ),
      home: CharacterSelectionScreen(),
    );
  }
}

class CharacterSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Select Your Character',
          style: TextStyle(
            fontFamily: 'EXOT350B',
          ),
        )),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose your game mode:',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'EXOT350B',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 1, 1)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Container(
              width: 200,
              height: 50,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(31, 90, 87, 87), // رنگ سایه
                    blurRadius: 15.0, // میزان تار شدن سایه
                    offset: Offset(0, 01), // فاصله سایه از دکمه
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(
                          255, 120, 146, 156)), // رنگ پس زمینه دکمه
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TicTacToeGame(player: 'X', isWithAI: true),
                    ),
                  );
                },
                child: const Text(
                  'Play with AI',
                  style: TextStyle(
                    fontFamily: 'EXOT350B',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 50,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(31, 90, 87, 87), // رنگ سایه
                    blurRadius: 15.0, // میزان تار شدن سایه
                    offset: Offset(0, 01), // فاصله سایه از دکمه
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(
                          255, 120, 146, 156)), // رنگ پس زمینه دکمه
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TicTacToeGame(player: 'X', isWithAI: false),
                    ),
                  );
                },
                child: const Text(
                  'Play with Friends',
                  style: TextStyle(
                    fontFamily: 'EXOT350B',
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

class TicTacToeGame extends StatefulWidget {
  final String player;
  final bool isWithAI;

  TicTacToeGame({required this.player, required this.isWithAI});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> board;
  late String currentPlayer;
  late bool gameOver;
  late String winner;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      board = List.generate(3, (_) => List.generate(3, (_) => ' '));
      currentPlayer = widget.player;
      gameOver = false;
      winner = '';
    });
    if (currentPlayer == 'O' && widget.isWithAI) {
      _performAIMove();
    }
  }

  void _makeMove(int row, int col) {
    if (board[row][col] == ' ' && !gameOver) {
      setState(() {
        board[row][col] = currentPlayer;
        if (_checkWinner(row, col)) {
          gameOver = true;
          winner = currentPlayer;
          _showEndGameDialog();
        } else if (_isBoardFull()) {
          gameOver = true;
          _showEndGameDialog();
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          if (widget.isWithAI && currentPlayer == 'O') {
            _performAIMove();
          }
        }
      });
    }
  }

  bool _isBoardFull() {
    for (var row in board) {
      for (var cell in row) {
        if (cell == ' ') {
          return false;
        }
      }
    }
    return true;
  }

  bool _checkWinner(int row, int col) {
    // Check row
    if (board[row][0] == board[row][1] &&
        board[row][1] == board[row][2] &&
        board[row][0] != ' ') {
      return true;
    }
    // Check column
    if (board[0][col] == board[1][col] &&
        board[1][col] == board[2][col] &&
        board[0][col] != ' ') {
      return true;
    }
    // Check diagonals
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != ' ') {
      return true;
    }
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != ' ') {
      return true;
    }
    return false;
  }

  void _performAIMove() {
    var bestMove = _findBestMove();
    _makeMove(bestMove[0], bestMove[1]);
  }

  List<int> _findBestMove() {
    int bestVal = -1000;
    List<int> bestMove = [-1, -1];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == ' ') {
          board[i][j] = 'O';
          int moveVal = _minimax(0, false);
          board[i][j] = ' ';
          if (moveVal > bestVal) {
            bestMove = [i, j];
            bestVal = moveVal;
          }
        }
      }
    }
    return bestMove;
  }

  int _minimax(int depth, bool isMax) {
    int score = _evaluate();

    if (score == 10) {
      return score - depth;
    }

    if (score == -10) {
      return score + depth;
    }

    if (_isBoardFull()) {
      return 0;
    }

    if (isMax) {
      int best = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == ' ') {
            board[i][j] = 'O';
            best = max(best, _minimax(depth + 1, !isMax));
            board[i][j] = ' ';
          }
        }
      }
      return best;
    } else {
      int best = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == ' ') {
            board[i][j] = 'X';
            best = min(best, _minimax(depth + 1, !isMax));
            board[i][j] = ' ';
          }
        }
      }
      return best;
    }
  }

  int _evaluate() {
    // Check rows for victory
    for (int row = 0; row < 3; row++) {
      if (board[row][0] == board[row][1] && board[row][1] == board[row][2]) {
        if (board[row][0] == 'O') {
          return 10;
        } else if (board[row][0] == 'X') {
          return -10;
        }
      }
    }
    // Check columns for victory
    for (int col = 0; col < 3; col++) {
      if (board[0][col] == board[1][col] && board[1][col] == board[2][col]) {
        if (board[0][col] == 'O') {
          return 10;
        } else if (board[0][col] == 'X') {
          return -10;
        }
      }
    }
    // Check diagonals for victory
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
      if (board[0][0] == 'O') {
        return 10;
      } else if (board[0][0] == 'X') {
        return -10;
      }
    }
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
      if (board[0][2] == 'O') {
        return 10;
      } else if (board[0][2] == 'X') {
        return -10;
      }
    }
    return 0;
  }

  int max(int a, int b) => (a > b) ? a : b;
  int min(int a, int b) => (a < b) ? a : b;

  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Game Over',
            style: TextStyle(
              fontFamily: 'EXOT350B',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$winner wins!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'EXOT350B',
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _initializeGame();
                },
                child: const Text(
                  'Start Game',
                  style: TextStyle(
                    fontFamily: 'EXOT350B',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontFamily: 'EXOT350B',
          ),
        )),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          margin:
              const EdgeInsets.only(bottom: 115, top: 115, left: 80, right: 80),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 34, 34, 34),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              // BoxShadow(
              //   color: Colors.grey.withOpacity(0.5),
              //   spreadRadius: 5,
              //   blurRadius: 7,
              //   offset: Offset(0, 3), // changes position of shadow
              // ),
            ],
          ),
          padding: const EdgeInsets.all(1),
          child: _buildBoard(),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (j) {
            return GestureDetector(
              onTap: () => _makeMove(i, j),
              child: Container(
                margin: const EdgeInsets.all(5), // فاصله بین مربع‌ها
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.grey.withOpacity(0.5),
                    //   spreadRadius: 3,
                    //   blurRadius: 7,
                    //   offset: Offset(0, 3),
                    // ),
                  ],
                ),
                child: Center(
                  child: Transform.scale(
                    scale: 0.9, // کوچک‌تر کردن مربع سفید
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: board[i][j] == ' '
                            ? null
                            : Image.asset(
                                board[i][j] == 'X'
                                    ? 'lib/Game/images/x.png'
                                    : 'lib/Game/images/o.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
