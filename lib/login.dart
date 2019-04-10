import 'dart:convert';
import 'dart:io';

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
  String username = "";
  String password = "";
  GlobalKey<FormState> _formKey = GlobalKey();
  String message = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(message),
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
            RaisedButton(
              onPressed: this._onLoginCLicked,
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }

  _onLoginCLicked() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    Map<String, dynamic> body = {
      'username': username, //aryan
      'password': password // aryan123
    };
    try {
      Response response =
          await post("http://flutter.sochware.com/api/login", body: body);
      print(" status code = ${response.statusCode}");
      print(response.body);
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (response.statusCode != 200) {
        setState(() {
          message = jsonData['message'];
        });
      } else {
        User user = User.fromJson(jsonData['payload'][0]);
        SharedPreferences preference = await SharedPreferences.getInstance();
        preference.setString("user-info", jsonEncode(user.toJson()));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(user)));
      }
    } catch (error) {
      print(error);
      if (error is SocketException) {
        setState(() {
          message = "Internet not available";
        });
        return;
      }
      setState(() {
        message = "Oops something went wrong";
      });
    }
  }
}
