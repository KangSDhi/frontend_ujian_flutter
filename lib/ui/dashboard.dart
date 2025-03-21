import 'package:flutter/material.dart';
import 'package:frontend_ujian_flutter/services/auth-service.dart';
import 'package:frontend_ujian_flutter/ui/login.dart';

class Dashboard extends StatefulWidget {

  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
              onPressed: () => _showLogoutModal(context),
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text("Dashboard")
        ,)
      ,);
  }
}

void _showLogoutModal(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Logout"),
          content: Text("Apakah anda yakin ingin keluar?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Batal")
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _logout(context);
                },
                child: Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                )
            )
          ],
        );
      });
}

void _logout(BuildContext context) async {
  final AuthService authService = AuthService();
  bool logoutOk = await authService.logout();
  if (!context.mounted) return;
  if(logoutOk) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }
}