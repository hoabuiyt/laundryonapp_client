import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:laundryonapp/Screens/LaundryOrderSummaryScreen.dart';
import 'package:laundryonapp/Provider/authData_provider.dart';
import 'package:laundryonapp/Provider/laundryOrder_provider.dart';

Future<void> postLaundryOrder(int defaultAddressId, WidgetRef ref) async {
  var url = Uri.parse('http://68.183.204.241/order/');

  final laundryOrderNotifier = ref.read(laundryOrderPayloadProvider.notifier);

  final authData = ref.read(authDataProvider);

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': '${authData.tokenType} ${authData.token}',
  };
  String jsonPayload =
      laundryOrderNotifier.generatePayloadJson(defaultAddressId);
  try {
    var response = await http.post(url, headers: headers, body: jsonPayload);
    if (response.statusCode == 200) {
      print('Order posted successfully.');
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print(response.body);
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<void> postIroningOrder(int defaultAddressId, WidgetRef ref) async {
  var url = Uri.parse('http://68.183.204.241/order/');

  final ironingOrderNotifier = ref.read(ironingOrderPayloadProvider.notifier);

  final authData = ref.read(authDataProvider);

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': '${authData.tokenType} ${authData.token}',
  };
  String jsonPayload =
      ironingOrderNotifier.generatePayloadJson(defaultAddressId);
  try {
    var response = await http.post(url, headers: headers, body: jsonPayload);
    if (response.statusCode == 200) {
      print('Ironing order posted successfully.');
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<void> postDryCleaningOrder(int defaultAddressId, WidgetRef ref) async {
  var url = Uri.parse('http://68.183.204.241/order/');

  final ironingOrderNotifier =
      ref.read(dryCleaningOrderPayloadProvider.notifier);

  final authData = ref.read(authDataProvider);

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': '${authData.tokenType} ${authData.token}',
  };
  String jsonPayload =
      ironingOrderNotifier.generatePayloadJson(defaultAddressId);
  try {
    var response = await http.post(url, headers: headers, body: jsonPayload);
    if (response.statusCode == 200) {
      print('DryCleaning order posted successfully.');
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
