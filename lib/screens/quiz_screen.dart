import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/loading_screen.dart';
import 'package:quiz_app/screens/quiz_over_screen.dart';
import 'package:quiz_app/util/constants.dart';
import 'package:quiz_app/widgets/snack_bar_widget.dart';

import '../providers/quiz_app_provider.dart';

final controller = PageController(initialPage: 0);

class QuizScreen extends StatefulWidget {
  static const String id = '/QuizScreen';

  QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int skip = 1;
  static const maxSeconds = 120;
  int secounds = maxSeconds;
  Timer? timer;
  void startTime() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secounds > 0) {
        setState(() => secounds--);
      } else {
        var provider = Provider.of<QuizAppProvider>(context, listen: false);
        provider.quizIsOverMessage = 'Times is up! ⏰';

        stopTimer();
        Navigator.pushNamedAndRemoveUntil(
            context, QuizOverScreen.id, (route) => false);
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void initState() {
    if (mounted) startTime();
    super.initState();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuizAppProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [COLOR_LIGHT_BROWN, COLOR_DARK_BEIGE, COLOR_BEIGE],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: provider.isLoading
                ? LoadingWidget()
                : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller,
                      itemCount: provider.questions.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Text(
                              'Question: ${index + 1}/${provider.questions.length}',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              provider.questions[index]['Question'],
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            // Spacer(),
                            SizedBox(height: 20),
                            answerWidget(
                                answerLetter: 'a',
                                answer: provider.questions[index]['a'],
                                index: index),
                            Divider(),
                            answerWidget(
                                answerLetter: 'b',
                                answer: provider.questions[index]['b'],
                                index: index),
                            Divider(),
                            answerWidget(
                                answerLetter: 'c',
                                answer: provider.questions[index]['c'],
                                index: index),
                            Divider(),
                            answerWidget(
                                answerLetter: 'd',
                                answer: provider.questions[index]['d'],
                                index: index),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CircularProgressIndicator(
                                        value: secounds / maxSeconds,
                                        strokeWidth: 5,
                                        color: COLOR_BROWN,
                                      ),
                                      Center(
                                        child: Text(
                                          secounds.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (skip == 1)
                                      setState(() {
                                        skip = 0;
                                        controller.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInBack);
                                      });
                                  },
                                  child: Text(
                                    'Skip ($skip/1)',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        );
                      },
                    ),
                  )),
      ),
    );
  }
}

class answerWidget extends StatelessWidget {
  const answerWidget({
    Key? key,
    required this.answerLetter,
    required this.answer,
    required this.index,
  }) : super(key: key);

  final String answerLetter;
  final String answer;
  final int index;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuizAppProvider>(context);
    Timer? timer;
    return InkWell(
      onTap: () {
        if (provider.questions[index]['correct'] == answerLetter) {
          if (index == provider.questions.length - 1) {
            provider.score++;
            provider.quizIsOverMessage = 'You Are Done! 🥳';
            provider.postScore(provider.score.toString());
            timer?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context, QuizOverScreen.id, (route) => false);
          } else {
            provider.score++;
            provider.quizIsOverMessage = 'Oh no! Wrong Answer 😫';
            controller.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInBack);
          }
        } else {
          provider.postScore(provider.score.toString());
          timer?.cancel();
          Navigator.pushNamedAndRemoveUntil(
              context, QuizOverScreen.id, (route) => false);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
            color: COLOR_BEIGE,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: COLOR_BROWN, width: 3)),
        child: Text(
          answer,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
