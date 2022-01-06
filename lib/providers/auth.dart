import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _timer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if(_token != null && _expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> signupUser(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signInUser(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> _authenticate(String email,String password, String type) async {
    try {
      final url = Uri.parse(
          "https://identitytoolkit.googleapis.com/v1/accounts:$type?key=AIzaSyB4mzsv-S2UsGiuJMUAW58KQinH0x1Xa5I");
      final response = await post(
        url, /*headers: "Content-Type: application/json"*/body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true
          }),);
      final data = json.decode(response.body);
      if(data != null) {
        if (data["error"] != null) {
          throw HttpException(data["error"]["message"]);
        }
        _token = data["idToken"];
        _userId = data["localId"];
        _expiryDate = DateTime.now().add(Duration(seconds: int.parse(data["expiresIn"])));
        autoLogOut();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          "token":_token,
          "userId":_userId,
          "expiryDate":_expiryDate!.toIso8601String(),
        });
        prefs.setString("userDate", userData);
      }
    }catch(error) {
      throw error;
    }
  }

  void logOut() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    notifyListeners();
    SharedPreferences.getInstance().then((value) {
      value.remove("userData");
    });
  }

  void autoLogOut() {
    if(_timer != null) {
      _timer!.cancel();
    }
    final secondsRemaining = _expiryDate!.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: secondsRemaining), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("userData")) {
      return false;
    }
    final data = json.decode(prefs.getString("userData")!) as Map<String, String>;
    final expiryDate = DateTime.parse(data["expiryDate"]!);
    if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = data["token"];
    _userId = data["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogOut();
    return true;
  }
}
