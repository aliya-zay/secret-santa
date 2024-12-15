import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/participant.dart';

class ParticipantService {
  final String apiUrl = 'http://91.201.53.157:5001/participants'; // Замените на ваш URL
  final String apiUrlPatch = 'http://91.201.53.157:5001/participants-oof';
  final String apiUrlCheck = 'http://91.201.53.157:5001/participants-check';

  Future<List<Participant>> fetchParticipants() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Participant.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load participants: ${response.statusCode}');
    }
  }

  Future<void> addParticipant(Participant participant) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(participant.toMap()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add participant: ${response.statusCode}');
    }
  }

  Future<void> patchParticipant(email, is_admin, room, deliveryAddress, giftPreference) async {
    final response = await http.post(
      Uri.parse(apiUrlPatch),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'is_admin': is_admin,
        'room': room,
        'deliveryAddress': deliveryAddress,
        'giftPreference': giftPreference
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to patch participant: ${response.statusCode}');
    }
  }

  Future<bool> checkParticipant(email, password) async {
    final response = await http.post(
      Uri.parse(apiUrlPatch),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 401) {
      return false;
    } else {
      return true;
    }
  }
}