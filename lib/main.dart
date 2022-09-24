import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/screens/enter_name_screen.dart';
import 'package:quiz_app/screens/home_page_screen.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/screens/navgation_bar_holder.dart';
import 'package:quiz_app/screens/otp_screen.dart';
import 'package:quiz_app/screens/quiz_over_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoggedin = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.getString('token') == null ? isLoggedin = true : isLoggedin = false;

  runApp(ChangeNotifierProvider(
    create: (context) => QuizAppProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuizAppProvider>(context);
    provider.checkLogin;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuizAppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedin ? LoginScreen.id : MyNavigationBar.id,
        onGenerateRoute: onGenerateRoute,
        theme: ThemeData(
            fontFamily: 'OpenSans',
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: COLOR_DARK_BEIGE, secondary: COLOR_BEIGE)),
      ),
    );
  }
}

Route? onGenerateRoute(RouteSettings routeSettings) {
  if (routeSettings.name == LoginScreen.id) {
    return MaterialPageRoute(builder: (context) => LoginScreen());
  } else if (routeSettings.name == OtpScreen.id) {
    return MaterialPageRoute(builder: (_) => const OtpScreen());
  } else if (routeSettings.name == QuizScreen.id) {
    return MaterialPageRoute(builder: (_) => QuizScreen());
  } else if (routeSettings.name == EnterYourNameScreen.id) {
    return MaterialPageRoute(builder: (_) => const EnterYourNameScreen());
  } else if (routeSettings.name == MyNavigationBar.id) {
    return MaterialPageRoute(builder: (_) => const MyNavigationBar());
  } else if (routeSettings.name == QuizOverScreen.id) {
    return MaterialPageRoute(builder: (_) => const QuizOverScreen());
  } else {
    return null;
  }
}
