import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:lottie/lottie.dart';

import 'package:laundryonapp/Provider/authData_provider.dart';
import 'package:laundryonapp/Provider/location_provider.dart';
import 'package:laundryonapp/Models/address.dart';
import 'package:laundryonapp/Models/slide.dart';

import 'package:laundryonapp/Screens/LaundryScreen.dart';
import 'package:laundryonapp/Screens/NewAddressScreen.dart';
import 'package:laundryonapp/Screens/AddressListScreen.dart';
import 'package:laundryonapp/Screens/ClothSelectionScreen_ironing.dart';
import 'package:laundryonapp/Provider/profile_provider.dart';
import 'package:laundryonapp/API_calls/profile.dart';
import 'package:laundryonapp/Provider/currentOrderProvider.dart';
import 'package:laundryonapp/API_calls/get_current_order.dart';
import 'package:laundryonapp/Screens/ordertracking.dart';
import 'package:laundryonapp/Screens/ClothSelectionScreen_dryCleaning.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = ref.read(authDataProvider).token;
      print(token);

      if (token.isNotEmpty) {
        await fetchAndSetProfile(token, ref);
        await getCurrentOrder(token, ref);
      } else {
        print("Token is not available.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    print('This is the current order ${currentOrder?.id}');
    final defaultAddressId = ref.read(profileProvider)?.defaultAddressId;
    print(defaultAddressId);
    final deviceWidth = MediaQuery.of(context).size.width;

    final AddressInfo addressInfo = ref.watch(addressInfoProvider);

    int _current = 0;

    void showCustomSnackBar(String message) {
      final snackBar = SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.deepPurple,
        action: SnackBarAction(
          label: 'CLOSE',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

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
                      vertical: 8.25, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      SvgPicture.asset('assets/logo_wordmark.svg'),
                      SvgPicture.asset('assets/hamburger.svg'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Gap(20),
                TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.all(0),
                      splashFactory: NoSplash.splashFactory),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddressScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFE7E7E7),
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/location.svg'),
                        const Gap(33),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Home',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1C2649),
                                ),
                              ),
                              Text(
                                addressInfo.fullAddress ??
                                    'Please select an address',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF1C2649),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Services',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C2649),
                    ),
                  ),
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(0),
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        if (addressInfo.fullAddress?.isEmpty ?? true) {
                          showCustomSnackBar('Please select an address first');
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Laundry(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7B1F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 17, 22, 13),
                          child: Center(
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/laundry.svg'),
                                const Gap(12),
                                Text(
                                  'Laundry',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(0),
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        if (addressInfo.fullAddress?.isEmpty ?? true) {
                          showCustomSnackBar('Please select an address first');
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ClothScreenIroning(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD49F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 17, 22, 13),
                          child: Center(
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/iron.svg'),
                                const Gap(12),
                                Text(
                                  'Only Iron',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(0),
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        if (addressInfo.fullAddress?.isEmpty ?? true) {
                          showCustomSnackBar('Please select an address first');
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ClothScreenDryCleaning(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 17, 22, 13),
                          child: Center(
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/dry_cleaning.svg'),
                                const Gap(12),
                                Text(
                                  'Dry Clean',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(25),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Check these out!',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C2649),
                    ),
                  ),
                ),
                const Gap(8),
                FlutterCarousel(
                  items: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/10_off.svg',
                        width: double.infinity,
                      ),
                    ),
                    Center(
                      child: SvgPicture.asset(
                        'assets/10_off.svg',
                        width: double.infinity,
                      ),
                    ),
                    Center(
                      child: SvgPicture.asset(
                        'assets/10_off.svg',
                        width: double.infinity,
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                      autoPlay: false,
                      viewportFraction: 1.0,
                      showIndicator: false,
                      height: 185.0,
                      onPageChanged:
                          (int index, CarouselPageChangedReason reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: slides.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4),
                      ),
                    );
                  }).toList(),
                ),
                const Gap(25),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Refer your friend',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C2649),
                    ),
                  ),
                ),
                const Gap(15),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(0),
                      splashFactory: NoSplash.splashFactory),
                  child: SvgPicture.asset('assets/refer.svg'),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          if (currentOrder != null)
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(right: 20),
                width: deviceWidth,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 138, 138, 138),
                      blurRadius: 12.0,
                      spreadRadius: 1.0,
                      offset: Offset(0.0, 2.0),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  border: Border(
                    top: BorderSide(color: Color(0xFF723CE8), width: 3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Lottie.asset(
                            'assets/searching_radar.json',
                            width: 60,
                            height: 60,
                          ),
                          const Text('Looking for a Laundromat')
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const OrderTrackingScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF723CE8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'TRACK',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
