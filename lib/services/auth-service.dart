import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static Future<void> init() async {
    await dotenv.load(fileName: 'assets/env/.env_dev');
  }

  static String get baseUrl => dotenv.env['BASE_URL_RESTFUL'] ?? "http://localhost:8080/api";

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("jwt-auth");

    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/auth/check/user"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) return false;

      final responseData = jsonDecode(response.body);

      if (['ADMIN', 'GURU'].contains(responseData['data']['level'])) return false;

      return true;
    } on SocketException {
      if (kDebugMode) {
        print('No Internet connection 😑');
      }
      return false;
    } on HttpException {
      if (kDebugMode) {
        print("Couldn't find the post 😱");
      }
      return false;
    } on FormatException {
      if (kDebugMode) {
        print("Bad response format 👎");
      }
      return false;
    } on TimeoutException {
      if (kDebugMode) {
        print("Request timed out ⏳");
      }
      return false;
    }
  }

  Future<bool> login(String emailOrIdSiswa, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse("$baseUrl/auth/signin"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email_or_id_siswa': emailOrIdSiswa,
        'password': password,
      }),
    );

    if (response.statusCode != 200) return false;

    final responseData = jsonDecode(response.body);

    if (['ADMIN', 'GURU'].contains(responseData['data']['level'])) return false;

    await prefs.setString("jwt-auth", responseData['data']['token']);
    return true;
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("jwt-auth");
    return true;
  }
}

