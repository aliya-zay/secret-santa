import 'package:flutter/material.dart';
import '../services/active_user.dart';
import '../services/participant_service.dart';
import '../pages/room_page.dart';

class JoinRoomPage extends StatefulWidget {
  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final _roomCodeController = TextEditingController();
  final _giftPreferenceController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  String? _errorMessage;

  Future<void> _joinRoom() async {
    final roomCode = _roomCodeController.text;
    final giftPreference = _giftPreferenceController.text;
    final deliveryAddress = _deliveryAddressController.text;
    final activeUser = ActiveUser();
    final userId = await activeUser.getActiveUser();

    if (userId == null) {
      setState(() {
        _errorMessage = 'Вы не вошли в систему.';
      });
      return;
    }

    await ParticipantService().patchParticipant(userId, 0, roomCode, deliveryAddress, giftPreference);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomPage(roomCode: roomCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
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
                    'Присоединиться к комнате',
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
                      controller: _roomCodeController,
                    decoration: InputDecoration(
                      labelText: 'Код комнаты',
                      prefixIcon: Icon(Icons.vpn_key, color: Colors.deepPurple.shade800),
                       border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                         filled: true,
                        fillColor: Colors.white.withOpacity(0.8)
                     ),
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите код комнаты';
                      }
                      return null;
                    },
                  ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _giftPreferenceController,
                    decoration: InputDecoration(
                      labelText: 'Что вы хотите получить?',
                      prefixIcon: Icon(Icons.card_giftcard, color: Colors.deepPurple.shade800),
                       border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                         filled: true,
                        fillColor: Colors.white.withOpacity(0.8)
                     ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, укажите желаемый подарок';
                        }
                        return null;
                      },
                    ),
                   SizedBox(height: 16),
                    TextFormField(
                      controller: _deliveryAddressController,
                    decoration: InputDecoration(
                      labelText: 'Адрес доставки',
                      prefixIcon: Icon(Icons.location_on, color: Colors.deepPurple.shade800),
                       border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                         filled: true,
                        fillColor: Colors.white.withOpacity(0.8)
                     ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, укажите адрес доставки';
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
                    text: 'Присоединиться',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _joinRoom();
                      }
                    },
                     color: Colors.deepPurple.shade800,
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
    _roomCodeController.dispose();
    _giftPreferenceController.dispose();
    _deliveryAddressController.dispose();
    super.dispose();
  }
}