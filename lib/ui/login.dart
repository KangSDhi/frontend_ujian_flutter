import 'package:flutter/material.dart';
import 'package:frontend_ujian_flutter/services/auth-service.dart';
import 'package:frontend_ujian_flutter/ui/dashboard.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();

}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrIdSiswaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    if(_formKey.currentState!.validate()){
      bool loginOk = await _authService.login(_emailOrIdSiswaController.text, _passwordController.text);
      if(loginOk){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Yay, Berhasil Masuk!"))
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Gagal, Cek Kredensial!"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Login Ujian",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue
                        ),
                      ),
                      const SizedBox(height: 24,),
                      TextFormField(
                        controller: _emailOrIdSiswaController,
                        decoration: InputDecoration(
                          labelText: "Email atau ID Peserta",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          prefixIcon: const Icon(Icons.person)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return "Mohon Masukan Email!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16,),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility
                                ))
                        ),
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return "Mohon Masukkan Password!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)
                              )
                            ),
                            child: Text(
                              "Masuk",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                              ),
                            )
                        )
                      )
                    ],
                  )
              ),
            ),
          ),
        ),
      )
    );
  }
}