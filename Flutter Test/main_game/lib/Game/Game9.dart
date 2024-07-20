import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Rock Paper Scissors',
            style: TextStyle(
              fontFamily: 'EXOT350B',
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/Game/images/bg9.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Game Content
            RpsGame(),
          ],
        ),
      ),
    );
  }
}

class RpsGame extends StatefulWidget {
  @override
  _RpsGameState createState() => _RpsGameState();
}

class _RpsGameState extends State<RpsGame> {
  String _playerChoice = '';
  String _aiChoice = '';
  int _playerScore = 0;
  int _aiScore = 0;
  int _round = 1;

  void _playGame(String playerChoice) {
    final choices = ['Rock', 'Paper', 'Scissors'];
    final random = Random();
    final aiChoice = choices[random.nextInt(choices.length)];

    GameResult result;
    if (playerChoice == aiChoice) {
      result = GameResult.Draw;
    } else if ((playerChoice == 'Rock' && aiChoice == 'Scissors') ||
        (playerChoice == 'Scissors' && aiChoice == 'Paper') ||
        (playerChoice == 'Paper' && aiChoice == 'Rock')) {
      result = GameResult.PlayerWin;
    } else {
      result = GameResult.AIWin;
    }

    setState(() {
      _playerChoice = playerChoice;
      _aiChoice = aiChoice;
      _round++;

      if (result == GameResult.PlayerWin) {
        _playerScore++;
      } else if (result == GameResult.AIWin) {
        _aiScore++;
      }

      if (_round > 3) {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    String resultText;
    if (_playerScore > _aiScore) {
      resultText = 'You Win! ($_playerScore - $_aiScore)';
    } else if (_aiScore > _playerScore) {
      resultText = 'AI Wins! ($_aiScore - $_playerScore)';
    } else {
      resultText = 'It\'s a Draw! ($_playerScore - $_aiScore)';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Game Result',
          style: TextStyle(
            fontFamily: 'EXOT350B',
          ),
        ),
        content: Text(resultText),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _playerChoice = '';
                _aiChoice = '';
                _playerScore = 0;
                _aiScore = 0;
                _round = 1;
              });
              Navigator.of(context).pop();
            },
            child: const Text(
              'Play Again',
              style: TextStyle(
                fontFamily: 'EXOT350B',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(String choice, String imagePath) {
    return ElevatedButton(
      onPressed: () => _playGame(choice),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 59, 57, 57), // دکمه سفید
        foregroundColor: Colors.white, // متن سیاه
        minimumSize: const Size(100, 50), // حداقل ابعاد دکمه
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20), // فاصله داخلی دکمه
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 80,
            height: 90,
          ),
          const SizedBox(height: 5),
          Text(choice, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonSpacing = constraints.maxWidth > 600 ? 20.0 : 10.0;
        double scoreFontSize = constraints.maxWidth > 600 ? 24.0 : 18.0;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Player Score',
                          style: TextStyle(
                            fontSize: scoreFontSize,
                            fontFamily: 'EXOT350B',
                          )),
                      const SizedBox(height: 10),
                      Text('$_playerScore',
                          style: TextStyle(
                            fontSize: scoreFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'EXOT350B',
                          )),
                    ],
                  ),
                  SizedBox(width: buttonSpacing),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('AI Score',
                          style: TextStyle(
                            fontSize: scoreFontSize,
                            fontFamily: 'EXOT350B',
                          )),
                      const SizedBox(height: 10),
                      Text('$_aiScore',
                          style: TextStyle(
                            fontSize: scoreFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'EXOT350B',
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text('Round $_round',
                  style: TextStyle(
                    fontSize: scoreFontSize,
                    fontFamily: 'EXOT350B',
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChoiceButton('Rock', 'lib/Game/images/rock.png'),
                  SizedBox(width: buttonSpacing),
                  _buildChoiceButton('Paper', 'lib/Game/images/paper.png'),
                  SizedBox(width: buttonSpacing),
                  _buildChoiceButton(
                      'Scissors', 'lib/Game/images/scissors.png'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Player Choice',
                          textAlign:
                              TextAlign.center, // وسط چین کردن متن در داخل Text
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'EXOT350B',
                          ),
                        ),
                        Text(
                          _playerChoice,
                          textAlign:
                              TextAlign.center, // وسط چین کردن متن در داخل Text
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'EXOT350B',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'AI Choice',
                          textAlign:
                              TextAlign.center, // وسط چین کردن متن در داخل Text
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'EXOT350B',
                          ),
                        ),
                        Text(
                          _aiChoice,
                          textAlign:
                              TextAlign.center, // وسط چین کردن متن در داخل Text
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'EXOT350B',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

enum GameResult { Draw, PlayerWin, AIWin }
