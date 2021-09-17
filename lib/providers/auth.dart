// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;
  late Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBLv8hPBafuF_LbW0VqhihOXkD9_cJnp58');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      // _autoLogout();
      notifyListeners();

      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      print(responseData);
    } catch (error) {
      print('ERROR - $error');
      rethrow;
    }
  }

  Future<void> _forgotpassword(
      String email, String requestType, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBLv8hPBafuF_LbW0VqhihOXkD9_cJnp58');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'requestType': requestType,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      // _autoLogout();
      notifyListeners();

      print('Password Reset - $responseData');
    } catch (error) {
      print('ERROR - $error');
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> forgotPass(String email, String requestType) async {
    return _forgotpassword(email, requestType, 'sendOobCode');
  }
}
