import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryonapp/Models/address.dart';

class AddressInfoStateNotifier extends StateNotifier<AddressInfo> {
  AddressInfoStateNotifier() : super(AddressInfo());

  void updateAddressInfo(AddressInfo newAddressInfo) {
    state = newAddressInfo;
  }
}

final addressInfoProvider =
    StateNotifierProvider<AddressInfoStateNotifier, AddressInfo>((ref) {
  return AddressInfoStateNotifier();
});
