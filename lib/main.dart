import 'dart:convert';

import 'package:apilab/bloc/authentication_bloc.dart';
import 'package:apilab/bloc/base_provider.dart';
import 'package:apilab/home.dart';
import 'package:apilab/login.dart';
import 'package:apilab/splash.dart';
import 'package:apilab/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
        builder: (context, bloc) => bloc ?? AuthenticationBloc(),
        child:MaterialApp(
          title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainScreen(),
      ),
      );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthenticationBloc _authenticationBloc;
  @override
  Widget build(BuildContext context) {
    _authenticationBloc = Provider.of(context);
    return StreamBuilder<bool>(
      stream: _authenticationBloc.isAuthenticated,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return SplashScreen();
        if (snapshot.data)return HomeScreen();
        return LoginScreen();
      },  
    );
  }
}
