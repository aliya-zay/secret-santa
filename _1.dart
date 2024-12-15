import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

// Модель участника
class Participant {
  final String name;
  final String birthday;
  final String giftWish;
  final String address;

  Participant({
    required this.name,
    required this.birthday,
    required this.giftWish,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'birthday': birthday,
        'giftWish': giftWish,
        'address': address,
      };

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      name: map['name'] ?? '',
      birthday: map['birthday'] ?? '',
      giftWish: map['giftWish'] ?? '',
      address: map['address'] ?? '',
    );
  }
}

// Сервисный класс для работы с JSON-файлом на сервере
class ParticipantService {
  final String apiUrl = 'http://127.0.0.1:5000/participants'; // Замените на ваш URL

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
}


// Главная страница
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Начни разыгрывать подарки! Поторопись!',
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              'Каждый игрок должен получить свой подарок!',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: const Text('Начать игру'),
            ),
          ],
        ),
      ),
    );
  }
}




// Страница регистрации
class PageRegistrationUser extends StatefulWidget {
  const PageRegistrationUser({super.key});

  @override
  State<PageRegistrationUser> createState() => _PageRegistrationUserState();
}

class _PageRegistrationUserState extends State<PageRegistrationUser> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _giftWishController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final participant = Participant(
        name: _nameController.text,
        birthday: _birthdayController.text,
        giftWish: _giftWishController.text,
        address: _addressController.text,
      );
      try {
        await ParticipantService().addParticipant(participant);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Успех!'),
            content: const Text('Теперь вы в игре!'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
            ],
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (value) => value == null || value.isEmpty ? 'Введите имя' : null,
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: const InputDecoration(labelText: 'Дата рождения'),
                validator: (value) => value == null || value.isEmpty ? 'Введите дату рождения' : null,
              ),
              TextFormField(
                controller: _giftWishController,
                decoration: const InputDecoration(labelText: 'Пожелание по подарку'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Адрес для доставки'),
                maxLines: 3,
              ),
              ElevatedButton(onPressed: _submitForm, child: const Text('Добавить')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/participants');
                  },
                  child: const Text('Список участников')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _giftWishController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}




// Страница регистрации
class PageRegistration extends StatefulWidget {
  const PageRegistration({super.key});

  @override
  State<PageRegistration> createState() => _PageRegistrationState();
}

class _PageRegistrationState extends State<PageRegistration> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _giftWishController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final participant = Participant(
        name: _nameController.text,
        birthday: _birthdayController.text,
        giftWish: _giftWishController.text,
        address: _addressController.text,
      );
      try {
        await ParticipantService().addParticipant(participant);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Успех!'),
            content: const Text('Теперь вы в игре!'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
            ],
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (value) => value == null || value.isEmpty ? 'Введите имя' : null,
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: const InputDecoration(labelText: 'Дата рождения'),
                validator: (value) => value == null || value.isEmpty ? 'Введите дату рождения' : null,
              ),
              TextFormField(
                controller: _giftWishController,
                decoration: const InputDecoration(labelText: 'Пожелание по подарку'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Адрес для доставки'),
                maxLines: 3,
              ),
              ElevatedButton(onPressed: _submitForm, child: const Text('Добавить')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/participants');
                  },
                  child: const Text('Список участников')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _giftWishController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}


// Страница участников
class PageParticipants extends StatefulWidget {
  const PageParticipants({super.key});
  @override
  State<PageParticipants> createState() => _PageParticipantsState();
}
class _PageParticipantsState extends State<PageParticipants> {
  late Future<List<Participant>> _participantsFuture;

  @override
  void initState() {
    super.initState();
    _participantsFuture = ParticipantService().fetchParticipants();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<List<Participant>>(
        future: _participantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final participants = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(participants[index].name),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/random');
                  },
                  child: const Text('Посмотреть подопечного'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

// Страница результатов
class PageRandom extends StatelessWidget {
  const PageRandom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<List<Participant>>(
        future: ParticipantService().fetchParticipants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final participants = snapshot.data!;
            if(participants.isEmpty) return const Center(child: Text("Нет участников"));
            final shuffledParticipants = List.from(participants)..shuffle();
            final assignments = <Participant, Participant>{};
            final usedMentees = <Participant>{};

            for (int i = 0; i < participants.length; i++) {
              Participant mentee;
              do {
                mentee = shuffledParticipants[i];
              } while (mentee == participants[i] || usedMentees.contains(mentee));
              assignments[participants[i]] = mentee;
              usedMentees.add(mentee);
            }

            return ListView(
              children: assignments.entries.map((entry) {
                final giver = entry.key;
                final receiver = entry.value;
                return ListTile(
                  title: Text('${giver.name} дарит подарок ${receiver.name}'),
                  subtitle: Text('День рождения: ${receiver.birthday}, Пожелание: ${receiver.giftWish}, Адрес: ${receiver.address}'),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

// Верхнее меню
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text('Тайный Санта'),
    actions: [
      IconButton(
        icon: const Icon(Icons.home),
        onPressed: () => Navigator.pushNamed(context, '/home'),
      ),
      IconButton(
        icon: const Icon(Icons.person_add),
        onPressed: () => Navigator.pushNamed(context, '/registration'),
      ),
      IconButton(
        icon: const Icon(Icons.people),
        onPressed: () => Navigator.pushNamed(context, '/participants'),
      ),
      IconButton(
        icon: const Icon(Icons.poll),
        onPressed: () => Navigator.pushNamed(context, '/random'),
      ),
    ],
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Тайный Санта',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/registration': (context) => const PageRegistration(),
        '/participants': (context) => const PageParticipants(),
        '/random': (context) => const PageRandom(),
      },
      home: const MyHomePage(),
    );
  }
}






//запуск
void main() {
  runApp(MyApp());
}