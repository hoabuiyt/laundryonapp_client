import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundryonapp/Models/address.dart';
import 'package:laundryonapp/Provider/addressList_provider.dart';
import 'package:laundryonapp/Provider/profile_provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchAndStoreAddresses(WidgetRef ref, String token) async {
  try {
    final uri = Uri.parse('http://68.183.204.241/customer/address/');
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<AddressInfo> addressList = jsonResponse
          .map<AddressInfo>((json) => AddressInfo.fromJson(json))
          .toList();
      ref.read(addressListProvider.notifier).saveAddressList(addressList);
      print(response.body);
    } else {
      print('Failed to load addresses: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching addresses: $e');
  }
}

Future<bool> setDefaultAddress(String token, int addressId, ref) async {
  try {
    final uri = Uri.parse('http://68.183.204.241/customer/default-address');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'address_id': addressId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Default address set successfully');
      ref.read(profileProvider.notifier).updateDefaultAddressId(addressId);
      print('addressId: $addressId');
      print(ref.read(profileProvider)?.defaultAddressId);
      print('hello');
      print(ref.read(profileProvider.notifier).state?.defaultAddressId);
      return true;
    } else {
      print('Failed to set default address: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error setting default address: $e');
    return false;
  }
}

Future<bool> addAddress(
    ref,
    String token,
    String fullAddress,
    String landmark,
    String buzzerCode,
    String deliveryDoor,
    double latitude,
    double longitude,
    String addressType) async {
  try {
    final uri = Uri.parse('http://68.183.204.241/customer/address/');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'full_address': fullAddress,
        'landmark': landmark,
        'buzzer_code': buzzerCode,
        'delivery_door': deliveryDoor,
        'latitude': latitude,
        'longitude': longitude,
        'address_type': addressType,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Address added successfully');
      print(response.body);

      final responseBody = json.decode(response.body);
      final addressId = responseBody['id'];

      return await setDefaultAddress(token, addressId, ref);
    } else {
      print('Failed to add address: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error adding address: $e');
    return false;
  }
}
