import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryonapp/Models/pickupDropoffTime.dart';

import 'package:laundryonapp/Provider/authData_provider.dart';
import 'package:laundryonapp/Provider/laundryOrder_provider.dart';
import 'package:laundryonapp/Models/authData.dart';
import 'package:laundryonapp/Widgets/delivery_option_checkbox.dart';
import 'package:laundryonapp/Models/deliveryMethod.dart';
import 'package:laundryonapp/Screens/NewAddressScreen.dart';
import 'package:laundryonapp/Provider/addressList_provider.dart';
import 'package:laundryonapp/Models/address.dart';
import 'package:laundryonapp/API_calls/get_address_list.dart';
import 'package:laundryonapp/Provider/location_provider.dart';
import 'package:laundryonapp/Provider/profile_provider.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  AddressScreenState createState() => AddressScreenState();
}

class AddressScreenState extends ConsumerState<AddressScreen> {
  bool _hasFetchedAddresses = false;

  @override
  void initState() {
    super.initState();
    _fetchAddressesIfNeeded();
  }

  void _fetchAddressesIfNeeded() {
    final token = ref.read(authDataProvider).token;
    if (token.isNotEmpty && !_hasFetchedAddresses) {
      _hasFetchedAddresses = true;
      fetchAndStoreAddresses(ref, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressList = ref.watch(addressListProvider);
    final AddressInfo addressInfo = ref.watch(addressInfoProvider);
    final token = ref.read(authDataProvider).token;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(82),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 10.0,
                      spreadRadius: 0,
                      offset: Offset(
                        4.0,
                        2.0,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.25, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.all(0),
                                    splashFactory: NoSplash.splashFactory),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/Back-arrow.svg'),
                                    const Gap(8),
                                    Text(
                                      'Back',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xFF1C2649),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Text(
                            'Address',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1C2649),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: const Size(10, 10),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    splashFactory: NoSplash.splashFactory),
                                onPressed: () {},
                                child: SvgPicture.asset('assets/hamburger.svg'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Gap(10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewAddressScreen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.add, color: Color(0xFF723CE8)),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Add an Address',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF723CE8),
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                    const Gap(15),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: Color(0xFFBCBCBC),
                ),
              ),
              addressList.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          "NO SAVED ADDRESSES",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C2649),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(15),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "SAVED ADDRESSES",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1C2649),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: addressList.length,
                            itemBuilder: (_, index) {
                              final address = addressList[index];
                              return GestureDetector(
                                onTap: () async {
                                  final success = await setDefaultAddress(
                                      token, address.addressId!, ref);
                                  if (success) {
                                    ref
                                        .read(addressInfoProvider.notifier)
                                        .updateAddressInfo(address);
                                    ref
                                        .read(profileProvider.notifier)
                                        .updateDefaultAddressId(
                                            address.addressId!);
                                    print(address.addressId);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Column(
                                  children: [
                                    const Gap(20),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFF4C95EF),
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(address.fullAddress ??
                                            "No addresses Saved"),
                                        subtitle: Text(
                                          address.landmark ?? "",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: const Color(0xFF1C2649),
                                          ),
                                        ),
                                        trailing: const Icon(
                                            Icons.keyboard_arrow_right),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ));
  }
}
