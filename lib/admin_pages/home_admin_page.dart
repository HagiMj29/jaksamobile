import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_services.dart';

Future<String?> getUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name');
}

Future<String?> getUserEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_email');
}

class HomeAdminPage extends StatefulWidget {
  final int userId;
  final ApiServices apiService;
  const HomeAdminPage({Key? key, required this.userId, required this.apiService}) : super(key: key);

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
          Text("Admin Page")
      ),
    );
  }
}
