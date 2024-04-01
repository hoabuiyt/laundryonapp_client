import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryonapp/Models/authResponse.dart';

class AuthNotifier extends StateNotifier<AuthResponse?> {
  AuthNotifier() : super(null);

  void setAuthData(AuthResponse data) {
    state = data;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthResponse?>((ref) {
  return AuthNotifier();
});
