class Participant {
  final String name;
  final String email;
  final String birthday;
  final String password; // In a real app, store a hash, not the plain password
  final int? is_admin;
  final String? room;
  final String? giftPreference;
  final String? deliveryAddress;

  Participant({
    required this.name,
    required this.email,
    required this.birthday,
    required this.password,
    this.is_admin,
    this.room,
    this.deliveryAddress,
    this.giftPreference
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'birthday': birthday,
        'password': password, // In a real app, hash this before sending,
        'is_admin': is_admin,
        'room': room
      };

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      name: json['name'],
      email: json['email'],
      birthday: json['birthday'],
      password: json['password'],
      is_admin:  json['is_admin'],
      room: json['room']
    );
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      name: map['name'] ?? '',
      birthday: map['birthday'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      is_admin: map['is_admin'] ?? '',
      room: map['room']
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'birthday': birthday,
        'email': email,
        'password': password,
        'is_admin': is_admin,
        'room': room
      };
}