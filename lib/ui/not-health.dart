import 'package:flutter/material.dart';
import 'package:frontend_ujian_flutter/main.dart';
import 'package:frontend_ujian_flutter/services/auth-service.dart';
import 'package:frontend_ujian_flutter/services/health-service.dart';

class NotHealth extends StatelessWidget {

  const NotHealth({super.key});

  @override
  Widget build(BuildContext context) {

    Future<void> retry() async {
      HealthService healthService = HealthService();
      AuthService authService = AuthService();
      bool isHealth = await healthService.ping();
      bool isLoggedIn = await authService.isLoggedIn();
      if(isHealth){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(isLoggedIn: isLoggedIn, isHealth: isHealth)));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 20,),
              const Text(
                  "Oops!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87
              ),),
              const SizedBox(height: 10,),
              const Text(
                "Lagi perbaikan nih, kembali nanti ya...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87
                ),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                  onPressed: () => retry(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.orange
                  ),
                  child: const Text(
                    "Coba Lagi",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )
              )
            ],
          ),
        )
      ),
    );
  }
}