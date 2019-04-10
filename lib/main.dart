import 'dart:convert';

import 'package:apilab/home.dart';
import 'package:apilab/login.dart';
import 'package:apilab/splash.dart';
import 'package:apilab/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<User>(
        future: getLoginUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasError) return LoginScreen();
          if (snapshot.hasData && snapshot.data != null)
            return HomeScreen(snapshot.data);
          if (!snapshot.hasData) return SplashScreen();
          return LoginScreen();
        },
      ),
    );
  }

  Future<User> getLoginUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String data = preferences.get('user-info');
    if (data == null) {
      throw 'User not found';
    }
    return User.fromJson(json.decode(data));
  }
}
