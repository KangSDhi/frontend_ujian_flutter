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
      appBar: AppBar(
        title: Text("Login Ujian"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailOrIdSiswaController,
                  decoration: InputDecoration(
                    labelText: "Email atau ID Peserta",
                    border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return "Mohon Masukan Email!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
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
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: _login,
                        child: Text("Masuk"))
                  ],
                )
              ],
            )
        ),
      ),
    );
  }
}