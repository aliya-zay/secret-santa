import 'dart:math';

import 'package:flutter/material.dart';
import '../services/active_user.dart';
import '../services/participant_service.dart';
import 'room_page.dart'; // Import the room page


class CreateRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final roomCode = generateRoomCode(); // Generate the room code

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient( // Gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade50],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text( // Improved room code text
                  'Код комнаты:',
                   style: TextStyle(
                    fontSize: 24,
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
                  SizedBox(height: 10),
                 Text(
                   roomCode,
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
                SizedBox(height: 30),

                 _buildStyledButton(
                  context: context,
                  text: 'Перейти в комнату',
                  onPressed: () async {
                     ActiveUser activeUser = ActiveUser();
                     String? email = await activeUser.getActiveUser();
                     await ParticipantService().patchParticipant(email, 1, roomCode, null, null);

                     Navigator.pushReplacementNamed(context, '/room', arguments: roomCode);
                   },
                  color: Colors.orange.shade800,
                  textColor: Colors.white,
                   width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton({
    required BuildContext context,
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

  String generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        5, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}