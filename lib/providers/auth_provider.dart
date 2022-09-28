import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopy/models/custom_exception.dart';
import 'package:shopy/utils/errors.dart';

class AuthProvider extends ChangeNotifier {
  String? _uid;
  String? _token;
  DateTime? _expiryDate;
  Timer? _authTimer;

  final _signupUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyByjF8CgxAFzj-dfq_ythzvP5jxLPr_PDs';
  final _loginUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyByjF8CgxAFzj-dfq_ythzvP5jxLPr_PDs';

  String? get token => _token;

  bool get isAuth {
    return (_token != null &&
        expiryDate != null &&
        expiryDate!.isAfter(
          DateTime.now(),
        ));
  }

  String? get uid => _uid;

  DateTime? get expiryDate => _expiryDate;

  Future<void> signup(Map userData) async {
    try {
      final response = await http.post(
        Uri.parse(_signupUrl),
        body: json.encode({
          'email': userData['email'],
          'password': userData['password'],
          'returnSecureToken': true,
        }),
      );
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw CustomException(message: data['error']['message']);
      } else {
        _uid = data['localId'];
        _token = data['idToken'];
        _expiryDate = DateTime.now().add(
          Duration(seconds: int.parse(data['expiresIn'])),
        );
        _autoLogOut();
        notifyListeners();
        final sharedPrefs = await SharedPreferences.getInstance();
        final userPrefs = json.encode({
          'token': _token,
          'uid': _uid,
          'expiryDate': _expiryDate!.toIso8601String(),
        });
        sharedPrefs.setString('userData', userPrefs);
      }
    } catch (error) {
      throw CustomException(message: authError(error.toString()));
    }
  }

  Future<void> login(Map userData) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        body: json.encode({
          'email': userData['email'],
          'password': userData['password'],
          'returnSecureToken': true,
        }),
      );
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw CustomException(message: data['error']['message']);
      } else {
        _uid = data['localId'];
        _token = data['idToken'];
        _expiryDate = DateTime.now().add(
          Duration(seconds: int.parse(data['expiresIn'])),
        );
        _autoLogOut();
        notifyListeners();
        final sharedPrefs = await SharedPreferences.getInstance();
        final userPrefs = json.encode({
          'token': _token,
          'uid': _uid,
          'expiryDate': _expiryDate!.toIso8601String(),
        });
        sharedPrefs.setString('userData', userPrefs);
      }
    } catch (error) {
      throw CustomException(message: authError(error.toString()));
    }
  }

  Future<void> logOut() async {
    _token = null;
    _uid = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final expiryTime = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryTime), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    if (!sharedPrefs.containsKey('userData')) {
      return false;
    }

    final userData = sharedPrefs.getString('userData');
    if (userData == null) {
      return false;
    }

    final decodedData = json.decode(userData);
    if (DateTime.parse(decodedData['expiryDate']).isBefore(DateTime.now())) {
      return false;
    }
    _token = decodedData['token'];
    _expiryDate = DateTime.parse(decodedData['expiryDate']);
    _uid = decodedData['uid'];
    _autoLogOut();
    notifyListeners();

    return true;
  }
}
