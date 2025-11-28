import 'package:flutter/material.dart';

class UserAccount {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String securityPin;
  final String accountNumber;
  final DateTime createdAt;

  const UserAccount({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.securityPin,
    required this.accountNumber,
    required this.createdAt,
  });

  String get maskedAccountId =>
      '*****${accountNumber.substring(accountNumber.length - 4)}';
}

class AuthController extends ChangeNotifier {
  UserAccount? _user;
  bool _hasCompletedOnboarding = false;
  final List<UserAccount> _registeredUsers = [];

  UserAccount? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  void completeOnboarding() {
    if (_hasCompletedOnboarding) return;
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  bool login({
    required String email,
    required String securityPin,
  }) {
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPin = securityPin.trim();

    try {
      final foundUser = _registeredUsers.firstWhere(
        (user) =>
            user.email.toLowerCase() == trimmedEmail &&
            user.securityPin == trimmedPin,
      );

      _user = foundUser;
      notifyListeners();
      return true;
    } catch (e) {
      throw StateError('Email atau PIN salah');
    }
  }

  void signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String securityPin,
  }) {
    final trimmedEmail = email.trim().toLowerCase();
    
    // Check if email already exists
    if (_registeredUsers.any(
        (user) => user.email.toLowerCase() == trimmedEmail)) {
      throw StateError('Email sudah terdaftar');
    }

    final newUser = UserAccount(
      fullName: fullName.trim(),
      email: email.trim(),
      phoneNumber: phoneNumber.trim(),
      securityPin: securityPin.trim(),
      accountNumber: _generateAccountNumber(),
      createdAt: DateTime.now(),
    );

    _registeredUsers.add(newUser);
    _user = newUser;
    notifyListeners();
  }

  void updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
  }) {
    if (_user == null) return;

    final updatedUser = UserAccount(
      fullName: fullName ?? _user!.fullName,
      email: email ?? _user!.email,
      phoneNumber: phoneNumber ?? _user!.phoneNumber,
      securityPin: _user!.securityPin,
      accountNumber: _user!.accountNumber,
      createdAt: _user!.createdAt,
    );

    // Update di list registered users juga
    final index = _registeredUsers.indexWhere(
      (u) => u.email == _user!.email,
    );
    if (index != -1) {
      _registeredUsers[index] = updatedUser;
    }

    _user = updatedUser;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  String _generateAccountNumber() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final tail = (millis % 100000000).toString().padLeft(8, '0');
    return '8810$tail';
  }
}

class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope not found in widget tree');
    return scope!.notifier!;
  }
}

