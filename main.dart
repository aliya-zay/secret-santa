import 'package:flutter/material.dart';
import 'pages/registration_page.dart';
import 'pages/main_page.dart';
import 'pages/create_room_page.dart';
import 'pages/room_page.dart';
import 'pages/join_room_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Тайный Санта',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => MainPage(),
        '/createRoom': (context) => CreateRoomPage(),
        '/room': (context) => RoomPage(roomCode: ''),
        '/joinRoom': (context) => JoinRoomPage(),
        '/registration': (context) => RegistrationPage(),
      },
    );
  }
}