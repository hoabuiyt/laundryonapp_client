import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundryonapp/Models/authData.dart';
import 'package:laundryonapp/Models/authResponse.dart';
import 'package:laundryonapp/Models/address.dart';

import 'package:laundryonapp/Provider/authData_provider.dart';

Future<AddressInfo?> createAddress(
    AddressInfo addressInfo, String token) async {
  const url = 'http://68.183.204.241/customer/address/';

  Map<String, dynamic> addressInfoMap = {
    'full_address': addressInfo.fullAddress,
    'landmark': addressInfo.landmark,
    'buzzer_code': addressInfo.buzzerCode,
    'delivery_door': addressInfo.deliveryDoor,
    'latitude': addressInfo.latitude,
    'longitude': addressInfo.longitude,
    'address_type': addressInfo.addressType,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addressInfoMap),
    );
  } catch (e) {
    print("Error occured when creating the address");
  }
  return null;
}
