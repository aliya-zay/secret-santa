import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
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
  List<Map<String, dynamic>>? _roomData;
  String? _errorMessage;
  Map<String, String>? _assignments;
  bool _drawComplete = false;


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
    final url = Uri.parse('http://91.201.53.157:5001/room?room=${widget.roomCode}'); // Replace with your API endpoint

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

  Future<void> _performDraw() async {
    if (_roomData == null || _roomData!.length < 3) {
      setState(() {
        _errorMessage = 'Необходимо как минимум 3 участника для розыгрыша.';
      });
      return;
    }

    final participants = _roomData!
        .where((p) => p['is_admin'] != 1)
        .map((p) => p['email'])
        .toList();
    final admin = _roomData!.firstWhere((p) => p['is_admin'] == 1, orElse: () => {});


    if (participants.isEmpty) {
      setState(() {
        _errorMessage = 'No participants to perform the draw.';
      });
      return;
    }

    participants.shuffle(Random());

    Map<String, String> assignments = {};
    for (int i = 0; i < participants.length; i++) {
      assignments[participants[i]] = participants[(i + 1) % participants.length];
    }

    setState(() {
      _assignments = assignments;
      _drawComplete = true;
      _errorMessage = null;
    });
  }

  Widget _buildAssignments() {
    final myEmail = _activeUser;
    final isAdmin = _roomData?.firstWhere((p) => p['email'] == myEmail, orElse: () => {})['is_admin'] == 1 ? true : false;

    if (isAdmin) {
      return _buildAdminAssignmentsView();
    } else {
      final assignedTo = _assignments?[myEmail];
      if (assignedTo == null) return Container();
      return _buildParticipantDetails(assignedTo);
    }
  }

  Widget _buildAdminAssignmentsView() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
            Text('Результаты розыгрыша:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          for (final entry in _assignments!.entries)
            ListTile(
              title: Text('${entry.key} -> ${entry.value}', style: TextStyle(color: Colors.black)),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantDetails(String email) {
    final participant = _roomData?.firstWhere((p) => p['email'] == email, orElse: () => {});

    if (participant == {}) return Container();


    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ваш подопечный:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ListTile(
            title: Text(participant?['name'] ?? '', style: TextStyle(color: Colors.black)),
            subtitle: Text(participant?['email'] ?? '', style: TextStyle(color: Colors.black)),
          ),
            ListTile(
              title: Text('Пожелания к подарку:', style: TextStyle(color: Colors.black)),
              subtitle: Text(participant?['giftPreference'] ?? 'Не указано', style: TextStyle(color: Colors.black)),
          ),
            ListTile(
              title: Text('Адрес доставки:', style: TextStyle(color: Colors.black)),
              subtitle: Text(participant?['deliveryAddress'] ?? 'Не указано', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Комната: ${widget.roomCode}'),
          backgroundColor: Colors.blue, // Set a background color
        foregroundColor: Colors.white,  //  Text color
      ),
      body: Container(
         decoration: BoxDecoration(
           gradient: LinearGradient(
               begin: Alignment.topCenter,
               end: Alignment.bottomCenter,
               colors: [Colors.blue.shade200, Colors.blue.shade50]
           ),
         ),
         child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red))) // Use red for errors
              : _roomData != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Активный пользователь: $_activeUser', style: TextStyle(fontSize: 18, color: Colors.white)),
                            SizedBox(height: 10),
                           ..._getAdminAndParticipants(),
                            SizedBox(height: 20),
                             _buildStyledButton(
                              text: 'Розыгрыш',
                              onPressed: _drawComplete ? () async {} : () async {
                                await _performDraw();
                              },
                              color: Colors.blue.shade800,
                              textColor: Colors.white,
                              width: 200,
                           ),
                          SizedBox(height: 20),
                            _drawComplete ? _buildAssignments() : Container(),
                         ],
                       ),
                      ),
                  )
                : Center(child: Text('Room data not available')),
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
              ),
            )
        )
    );
  }
  
  List<Widget> _getAdminAndParticipants() {
    final List<Map<String, dynamic>> participantsData = _roomData!;
    final admin = participantsData.firstWhere(
      (p) => p['is_admin'] == 1,
      orElse: () => {'name': '', 'email': ''},
    );
    final participants = participantsData.where((p) => p['is_admin'] != true).toList();

    List<Widget> widgets = [];
     if (admin.isNotEmpty) {
          widgets.add(
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
             child: ListTile(
                leading: Icon(Icons.admin_panel_settings, color: Colors.black),
                 title: Text('${admin['name']} (Администратор)', style: TextStyle(color: Colors.black)),
                subtitle: Text('${admin['email']}', style: TextStyle(color: Colors.black)),
             ),
           )
          );
    }

      for (final participant in participants) {
       widgets.add(
         Container(
          margin: EdgeInsets.only(bottom: 10.0),
           padding: EdgeInsets.all(10),
           decoration: BoxDecoration(
             color: Colors.white.withOpacity(0.9),
             borderRadius: BorderRadius.circular(10),
           ),
        child: ListTile(
          title: Text(participant['name'] ?? '', style: TextStyle(color: Colors.black)),
          subtitle: Text(participant['email'] ?? '', style: TextStyle(color: Colors.black)),
         ),
       )
       );
    }

    return widgets;
  }
}