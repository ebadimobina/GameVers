import 'package:chess/chess.dart' as chess;
import 'package:flutter/material.dart';

void main() {
  runApp(const ChessGame());
}

class ChessGame extends StatelessWidget {
  const ChessGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kings Gambit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontFamily: 'EXOT350B',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          labelLarge: TextStyle(
              fontFamily: 'EXOT350B', fontSize: 16.0, color: Colors.white),
          bodyLarge: TextStyle(
              fontFamily: 'EXOT350B', fontSize: 16.0, color: Colors.white),
          bodyMedium: TextStyle(
              fontFamily: 'EXOT350B', fontSize: 16.0, color: Colors.black),
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'lib/Game/images/splash.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.5)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                final fontSize = isDesktop ? 24.0 : 36.0;
                final buttonPadding = isDesktop
                    ? const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0)
                    : const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0);
                final buttonTextSize = isDesktop ? 16.0 : 24.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Kings Gambit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'EXOT350B',
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: buttonPadding,
                        textStyle: TextStyle(fontSize: buttonTextSize),
                      ),
                      child: const Text(
                        'Start Game',
                        style: TextStyle(
                          fontFamily: 'EXOT350B',
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LevelSelectionScreen()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Difficulty Level',
            style: TextStyle(fontFamily: 'EXOT350B')),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = constraints.maxWidth * 0.7;
          final buttonHeight = MediaQuery.of(context).size.height * 0.08;
          final spacing = MediaQuery.of(context).size.height * 0.02;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    child: const Text('Easy',
                        style: TextStyle(fontFamily: 'EXOT350B')),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyChessGame(difficulty: 'easy')),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing),
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    child: const Text('Medium',
                        style: TextStyle(fontFamily: 'EXOT350B')),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyChessGame(difficulty: 'medium')),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing),
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    child: const Text('Hard',
                        style: TextStyle(fontFamily: 'EXOT350B')),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyChessGame(difficulty: 'hard')),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MyChessGame extends StatefulWidget {
  final String difficulty;

  const MyChessGame({super.key, required this.difficulty});

  @override
  _MyChessGameState createState() => _MyChessGameState();
}

class _MyChessGameState extends State<MyChessGame> {
  late chess.Chess _chess;
  List<int>? _selectedPieceMoves;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _chess = chess.Chess();
  }

  void _onPieceTap(int index) {
    setState(() {
      _selectedIndex = index;
      String square = _indexToSquare(index);
      _selectedPieceMoves = _chess
          .generate_moves()
          .where((move) => move.fromAlgebraic == square)
          .map((move) => _squareToIndex(move.toAlgebraic))
          .toList();
    });
  }

  void _onMove(int from, int to) {
    setState(() {
      _chess.move({'from': _indexToSquare(from), 'to': _indexToSquare(to)});
      _selectedPieceMoves = null;
      _selectedIndex = null;
    });

    if (_chess.in_checkmate) {
      _showGameOverDialog('Checkmate!');
    } else if (_chess.in_draw) {
      _showGameOverDialog('Draw!');
    } else {
      _makeAIMove();
    }
  }

  void _makeAIMove() {
    final moves = _chess.generate_moves();
    if (moves.isNotEmpty) {
      final move = moves[(moves.length *
              (widget.difficulty == 'easy'
                  ? 0.25
                  : widget.difficulty == 'medium'
                      ? 0.5
                      : 0.75))
          .toInt()];
      setState(() {
        _chess.move(move);
      });

      if (_chess.in_checkmate) {
        _showGameOverDialog('Checkmate!');
      } else if (_chess.in_draw) {
        _showGameOverDialog('Draw!');
      }
    }
  }

  String _indexToSquare(int index) {
    final file = 'abcdefgh'[index % 8];
    final rank = (8 - index ~/ 8).toString();
    return '$file$rank';
  }

  int _squareToIndex(String square) {
    final file = square[0].codeUnitAt(0) - 'a'.codeUnitAt(0);
    final rank = 8 - int.parse(square[1]);
    return rank * 8 + file;
  }

  void _showGameOverDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(fontFamily: 'EXOT350B')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kings Gambit (${widget.difficulty})',
            style: TextStyle(fontFamily: 'EXOT350B')),
      ),
      body: Center(
        child: _buildBoard(),
      ),
    );
  }

  Widget _buildBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final squareSize = boardSize / 8;

        return SizedBox(
          width: boardSize,
          height: boardSize,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemCount: 64,
            itemBuilder: (context, index) {
              final squareColor =
                  (index % 2 == (index ~/ 8) % 2) ? Colors.white : Colors.black;
              final piece = _chess.get(_indexToSquare(index));
              final isSelected = _selectedIndex == index;
              final isMoveOption = _selectedPieceMoves != null &&
                  _selectedPieceMoves!.contains(index);
              final textColor =
                  (index % 2 == (index ~/ 8) % 2) ? Colors.black : Colors.white;
              return GestureDetector(
                onTap: () {
                  if (isMoveOption) {
                    _onMove(_selectedIndex!, index);
                  } else {
                    _onPieceTap(index);
                  }
                },
                child: Container(
                  width: squareSize,
                  height: squareSize,
                  color: isSelected
                      ? Colors.green
                      : isMoveOption
                          ? Colors.yellow
                          : squareColor,
                  child: Center(
                    child: Text(
                      piece != null ? _pieceName(piece) : '',
                      style: TextStyle(
                        fontSize: squareSize * 0.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'EXOT350B',
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _pieceName(chess.Piece piece) {
    switch (piece.type) {
      case chess.PieceType.PAWN:
        return 'P';
      case chess.PieceType.ROOK:
        return 'R';
      case chess.PieceType.KNIGHT:
        return 'N';
      case chess.PieceType.BISHOP:
        return 'B';
      case chess.PieceType.QUEEN:
        return 'Q';
      case chess.PieceType.KING:
        return 'K';
      default:
        return '';
    }
  }
}
