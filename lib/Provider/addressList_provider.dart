import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryonapp/Models/address.dart';

class AddressListStateNotifier extends StateNotifier<List<AddressInfo>> {
  AddressListStateNotifier() : super([]);

  void saveAddressList(List<AddressInfo> addressList) {
    state = addressList;
  }
}

final addressListProvider =
    StateNotifierProvider<AddressListStateNotifier, List<AddressInfo>>((ref) {
  return AddressListStateNotifier();
});
