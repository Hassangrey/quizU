import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/screens/loading_screen.dart';
import 'package:quiz_app/screens/navgation_bar_holder.dart';
import 'package:quiz_app/util/constants.dart';

class EnterYourNameScreen extends StatefulWidget {
  static const String id = '/EnterYourName';

  const EnterYourNameScreen({Key? key}) : super(key: key);

  @override
  State<EnterYourNameScreen> createState() => _EnterYourNameScreenState();
}

class _EnterYourNameScreenState extends State<EnterYourNameScreen> {
  Future<void> postUserName(String name) async {
    var provider = Provider.of<QuizAppProvider>(context, listen: false);
    await provider.postName(name);
    Navigator.pushNamedAndRemoveUntil(
        context, MyNavigationBar.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidgth = MediaQuery.of(context).size.width;
    var provider = Provider.of<QuizAppProvider>(context);
    TextEditingController nameController = TextEditingController();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [COLOR_BEIGE, COLOR_DARK_BEIGE, COLOR_LIGHT_BROWN],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: provider.isLoading
            ? LoadingWidget()
            : Center(
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Container(
                    width: screenWidgth / 1.2,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: COLOR_BROWN,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Enter Your Name',
                          style: TextStyle(
                              color: COLOR_WHIEE,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Your Name',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              hintText: 'name',
                              hintStyle: const TextStyle(color: COLOR_BEIGE),
                              fillColor: COLOR_BEIGE),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => postUserName(nameController.text),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
