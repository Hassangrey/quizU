import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/screens/loading_screen.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        appBar: AppBar(
          title: Text('Profile'),
        ),
        backgroundColor: Colors.transparent,
        body: provider.isLoading
            ? LoadingWidget()
            : Center(
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Container(
                    // height: screenHeight / 3,
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
                        const SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              color: COLOR_DARK_BEIGE.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 10),
                              Text(
                                provider.userName == ''
                                    ? 'USER_NAME'
                                    : provider.userName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              color: COLOR_DARK_BEIGE.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              Icon(Icons.phone),
                              SizedBox(width: 10),
                              Text(
                                provider.phone_number,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          'Your saved past scores:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(width: 12);
                            },
                          ),
                        ),
                        Divider(color: COLOR_LIGHT_BROWN, thickness: 3),
                        SizedBox(height: 10),
                        LogoutButton(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.id, (route) => false);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
