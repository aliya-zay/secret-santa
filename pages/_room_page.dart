import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/active_user.dart';

class RoomPage extends StatefulWidget {
  final String roomCode;

  RoomPage({Key? key, required this.roomCode}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String? _activeUser;
  bool _isLoading = true;
  List<Map<String, dynamic>>? _roomData; // Changed to List<Map<String, dynamic>>
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getActiveUser();
    _fetchRoomData();
  }

  Future<void> _getActiveUser() async {
    final activeUser = ActiveUser();
    final userId = await activeUser.getActiveUser();
    setState(() {
      _activeUser = userId;
    });
  }

  Future<void> _fetchRoomData() async {
    final url = Uri.parse('http://127.0.0.1:5000/room?room=${widget.roomCode}'); // Replace with your API endpoint

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // Check if jsonData is a list before casting
        if (jsonData is List) {
          setState(() {
            _roomData = jsonData.cast<Map<String, dynamic>>();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Unexpected JSON response format.  Expected a list.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Error fetching room data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Комната: ${widget.roomCode}')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _roomData != null
                  ? Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Активный пользователь: $_activeUser', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          ..._getAdminAndParticipants(),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Add your "draw" logic here
                            },
                            child: Text('Розыгрыш'),
                          ),
                        ],
                      ),
                    )
                  : Center(child: Text('Room data not available')),
    );
  }

    List<Widget> _getAdminAndParticipants() {
    final List<Map<String, dynamic>> participantsData = _roomData!;
    final admin = participantsData.firstWhere(
      (p) => p['is_admin'] == 1,
      orElse: () => {'name': '', 'email': ''}, // Return an empty map
    );
    final participants = participantsData.where((p) => p['is_admin'] != 1).toList();

    List<Widget> widgets = [];
    if (admin != null) {
      widgets.add(ListTile(
        leading: Icon(Icons.admin_panel_settings),
        title: Text('${admin['name']} (Администратор)'),
        subtitle: Text('${admin['email']}'),
      ));
    }
    for (final participant in participants) {
      widgets.add(ListTile(
        title: Text(participant['name']),
        subtitle: Text('Участник'),
      ));
    }
    return widgets;
  }
}