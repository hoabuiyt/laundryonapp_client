import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryonapp/Models/profile.dart';
import 'package:laundryonapp/Provider/profile_provider.dart';

Future<void> fetchAndSetProfile(String token, WidgetRef ref) async {
  const url = 'http://68.183.204.241/customer/';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final profile = Profile.fromJson(data);
      ref.read(profileProvider.notifier).setProfile(profile);
    } else {
      print('Failed to fetch profile. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred while fetching profile: $e');
  }
}
