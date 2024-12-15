import 'package:shared_preferences/shared_preferences.dart'; // Import package

class ActiveUser {
  static final ActiveUser _instance = ActiveUser._internal();

  factory ActiveUser() {
    return _instance;
  }

  ActiveUser._internal();

  Future<void> setActiveUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('activeUserId', userId);
  }


  Future<String?> getActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('activeUserId');
  }

  Future<void> clearActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('activeUserId');
  }
}