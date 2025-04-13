import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  
  String? _currentUser;
  String? get currentUser => _currentUser;
  
  Future<bool> login(String email, String password) async {
    // In a real app, authenticate with backend
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful login
    _isLoggedIn = true;
    _currentUser = email;
    notifyListeners();
    return true;
  }
  
  Future<bool> loginAsGuest() async {
    // Skip authentication
    _isLoggedIn = true;
    _currentUser = 'Guest';
    notifyListeners();
    return true;
  }
  
  Future<bool> signup(String name, String email, String password) async {
    // In a real app, register with backend
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful signup and auto-login
    _isLoggedIn = true;
    _currentUser = email;
    notifyListeners();
    return true;
  }
  
  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
} 