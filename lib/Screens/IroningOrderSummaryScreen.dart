import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:laundryonapp/API_calls/create_order.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:laundryonapp/Models/laundryOrderSettings.dart';
import 'package:laundryonapp/Provider/laundryOrder_provider.dart';
import 'package:laundryonapp/Models/pickupDropoffTime.dart';
import 'package:laundryonapp/Screens/LaundryScreen.dart';
import 'package:laundryonapp/Models/garmentType.dart';
import 'package:laundryonapp/Screens/OrderTracking.dart';
import 'package:laundryonapp/API_calls/create_order.dart';
import 'package:laundryonapp/Screens/DateTimeScreen.dart';
import 'package:laundryonapp/Provider/profile_provider.dart';

class IroningOrderSummaryScreen extends ConsumerStatefulWidget {
  const IroningOrderSummaryScreen({super.key});

  @override
  IroningOrderSummaryScreenState createState() =>
      IroningOrderSummaryScreenState();
}

class IroningOrderSummaryScreenState
    extends ConsumerState<IroningOrderSummaryScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> makePayment(BuildContext context, String clientSecret) async {
    try {
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'LaundryonApp',
        ),
      );
      await stripe.Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful')),
      );
    } catch (e) {
      if (e is stripe.StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment error: ${e.error.localizedMessage}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultAddressId = ref.read(profileProvider)?.defaultAddressId;

    final IroningOrderPayload laundryOrderPayload =
        ref.read(ironingOrderPayloadProvider);

    final List<GarmentType> finalSelectedGarments =
        laundryOrderPayload.selectedGarments;

    final PickupDropOffTime pickupDropOffTime =
        laundryOrderPayload.pickupDropOffTime;
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
                              onPressed: () {},
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
                          'Delivery',
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
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: -38,
              child: SvgPicture.asset('assets/Delivery_top_left_bubbles.svg'),
            ),
            Positioned(
              right: 0,
              bottom: 87,
              child:
                  SvgPicture.asset('assets/Delivery_bottom_right_bubbles.svg'),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  const Gap(33),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14.5),
                    decoration: const BoxDecoration(
                      color: Color(0xFFECF8FF),
                    ),
                    child: Center(
                      child: Text(
                        'You just saved 4 hours of your time!',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF1C2649),
                        ),
                      ),
                    ),
                  ),
                  const Gap(30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'In your cart',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1C2649),
                          ),
                        ),
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.08),
                                blurRadius: 20,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    color: Color(0xFF723CE8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 7),
                                child: Text(
                                  'Ironing',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              const Gap(11),
                              Container(
                                height: finalSelectedGarments.length * 85,
                                padding:
                                    const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                child: ListView.builder(
                                    itemBuilder: (context, i) => Card(
                                          color: Colors.white,
                                          elevation: 0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.08),
                                                  blurRadius: 20,
                                                )
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: SvgPicture.asset(
                                                  finalSelectedGarments[i]
                                                      .imagepath,
                                                ),
                                                title: Text(
                                                  finalSelectedGarments[i].name,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color:
                                                        const Color(0xFF1C2649),
                                                  ),
                                                ),
                                                trailing: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF4C95EF),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFF4C95EF),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: Text(
                                                    finalSelectedGarments[i]
                                                        .quantity
                                                        .toInt()
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    itemCount: finalSelectedGarments.length),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF4C95EF),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 14),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () {
                  postIroningOrder(defaultAddressId!, ref).then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderTrackingScreen()),
                    );
                  }).catchError((error) {
                    print(error);
                  });
                },
                child: Text(
                  'PLACE ORDER',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    height: 23 / 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
