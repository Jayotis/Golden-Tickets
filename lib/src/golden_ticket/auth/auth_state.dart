import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../game_draw_data.dart';
import 'dart:convert';

class AuthState with ChangeNotifier {
  bool _signedIn = false;
  String _accountStatus = '';
  String _membershipLevel = '';
  String _userId = '';
  String _authToken = '';
  List<GameDrawData> _gameDrawData = [];

  static const String _prefsSignedInKey = 'signed_in';
  static const String _prefsAccountStatusKey = 'account_status';
  static const String _prefsMembershipLevelKey = 'membership_level';
  static const String _prefsUserIdKey = 'user_id';
  static const String _prefsAuthTokenKey = 'auth_token';
  static const String _prefsApiKeyKey = 'api_key';
  static const String _prefsGameDrawDataKey = 'game_draw_data';

  bool get signedIn => _signedIn;
  String get accountStatus => _accountStatus;
  String get membershipLevel => _membershipLevel;
  String get userId => _userId;
  String get authToken => _authToken;
  List<GameDrawData> get gameDrawData => _gameDrawData;
  bool get isSignedIn => _signedIn;

  void setSignInStatus({
    required bool signedIn,
    required String accountStatus,
    required String membershipLevel,
    required String userId,
    required String authToken,
    required List<GameDrawData> gameDrawData,
  }) {
    _signedIn = signedIn;
    _accountStatus = accountStatus;
    _membershipLevel = membershipLevel;
    _userId = userId;
    _authToken = authToken;
    _gameDrawData = gameDrawData;
    notifyListeners();
    _saveToSharedPreferences();
  }


  Future<void> _saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsSignedInKey, _signedIn);
    await prefs.setString(_prefsAccountStatusKey, _accountStatus);
    await prefs.setString(_prefsMembershipLevelKey, _membershipLevel);
    await prefs.setString(_prefsUserIdKey, _userId);
    await prefs.setString(_prefsAuthTokenKey, _authToken);
  
  }

  // Initialize from shared_preferences on startup
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _signedIn = prefs.getBool(_prefsSignedInKey) ?? false;
    _accountStatus = prefs.getString(_prefsAccountStatusKey) ?? '';
    _membershipLevel = prefs.getString(_prefsMembershipLevelKey) ?? '';
    _userId = prefs.getString(_prefsUserIdKey) ?? '';
    _authToken = prefs.getString(_prefsAuthTokenKey) ?? '';
    _gameDrawData = (prefs.getStringList(_prefsGameDrawDataKey) ?? [])
        .map((jsonString) => GameDrawData.fromJson(json.decode(jsonString)))
        .toList();

    notifyListeners();
  }


  Future<void> setApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsApiKeyKey, apiKey);
    notifyListeners();
  }

  void signOut() {
    _signedIn = false;
    _accountStatus = '';
    _membershipLevel = '';
    _userId = '';
    _authToken = '';
    _gameDrawData = [];

    notifyListeners();
  }

  Future<void> markEmailAsVerified() async {
    _accountStatus = 'active'; // Assuming 'active' means verified

    // Update shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsAccountStatusKey, _accountStatus);
    notifyListeners();
  }
}