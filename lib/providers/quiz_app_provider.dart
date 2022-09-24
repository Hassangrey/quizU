import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quiz_app/services/app_sharedprefrences.dart';
import 'package:quiz_app/services/quiz_app_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizAppProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;
  bool isNewAccount = false;
  bool hasError = false;
  String message = '';
  String userName = '';
  List<dynamic> topTen = [];
  List<dynamic> questions = [];
  String phone_number = '';
  String OTP = '';
  String token = '';
  int score = 0;
  String quizIsOverMessage = '';

  Future<void> postLogin(String phone_number, String otp) async {
    // * Show loading screen when the method is being called
    isLoading = true;
    hasError = false;
    notifyListeners();
    // * Take the response to habdle errors or the OK states
    http.Response response =
        (await QuizAppServices().login(phone_number, otp))!;
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
      print(jsonResponse);
      isLoggedIn = true;
      hasError = false;
      // * Save the token in a local storage when the user logs in.
      token = jsonResponse['token'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      //  message = jsonResponse['msg'];
      isNewAccount = jsonResponse['user_status'] == 'new';
      if (!isNewAccount) {
        userName = jsonResponse['name'];
        phone_number = jsonResponse['mobile'];
      }
    } else {
      hasError = true;
      print(response.statusCode);
    }
    isLoading = false;
    notifyListeners();
  }

  getTopTen() async {
    isLoading = true;
    topTen = await QuizAppServices().getTopTenScores();
    isLoading = false;
    notifyListeners();
  }

  getQuestions() async {
    isLoading = true;
    notifyListeners();
    questions = await QuizAppServices().getQuestions();
    isLoading = false;
    notifyListeners();
  }

  getUserInfo() async {
    isLoading = true;
    var userinfo = await QuizAppServices().fetchUserInfo();
    phone_number = userinfo['mobile'];
    userName = userinfo['name'];
    isLoading = false;
    notifyListeners();
  }

  Future<void> postName(String name) async {
    isLoading = true;
    notifyListeners();
    http.Response response = (await QuizAppServices().addUserName(name))!;
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
    } else {
      print('Error: ${response.statusCode} has occured.');
      print(jsonResponse);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> postScore(String score) async {
    isLoading = true;
    notifyListeners();
    http.Response response = (await QuizAppServices().addScore(score))!;
    if (response.statusCode == 201) {
      print('Post successfully');
    } else {
      print('Error: ${response.statusCode} has occured.');
      // print(jsonResponse);
    }
    isLoading = false;
    notifyListeners();
  }

  void checkLogin() async {
    String prefs = await AppSharedPreference.readToken('token');
    isLoggedIn = prefs == null ? false : true;
    notifyListeners();
  }

  void resetQuiz() {
    score = 0;
  }
}
