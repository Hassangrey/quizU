import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/screens/home_page_screen.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/services/quiz_app_services.dart';
import 'package:quiz_app/util/constants.dart';

class MyNavigationBar extends StatefulWidget {
  static const String id = '/NabBarScreen';
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  Future<void> getTopTenScores() async {
    var provider = Provider.of<QuizAppProvider>(context, listen: false);
    await provider.getTopTen();
    await provider.getUserInfo();
  }

  @override
  void initState() {
    getTopTenScores();
    super.initState();
  }

  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    const LeaderboardScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: COLOR_LIGHT_BROWN,
        selectedItemColor: COLOR_BEIGE,
        unselectedItemColor: COLOR_BROWN,
        showUnselectedLabels: false,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: '',
          ),
        ],
      ),
    );
  }
}
