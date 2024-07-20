import 'dart:io';

import 'package:flutter/material.dart';
import 'package:main_game/Game/Game1.dart';
import 'package:main_game/Game/Game10.dart';
import 'package:main_game/Game/Game2.dart';
import 'package:main_game/Game/Game3.dart';
import 'package:main_game/Game/Game4.dart';
import 'package:main_game/Game/Game5.dart';
import 'package:main_game/Game/Game6.dart';
import 'package:main_game/Game/Game7.dart';
import 'package:main_game/Game/Game8.dart';
import 'package:image_picker/image_picker.dart';
import 'package:main_game/Game/Game9.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        fontFamily: 'EXOT350B',
        primaryColor: const Color(0xFFD1C4E9),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFFCDD2),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 209, 17, 0),
      end: const Color.fromARGB(255, 0, 0, 0),
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(username: 'User'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          double fontSize = isMobile ? 40 : 80;
          double progressBarHeight = isMobile ? 20 : 40;
          EdgeInsets padding = isMobile
              ? const EdgeInsets.only(top: 30, left: 20, right: 20)
              : const EdgeInsets.only(top: 60, left: 50, right: 50);

          return Stack(
            children: [
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/splash-bg.jpg'),
                    fit: isMobile ? BoxFit.cover : BoxFit.fitWidth,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      'GameVerse',
                      style: TextStyle(
                        fontFamily: 'EXOT350B',
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 46, 44, 44),
                      ),
                    ),
                    const Spacer(flex: 3),
                    Padding(
                      padding: padding,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: progressBarHeight,
                              child: LinearProgressIndicator(
                                value: _controller.value,
                                backgroundColor: Colors.white,
                                valueColor: _colorAnimation,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_showButton)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _navigateToHome(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 44, 42, 42),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Let\'s Go',
                            style: TextStyle(
                              fontFamily: 'EXOT350B',
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Game> games = [
    Game(
        title: 'Game 1',
        imagePath: 'assets/images/im1.jpg',
        description: 'SnakeGame'),
    Game(
        title: 'Game 2',
        imagePath: 'assets/images/im2.jpg',
        description: 'FlappyBirdGame'),
    Game(
        title: 'Game 3',
        imagePath: 'assets/images/im3.jpg',
        description: 'BrickBreakerGame'),
    Game(
        title: 'Game 4',
        imagePath: 'assets/images/im4.jpg',
        description: 'ChessGame'),
    Game(
        title: 'Game 5',
        imagePath: 'assets/images/im5.jpg',
        description: 'SudokuGame'),
    Game(
        title: 'Game 6',
        imagePath: 'assets/images/im6.jpg',
        description: 'SuperMario'),
    Game(
        title: 'Game 7',
        imagePath: 'assets/images/im7.jpg',
        description: 'BubbleTroubleMain'),
    Game(
        title: 'Game 8',
        imagePath: 'assets/images/im8.jpg',
        description: 'MemoryPuzzleGame'),
    Game(title: 'Game 9', imagePath: 'assets/images/im9.jpg', description: ''),
    Game(
        title: 'Game 10', imagePath: 'assets/images/im10.jpg', description: ''),
  ];
  String _avatarPath = 'assets/images/avatar.jpg';
  String _username = 'User';
  String _userId = 'UserID';
  String _email = 'user@example.com';

  Set<String> playedGames = {};
  void _addPlayedGame(String gameTitle) {
    if (!mounted) return; // اضافه کردن چک mounted

    setState(() {
      playedGames.add(gameTitle);
    });
  }

  void _navigateToPlayedGamesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlayedGamesScreen(playedGames: playedGames.toList()),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();
  bool _showHelloText = false;
  bool _isScrolledDown = false;
  int gamesPlayed = 0;
  void _incrementGamesPlayed() {
    setState(() {
      gamesPlayed++; // افزایش تعداد بازی‌ها
    });
  }

  @override
  void initState() {
    super.initState();
    _animateCards();

    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_isScrolledDown) {
        setState(() {
          _isScrolledDown = true;
          _showHelloText = true;
        });
      } else if (_scrollController.offset <= 0 && _isScrolledDown) {
        setState(() {
          _isScrolledDown = false;
          _showHelloText = false;
        });
      }
    });
  }

  Future<void> _animateCards() async {
    for (int i = 0; i < games.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        games[i].isVisible = true;
      });
    }
  }

  void _navigateToProfileScreen(BuildContext context) async {
    final selectedAvatar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          username: widget.username,
          playedGames: playedGames.toList(),
        ),
      ),
    );

    if (selectedAvatar != null && selectedAvatar.isNotEmpty) {
      setState(() {
        _avatarPath = selectedAvatar;
      });
    }
  }

  void _navigateToGameScreen(Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(game: game),
      ),
    );
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarPath = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pattern.jpg'), // مسیر تصویر
                  fit: BoxFit.cover, // نحوه پوشش دادن تصویر
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 40, // افزایش شعاع برای بزرگتر شدن دایره
                          backgroundImage:
                              AssetImage('assets/images/avatar1.jpg'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'HOME',
                style: TextStyle(
                  fontFamily: 'EXOT350B',
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // بستن منوی همبرگر
                // انجام هر عملیات دیگری که نیاز دارید در اینجا اضافه کنید
              },
            ),
            const ListTile(
              leading: Icon(Icons.person,
                  color: Colors.grey), // تغییر رنگ آیکون به طوسی
              title: Text(
                'PROFILE',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'EXOT350B',
                  color: Colors.grey, // تغییر رنگ متن به طوسی
                ),
              ),
              onTap: null, // غیرفعال کردن دکمه
              enabled: false, // غیرفعال کردن لیست آیتم
              trailing: Tooltip(
                // اضافه کردن Tooltip برای نمایش پیام "Coming Soon"
                message: 'Coming Soon',
                child: Icon(Icons.info_outline, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.games),
              title: const Text(
                'GAMES PLAYED',
                style: TextStyle(
                  fontFamily: 'EXOT350B',
                  fontSize: 18,
                ),
              ),
              onTap: () => _navigateToPlayedGamesScreen(context),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'EXIT',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'EXOT350B',
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        int crossAxisCount = isMobile ? 2 : 4;
        double childAspectRatio = isMobile ? 0.75 : 1.0;

        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding:
                  const EdgeInsets.symmetric(vertical: 17.0, horizontal: 8.0),
              color: _isScrolledDown
                  ? Colors.white
                  : const Color.fromARGB(0, 130, 50, 50),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Text(
                    _showHelloText
                        ? 'Let\'s Play Together'
                        : 'Welcome to GameVerse',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'EXOT350B',
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar1.jpg'),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: _isScrolledDown ? 1.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: const SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HoverText(
                        text: 'All',
                      ),
                      HoverText(text: 'Top Rates'),
                      HoverText(text: 'Strategy'),
                      HoverText(text: 'Graphics'),
                      HoverText(text: 'Adventure'),
                      HoverText(text: 'Excitement'),
                      HoverText(text: 'Interaction'),
                      HoverText(text: 'Challenge'),
                      HoverText(text: 'Creativity'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: games[index].isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: HoverCard(
                      game: games[index],
                      onTap: () {
                        _addPlayedGame(games[index]
                            .title); // اضافه کردن بازی به لیست بازی‌های انجام شده
                        _navigateToGameScreen(games[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ProfileEditScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const ProfileEditScreen({Key? key, required this.profileData})
      : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _idController;
  late TextEditingController _emailController;
  bool _acceptTerms = false;
  late String _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.profileData['username']);
    _idController = TextEditingController(text: widget.profileData['id']);
    _emailController = TextEditingController(text: widget.profileData['email']);
    _selectedAvatar =
        widget.profileData['avatar'] ?? 'assets/images/avatar1.jpg';
  }

  void _saveProfile() {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the terms and conditions to continue.',
            style: TextStyle(
              fontFamily: 'EXOT350B',
            ),
          ),
        ),
      );
      return;
    }
    Navigator.pop(
        context, _selectedAvatar); // برگرداندن آواتار انتخابی به HomeScreen
  }
  //   Navigator.pop(context, {
  //     'username': _usernameController.text,
  //     'id': _idController.text,
  //     'email': _emailController.text,
  //     'avatar': _selectedAvatar,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Edit Profile',
        style: TextStyle(
          fontFamily: 'EXOT350B',
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            CheckboxListTile(
              title: const Text(
                'I accept the game terms and conditions',
                style: TextStyle(
                  fontFamily: 'EXOT350B',
                ),
              ),
              value: _acceptTerms,
              onChanged: (bool? value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
            ),
            const Text(
              'Choose an Avatar',
              style: TextStyle(
                fontFamily: 'EXOT350B',
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 3,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  final avatar = 'assets/images/avatar${index + 1}.jpg';
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = avatar;
                      });
                    },
                    child: Image.asset(avatar),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'EXOT350B',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final Game game;
  final VoidCallback onTap;

  const HoverCard({super.key, required this.game, required this.onTap});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                widget.game.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HoverText extends StatefulWidget {
  final String text;

  const HoverText({super.key, required this.text});

  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: const TextStyle(fontSize: 18),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: _isHovered ? 40 : 0,
              color: _isHovered
                  ? const Color.fromARGB(255, 78, 1, 15)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  final Game game;

  const GameScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
      ),
      body: Center(
        child: _buildGameWidget(game.title),
      ),
    );
  }

  Widget _buildGameWidget(String title) {
    switch (title) {
      case 'Game 3':
        return const BrickBreakerGame();
      case 'Game 7':
        return const BubbleTroubleMain();
      case 'Game 2':
        return FlappyBirdGame();
      case 'Game 8':
        return MemoryPuzzleGame();
      case 'Game 1':
        return const SnakeGame();
      case 'Game 4':
        return const ChessGame();
      case 'Game 5':
        return const SudokuGame();
      case 'Game 6':
        return const SuperMario();
      case 'Game 9':
        return RpsGame();
      case 'Game 10':
        return CharacterSelectionScreen();
      default:
        return const Text('No game available');
    }
  }
}

class ProfileScreen extends StatefulWidget {
  final List<String> playedGames;

  const ProfileScreen(
      {super.key, required this.playedGames, required String username});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _acceptTerms = false;
  String _selectedAvatar = '';
  final List<String> _avatars = [
    'assets/images/avatar1.jpg',
    'assets/images/avatar2.jpg',
    'assets/images/avatar3.jpg'
  ];

  void _saveProfile() {
    if (!_acceptTerms) {
      // نمایش پیامی به کاربر برای قبول کردن قوانین
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the terms and conditions to continue.',
            style: TextStyle(fontFamily: 'EXOT350B'),
          ),
        ),
      );
      return;
    }

    // ذخیره پروفایل (اینجا فقط اطلاعات را چاپ می‌کنیم)
    print('Username: ${_usernameController.text}');
    print('ID: ${_idController.text}');
    print('Email: ${_emailController.text}');
    print('Accepted Terms: $_acceptTerms');
    print('Selected Avatar: $_selectedAvatar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'EXOT350B'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                ),
                const Text(
                  'I accept the game terms and conditions',
                  style: TextStyle(fontFamily: 'EXOT350B'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Select an Avatar:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'EXOT350B'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _avatars.map((avatar) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = avatar;
                    });
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(avatar),
                    radius: 40,
                    backgroundColor: _selectedAvatar == avatar
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.5),
                    child: _selectedAvatar == avatar
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text(
                  'Save Profile',
                  style: TextStyle(fontFamily: 'EXOT350B'),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class Game {
  final String title;
  final String imagePath;
  bool isVisible;

  Game(
      {required this.title,
      required this.imagePath,
      this.isVisible = false,
      required String description});
}

class PlayedGamesScreen extends StatelessWidget {
  final List<String> playedGames;

  const PlayedGamesScreen({Key? key, required this.playedGames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Played Games',
          style: TextStyle(fontFamily: 'EXOT350B'),
        ),
      ),
      body: ListView.builder(
        itemCount: playedGames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(playedGames[index]),
            // اضافه کردن موارد دیگر اینجا
          );
        },
      ),
    );
  }
}
