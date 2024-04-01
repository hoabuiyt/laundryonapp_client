import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../Models/OrderModel/currentOrder.dart';
import '../Provider/currentOrderProvider.dart';

Future<void> getCurrentOrder(String bearerToken, WidgetRef ref) async {
  var url = Uri.parse(
      'http://68.183.204.241/customer/order/?order_status=order_created');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $bearerToken',
  };

  try {
    print('getCurrentOrderAPI runs');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var currentOrder = CurrentOrder.fromJson(jsonResponse.last);
      print('tried to get current order');
      ref.read(currentOrderProvider.notifier).setCurrentOrder(currentOrder);
    } else {
      print(
          'GetCurrentOrder Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
