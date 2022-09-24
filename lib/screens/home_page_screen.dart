import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/screens/loading_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/services/quiz_app_services.dart';
import 'package:quiz_app/util/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getQuestions() async {
    var provider = Provider.of<QuizAppProvider>(context, listen: false);
    await provider.getQuestions();
    Navigator.pushNamedAndRemoveUntil(context, QuizScreen.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuizAppProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      backgroundColor: COLOR_BEIGE,
      body: SafeArea(
        child: provider.isLoading
            ? LoadingWidget()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/pumpkin-black-cat.json'),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => getQuestions(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Start Quiz!',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w900),
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
