import 'package:apilab/login.dart';
import 'package:apilab/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.user.fullName}"),
        actions: <Widget>[
          InkWell(child: Center(child: Text("Logout")),
          onTap: this.logout,)
        ],
      ),
    );
  }

  logout()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('user-info');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }
}