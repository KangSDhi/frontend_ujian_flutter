import 'package:flutter/material.dart';
import 'package:frontend_ujian_flutter/services/auth-service.dart';
import 'package:frontend_ujian_flutter/services/health-service.dart';
import 'package:frontend_ujian_flutter/ui/dashboard.dart';
import 'package:frontend_ujian_flutter/ui/login.dart';
import 'package:frontend_ujian_flutter/ui/not-health.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HealthService.init();
  bool isHealth = await checkHealthApi();
  bool isLoggedIn = await checkLoginStatus();
  runApp(MyApp(isLoggedIn: isLoggedIn, isHealth: isHealth,));
}

Future<bool> checkHealthApi() async {
  HealthService healthService = HealthService();
  return await healthService.ping();
}

Future<bool> checkLoginStatus() async {
  AuthService authService = AuthService();
  return await authService.isLoggedIn();
}

class MyApp extends StatelessWidget {
  final bool isHealth;
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn, required this.isHealth});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: !isHealth ? NotHealth() : (isLoggedIn ? Dashboard() : Login()),
    );
  }
}
