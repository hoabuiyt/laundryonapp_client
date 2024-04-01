import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:laundryonapp/Models/authData.dart';
import 'package:laundryonapp/Models/authResponse.dart';

import 'package:laundryonapp/Provider/authData_provider.dart';

Future<AuthData?> authenticateUser(
    String email, String password, WidgetRef ref) async {
  const url = 'http://68.183.204.241/customer/login/';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final authData = AuthData.fromJson(jsonResponse);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', authData.token);

      print(response.body);
      return authData;
    } else {
      print('Failed to authenticate user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while authenticating: $e');
  }
  return null;
}

Future<bool> signUpUser(String firstName, String lastName, String email,
    String phoneNo, String password, WidgetRef ref) async {
  const signUpUrl = 'http://68.183.204.241/customer/register/';

  try {
    final signUpResponse = await http.post(
      Uri.parse(signUpUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_no': phoneNo,
        'password': password,
      }),
    );

    if (signUpResponse.statusCode == 200) {
      print(
          'User registered successfully. Response body: ${signUpResponse.body}');
      final authData = await authenticateUser(email, password, ref);
      return authData != null;
    } else {
      print(
          'Failed to register user. Status code: ${signUpResponse.statusCode}');
      print('Response body: ${signUpResponse.body}');
      return false;
    }
  } catch (e) {
    print('Error occurred while registering: $e');
    return false;
  }
}
