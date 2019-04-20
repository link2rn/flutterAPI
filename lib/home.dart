import 'package:apilab/bloc/authentication_bloc.dart';
import 'package:apilab/bloc/base_provider.dart';
import 'package:apilab/login.dart';
import 'package:apilab/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthenticationBloc _authenticationBloc; 
  @override
  Widget build(BuildContext context) {
    _authenticationBloc = _authenticationBloc ?? Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${_authenticationBloc.user.fullName}"),
        actions: <Widget>[
          InkWell(child: Center(child: Text("Logout")),
          onTap: _authenticationBloc.logout,)
        ],
      ),
    );
  }
}