import 'package:flutter/material.dart';
import '../services/active_user.dart';
import '../services/participant_service.dart'; // Import ActiveUser


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Simulate login (replace with actual authentication)
    bool success = await ParticipantService().checkParticipant(email, password);
    if (success) {
      final activeUser = ActiveUser();
      await activeUser.setActiveUser(email);
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      setState(() {
        _errorMessage = 'Неверный логин или пароль';
      });
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade50],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    'Вход',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                        shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.grey.shade700,
                          offset: Offset(2, 2),
                        ),
                      ]
                    ),
                  ),
                  SizedBox(height: 20),
                   TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.blue.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8)
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                   TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: Icon(Icons.lock, color: Colors.blue.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8)
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите пароль';
                      }
                      return null;
                    },
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                    ),
                  SizedBox(height: 24),
                   _buildStyledButton(
                    text: 'Войти',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                     color: Colors.blue.shade800,
                    textColor: Colors.white,
                     width: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
     required double width,
  }) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text, style: TextStyle(color: textColor)),
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )
          )
      )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}