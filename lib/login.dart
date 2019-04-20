import 'dart:convert';
import 'dart:io';

import 'package:apilab/bloc/authentication_bloc.dart';
import 'package:apilab/bloc/base_provider.dart';
import 'package:apilab/home.dart';
import 'package:apilab/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthenticationBloc _authenticationBloc;
  String username = "";
  String password = "";
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _authenticationBloc =_authenticationBloc ?? Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: StreamBuilder<LoginState>(
          stream: _authenticationBloc.loginState,
          builder: (context, snapshot) {
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(snapshot.hasError ? snapshot.error : "", style: TextStyle(color: Colors.red),),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Username"),
                    validator: (value) {
                      if (value.isEmpty) return "Username cannot be empty";
                      return null;
                    },
                    onSaved: (value) {
                      username = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Password"),
                    validator: (value) {
                      if (value.isEmpty) return "Password cannot be empty";
                      return null;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  snapshot.data == LoginState.LOADING
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: this._onLoginCLicked,
                          child: Text("Login"),
                        )
                ],
              ),
            );
          }),
    );
  }

  _onLoginCLicked() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    _authenticationBloc.loginUser(username, password);
  }
}
