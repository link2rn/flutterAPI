import 'dart:convert';

import 'package:apilab/user.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {

   Future<User> getLoginUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String data = preferences.get('user-info');
    if (data == null) {
      return null;
    }
    return User.fromJson(json.decode(data));
  }

  Future<User> loginUser(String username, String password) async {
     Map<String, dynamic> body = {
      'username': username, //aryan
      'password': password // aryan123
    };
     Response response =
          await post("http://flutter.sochware.com/api/login", body: body);
      print(" status code = ${response.statusCode}");
      print(response.body);
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw jsonData['message'];
      } else {
        return User.fromJson(jsonData['payload'][0]);
      }
  }
}