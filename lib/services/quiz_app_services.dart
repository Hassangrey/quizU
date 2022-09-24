import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuizAppServices {
  static const baseUrl = 'https://quizu.okoul.com/';
  static const tokenEndPoint = 'Token';
  static const loginEndPoint = 'Login';
  static const nameEndPoint = 'Name';
  static const topScoresEndPoint = 'TopScores';
  static const userInfoEndPoint = 'UserInfo';
  static const questionsEndPoint = 'Questions';
  static const scoreEndPoint = 'Score';

  Future<http.Response?> login(String phone_number, String otp) async {
    var client = http.Client();
    http.Response? response;

    try {
      response = await client.post(Uri.parse(baseUrl + loginEndPoint),
          body: {"mobile": phone_number, "OTP": otp});
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<http.Response?> addUserName(String name) async {
    var client = http.Client();
    http.Response? response;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    ;
    try {
      response = await client.post(
        Uri.parse(baseUrl + nameEndPoint),
        body: {"name": name},
        headers: {"Authorization": "Bearer $token"},
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<http.Response?> addScore(String score) async {
    var client = http.Client();
    http.Response? response;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    ;
    try {
      response = await client.post(
        Uri.parse(baseUrl + scoreEndPoint),
        body: {"score": score},
        headers: {"Authorization": "$token"},
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future getTopTenScores() async {
    var client = http.Client();
    http.Response? response;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    response = await client.get(Uri.parse(baseUrl + topScoresEndPoint),
        headers: {"Authorization": "Bearer $token"});
    try {
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonResponse as List;
      } else {
        print('Error: ${response.statusCode} has occured.');
        print(jsonResponse);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future getQuestions() async {
    var client = http.Client();
    http.Response? response;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    response = await client.get(Uri.parse(baseUrl + questionsEndPoint),
        headers: {"Authorization": "Bearer $token"});
    try {
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonResponse as List;
      } else {
        print('Error: ${response.statusCode} has occured.');
        print(jsonResponse);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> fetchUserInfo() async {
    var client = http.Client();
    http.Response? response;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    response = await client.get(Uri.parse(baseUrl + userInfoEndPoint),
        headers: {"Authorization": "Bearer $token"});
    try {
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        print('Error: ${response.statusCode} has occured.');
        print(jsonResponse);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
