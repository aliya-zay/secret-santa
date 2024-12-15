import 'package:flutter/material.dart';
import 'create_room_page.dart';
import '../services/active_user.dart'; // Import ActiveUser

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _activeUser = ''; // Initialize with an empty string
  bool _isLoading = true; // Add a loading indicator

  @override
  void initState() {
    super.initState();
    _getActiveUser();
  }

  Future<void> _getActiveUser() async {
    final activeUser = ActiveUser();
    final userId = await activeUser.getActiveUser();
    setState(() {
      _activeUser = userId;
      _isLoading = false; // Update loading status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Главная страница')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient( // Add background gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade50],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or App Title
              Text(
                'Тайный Санта',
                style: TextStyle(
                  fontSize: 48,
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
              SizedBox(height: 40), // Spacing

              // Login Button
              _buildStyledButton(
                context: context,
                text: 'Вход',
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                icon: Icons.login, // Add an icon to the button
                color: Colors.blue.shade800,
                textColor: Colors.white,
                width: 200,
              ),
              SizedBox(height: 20), // Spacing

              // Registration Button
              _buildStyledButton(
                context: context,
                text: 'Регистрация',
                onPressed: () {
                  Navigator.pushNamed(context, '/registration');
                },
                icon: Icons.person_add, // Add an icon to the button
                color: Colors.green.shade700,
                textColor: Colors.white,
                width: 200,
              ),

              SizedBox(height: 20), // Spacing

              _buildStyledButton(
                 context: context,
                 text: 'Создать комнату',
                 onPressed: () {
                   Navigator.pushNamed(context, '/createRoom'); // Route to your room creation page
                 },
                 icon: Icons.add_box,
                 color: Colors.orange.shade700,
                 textColor: Colors.white,
                 width: 200,
               ),
              SizedBox(height: 20),

                // Join Room Button
              _buildStyledButton(
                context: context,
                text: 'Присоединиться к комнате',
                onPressed: () {
                  Navigator.pushNamed(context, '/joinRoom');
                },
                icon: Icons.group_add,
                color: Colors.deepPurple.shade700,
                textColor: Colors.white,
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
      required Color textColor,
    required double width,
  }) {
    return SizedBox(
       width: width,
      child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: textColor),
          label: Text(text, style: TextStyle(color: textColor)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
            ),
          )
      ),
    );
  }
}