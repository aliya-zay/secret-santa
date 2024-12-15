import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/participant.dart';
import 'dart:convert';
import 'dart:io';
import '../services/active_user.dart';
import '../services/participant_service.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Здесь должна быть логика регистрации пользователя
      // В этом примере - просто вывод данных в консоль
      print('Имя: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Дата рождения: ${_birthdayController.text}');
      print('Пароль: ${_passwordController.text}');

      final participant = Participant(
        name: _nameController.text,
        email: _emailController.text,
        birthday: _birthdayController.text,
        password: _passwordController.text, // NEVER store passwords like this!,
      );

      try {
        await ParticipantService().addParticipant(participant);
        final activeUser = ActiveUser();
        await activeUser.setActiveUser(participant.email);
        Navigator.pushReplacementNamed(context, "/main");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Успех!'),
            content: const Text('Теперь вы в игре!'),
            // actions: [
            //   TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
            // ],
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ошибка!'),
            content: Text('Ошибка при добавлении участника: $e'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
            ],
          ),
        );
      }
      // Переход на главную страницу
      // ... (Add navigation logic here) ...
    }
  }

    Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('yyyy-MM-dd').format(picked); // Format the date
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
                    'Регистрация',
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
                      controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя',
                      prefixIcon: Icon(Icons.person, color: Colors.green.shade800),
                       border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                       filled: true,
                        fillColor: Colors.white.withOpacity(0.8)
                     ),
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите имя';
                      }
                      return null;
                    },
                  ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.green.shade800),
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
                      controller: _birthdayController,
                      decoration: InputDecoration(
                        labelText: 'Дата рождения',
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.green.shade800),
                         border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                         ),
                         filled: true,
                          fillColor: Colors.white.withOpacity(0.8)
                      ),
                      readOnly: true, // Prevent direct text input
                      onTap: () => _selectDate(context), // Show date picker on tap
                         validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, выберите дату рождения';
                      }
                      return null;
                    },
                    ),
                     if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                    ),

                    SizedBox(height: 16),
                     TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: Icon(Icons.lock, color: Colors.green.shade800),
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
                    text: 'Зарегистрироваться',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register();
                      }
                    },
                     color: Colors.green.shade800,
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
    _nameController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}