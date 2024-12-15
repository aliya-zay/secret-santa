import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}




//Основная страница 
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Начни разыгрывать подарки!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20), // Отступ
            
            Text('Поторопись! \nКаждый игрок должен получить свой подарок.', style: TextStyle(fontSize: 14)),
            SizedBox(height: 20), // Отступ
            
            ElevatedButton(
              onPressed: () { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageRegistration()),
                );
              }, 
              child: Text('Начать игру'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}










//хранение списка участников
class ParticipantsProvider extends InheritedWidget {
  final List<String> participants;
  final Function(String) addParticipant;

  const ParticipantsProvider({
    Key? key,
    required Widget child,
    required this.participants,
    required this.addParticipant,
  }) : super(key: key, child: child);

  static ParticipantsProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ParticipantsProvider>();
    assert(provider != null, 'No ParticipantsProvider found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(ParticipantsProvider oldWidget) =>
      oldWidget.participants != participants;
}





//Страница регистрации
class PageRegistration extends StatefulWidget {
  @override
  _PageRegistrationState createState() => _PageRegistrationState();
}

class _PageRegistrationState extends State<PageRegistration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wishController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<String> _participants = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  void _addParticipant(String name) {
    setState(() {
      _participants.add(name);
    });
  }


  @override
  Widget build(BuildContext context) {
    


    return ParticipantsProvider(
      participants: _participants,
      addParticipant: _addParticipant,
        child: Scaffold(
          appBar: AppBar(title: const Text('Регистрация')),
          body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю
            children: [
              Text('Заполните форму регистрации:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text('Ваше имя:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Введите ваше имя'),
              ),

              SizedBox(height: 20),
              Text('Дата рождения:', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),


              SizedBox(height: 20),
              Text('Ваши предпочтения/интересы', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _wishController,
                decoration: InputDecoration(hintText: 'Введите, что бы вы хотели получить'),
              ),

              SizedBox(height: 20),
              Text('Место отправки подарка:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _placeController,
                decoration: InputDecoration(hintText: 'Введите место отправки подарка'),
              ),
            
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  String name = _nameController.text;
                  if (name.isNotEmpty) {
                    ParticipantsProvider.of(context).addParticipant(name); // Добавление участника через провайдер
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageParticipants(),
                      ),
                    );
                  } else {
                    // ... (отображение сообщения об ошибке) ...
                  }
                },
                child: const Text('Добавить участника'),
              ),
                  

            
            ],
        ),
      ),
    ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wishController.dispose();
    _placeController.dispose();
    super.dispose();
  }
}




//Страница участников
class PageParticipants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final participants = ParticipantsProvider.of(context).participants;
    return Scaffold(
      appBar: AppBar(title: const Text('Участники')),
      body: Column(
        children: [
          Expanded(
            child: participants.isEmpty
                ? const Center(child: Text('Список участников пуст.'))
                : ListView.builder(
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final participant = participants[index];
                      return ListTile(
                        title: Text(participant),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (participants.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PageRandom(participants: participants)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Список участников пуст!')),
                  );
                }
              },
              child: const Text('Разыграть'),
            ),
          ),
        ],
      ),
    );
  }
}

//Страница розыгрыша
class PageRandom extends StatelessWidget {
  final List<String> participants;

  const PageRandom({Key? key, required this.participants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (participants.length < 3) {
      _showErrorDialog(context, "Количество участников должно быть более 3", '/registration');
      return const SizedBox.shrink(); // Возвращаем пустой виджет, чтобы ничего не отображалось
    } else if (participants.length % 2 != 0) {
      _showErrorDialog(context, "Количество участников должно быть четным", '/registration');
      return const SizedBox.shrink(); // Возвращаем пустой виджет, чтобы ничего не отображалось
    } else {
      final results = assignMentees(participants);
      return Scaffold(
        appBar: AppBar(title: const Text('Результаты розыгрыша')),
        body: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${results.keys.elementAt(index)}: ${results.values.elementAt(index)}'),
            );
          },
        ),
      );
    }
  }

  Map<String, String> assignMentees(List<String> participants) {
    if (participants.isEmpty) return {}; //Обработка пустого списка

    final shuffledParticipants = List.from(participants)..shuffle();
    final results = <String, String>{};
    final usedMentees = <String>{};

    for (int i = 0; i < participants.length; i++) {
      String mentee;
      do {
        mentee = shuffledParticipants[i];
      } while (mentee == participants[i] || usedMentees.contains(mentee));
      results[participants[i]] = mentee;
      usedMentees.add(mentee);
    }
    return results;
  }

  Future<void> _showErrorDialog(BuildContext context, String message, String routeName) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, routeName);
                Navigator.of(context).pop(); // Закрываем диалоговое окно
              },
            ),
          ],
        );
      },
    );
  }
}




// Пользовательский AppBar с кнопками навигации
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text('Тайный Санта'),
    actions: [
      IconButton(
        icon: const Icon(Icons.home),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home'); // На главную страницу
        },
      ),
      IconButton(
        icon: const Icon(Icons.person_add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/registration'); // На регистрацию
        },
      ),
      IconButton(
        icon: const Icon(Icons.people),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/participants'); // К участникам
        },
      ),
      IconButton(
        icon: const Icon(Icons.poll),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/random'); // К результатам
        },
      ),
    ],
  );
}


class _MyAppState extends State<MyApp> {
  List<String> _participants = []; // Список участников

  void _addParticipant(String name) {
    setState(() {
      _participants.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ParticipantsProvider(
      participants: _participants,
      addParticipant: _addParticipant,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/home': (context) => const MyHomePage(title: 'Главная страница'),
          '/registration': (context) =>  PageRegistration(),
          '/participants': (context) =>  PageParticipants(),
          //'/random': (context) => const PageRandom(),
        },
        
        home: const MyHomePage(title: 'Тайный Санта'),
      ),
    );
  }
}