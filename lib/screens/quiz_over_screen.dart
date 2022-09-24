import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/screens/loading_screen.dart';
import 'package:quiz_app/screens/navgation_bar_holder.dart';
import 'package:quiz_app/util/constants.dart';
import 'package:quiz_app/widgets/snack_bar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum SocialMedia { facebook, twitter, whatsapp }

class QuizOverScreen extends StatelessWidget {
  static const String id = '/QuizOver';
  const QuizOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidgth = MediaQuery.of(context).size.width;
    var provider = Provider.of<QuizAppProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [COLOR_BEIGE, COLOR_DARK_BEIGE, COLOR_LIGHT_BROWN],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: provider.isLoading
            ? LoadingWidget()
            : Center(
                child: Container(
                  // height: screenHeight / 3,
                  width: screenWidgth / 1.2,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: COLOR_BROWN,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset('assets/images/cat-works.json'),
                      Center(
                          child: Text(
                        provider.quizIsOverMessage,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                      Divider(
                        color: COLOR_LIGHT_BROWN,
                        thickness: 3,
                      ),
                      Text(
                        'You answered a total of ${provider.score} questions right! 💪',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: COLOR_BEIGE),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            provider.resetQuiz();
                            Navigator.pushNamedAndRemoveUntil(
                                context, MyNavigationBar.id, (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Go Back Home',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Share the result with friends',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.4)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(FontAwesomeIcons.twitter,
                                color: COLOR_DARK_BEIGE),
                            onPressed: () =>
                                share(SocialMedia.twitter, context),
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.whatsapp,
                                color: COLOR_DARK_BEIGE),
                            onPressed: () =>
                                share(SocialMedia.whatsapp, context),
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.facebook,
                                color: COLOR_DARK_BEIGE),
                            onPressed: () =>
                                share(SocialMedia.facebook, context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

Future share(SocialMedia socialPlatform, context) async {
  var provider = Provider.of<QuizAppProvider>(context, listen: false);
  final text = "I answered ${provider.score} correct answers in QuizU!";
  final urls = {
    SocialMedia.facebook: "https://www.facebook.com/share/sharer.php?t=$text",
    SocialMedia.twitter: "https://www.twitter.com/intent/tweet?text=$text",
    SocialMedia.whatsapp: "https://api.whatsapp.com/send?text=$text"
  };
  final url = urls[socialPlatform]!;
  if (await canLaunchUrlString(url))
    await launchUrlString(url);
  else
    showActionSnackBar(context, 'Error launching ${socialPlatform.name}');
}
