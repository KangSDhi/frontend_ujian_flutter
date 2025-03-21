import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HealthService {

  static Future<void> init() async {
    await dotenv.load(fileName: 'assets/env/.env_dev');
  }

  static String get baseUrl => dotenv.env['BASE_URL_RESTFUL'] ?? "http://localhost:8080/api";

  Future<bool> ping() async {

    if (kDebugMode) {
      print("start ping");
    }

    try {
      final response = await http.get(
          Uri.parse("$baseUrl/health/ping"),
          headers: {
            'Content-Type': 'application/json'
          }
      )
      .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) return false;

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
}