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

class LaundryOrderSummaryScreen extends ConsumerStatefulWidget {
  const LaundryOrderSummaryScreen({super.key});

  @override
  LaundryOrderSummaryScreenState createState() =>
      LaundryOrderSummaryScreenState();
}

class LaundryOrderSummaryScreenState
    extends ConsumerState<LaundryOrderSummaryScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> buildLaundryFeaturesWidgets(LaundrySettings allLaundrySettings) {
    List<Widget> featureWidgets = [];
    Map<String, Map<String, String>> featureToSvgAndLabel = {
      'scented': {
        'asset': 'assets/scented.svg',
        'label': 'Scented',
      },
      'delicatesSeparate': {
        'asset': 'assets/separate.svg',
        'label': 'Delicates Separate',
      },
      'unscented': {
        'asset': 'assets/unscented.svg',
        'label': 'Unscented',
      },
      'hangerService': {
        'asset': 'assets/hanger.svg',
        'label': 'Hanger Service',
      },
      'warmWater': {
        'asset': 'assets/warm_water.svg',
        'label': 'Warm Water',
      },
      'ownProducts': {
        'asset': 'assets/own_product.svg',
        'label': 'Own Products',
      },
    };
    if (allLaundrySettings.unscented) {
      featureWidgets.add(
        buildFeatureWidget(
          featureToSvgAndLabel['scented']!['asset']!,
          featureToSvgAndLabel['scented']!['label']!,
        ),
      );
    }
    if (allLaundrySettings.delicatesSeparate) {
      featureWidgets.add(
        buildFeatureWidget(
          featureToSvgAndLabel['delicatesSeparate']!['asset']!,
          featureToSvgAndLabel['delicatesSeparate']!['label']!,
        ),
      );
    }
    if (allLaundrySettings.hypoallergenicUnscented) {
      featureWidgets.add(
        buildFeatureWidget(
          featureToSvgAndLabel['unscented']!['asset']!,
          featureToSvgAndLabel['unscented']!['label']!,
        ),
      );
    }
    if (allLaundrySettings.hangarService) {
      featureWidgets.add(
        buildFeatureWidget(
          featureToSvgAndLabel['hangerService']!['asset']!,
          featureToSvgAndLabel['hangerService']!['label']!,
        ),
      );
    }
    if (allLaundrySettings.warmWater) {
      featureWidgets.add(
        buildFeatureWidget(
          featureToSvgAndLabel['warmWater']!['asset']!,
          featureToSvgAndLabel['warmWater']!['label']!,
        ),
      );
    }
    if (allLaundrySettings.ownProducts) {
      featureWidgets.add(
        buildFeatureWidget(
          featureToSvgAndLabel['ownProducts']!['asset']!,
          featureToSvgAndLabel['ownProducts']!['label']!,
        ),
      );
    }

    return featureWidgets;
  }

  Widget buildFeatureWidget(String svgAsset, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x33D7F0FF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF4C95EF),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgAsset,
            color: const Color(0xFF4C95EF),
            height: 20,
          ),
          const SizedBox(height: 20),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF4C95EF),
            ),
          ),
        ],
      ),
    );
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
    print(defaultAddressId);

    final LaundryOrderPayload laundryOrderPayload =
        ref.read(laundryOrderPayloadProvider);

    final List<GarmentType> finalSelectedGarments =
        laundryOrderPayload.selectedGarments;

    final LaundrySettings allLaundrySettings =
        laundryOrderPayload.laundrySettingsData;

    final PickupDropOffTime pickupDropOffTime =
        laundryOrderPayload.pickupDropOffTime;

    final additionalSettings = allLaundrySettings.hangarService;
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
                              onPressed: () => Navigator.pop(context),
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
                                  'Laundry only',
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
                        const Gap(15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.08),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                  'Details',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Weight of the load',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: const Color(0xFF1C2649),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4C95EF),
                                            border: Border.all(
                                                color: const Color(0xFF4C95EF),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Text(
                                            allLaundrySettings.weightOfLoad
                                                .toInt()
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(20),
                                    const Divider(
                                      color: Color(0xFFBCBCBC),
                                    ),
                                    const Gap(20),
                                    Row(
                                      children: [
                                        Text(
                                          'Additional Requests',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: const Color(0xFF1C2649),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(10),
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final allLaundrySettings = ref
                                            .watch(laundryOrderPayloadProvider);
                                        final List<Widget> featureWidgets =
                                            buildLaundryFeaturesWidgets(
                                                allLaundrySettings
                                                    .laundrySettingsData);

                                        double screenWidth =
                                            MediaQuery.of(context).size.width;
                                        double spacing = 10.0;
                                        double containerWidth =
                                            (screenWidth - 86) / 2;

                                        return Wrap(
                                          spacing: spacing,
                                          runSpacing: spacing,
                                          children:
                                              featureWidgets.map((widget) {
                                            return Container(
                                              width: containerWidth,
                                              child: widget,
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),
                                    const Gap(20),
                                    const Divider(
                                      color: Color(0xFFBCBCBC),
                                    ),
                                    const Gap(20),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Special Instructions',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: const Color(0xFF1C2649),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(17),
                                    Text(
                                      allLaundrySettings.specialInstructions!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: const Color.fromARGB(
                                            255, 153, 153, 153),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const Divider(
                                      color: Color(0xFFBCBCBC),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.08),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                  'Pick Up & Drop Off',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Pick Up Date',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: const Color(0xFF1C2649),
                                        ),
                                      ),
                                      const Gap(17),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0x33D7F0FF),
                                              border: Border.all(
                                                color: const Color(0xFF4C95EF),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              DateFormat('MMM dd, EEEE').format(
                                                  laundryOrderPayload
                                                      .pickupDropOffTime
                                                      .pickUpDate!),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: const Color(0xFF4C95EF),
                                              ),
                                            ),
                                          ),
                                          const Gap(28),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0x33D7F0FF),
                                              border: Border.all(
                                                color: const Color(0xFF4C95EF),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              MaterialLocalizations.of(context)
                                                  .formatTimeOfDay(
                                                      laundryOrderPayload
                                                          .pickupDropOffTime
                                                          .pickUpTime!,
                                                      alwaysUse24HourFormat:
                                                          false),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: const Color(0xFF4C95EF),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(20),
                                      const Divider(
                                        color: Color(0xFFBCBCBC),
                                      ),
                                      const Gap(20),
                                      Text(
                                        'Drop off Date',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: const Color(0xFF1C2649),
                                        ),
                                      ),
                                      const Gap(17),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0x33D7F0FF),
                                              border: Border.all(
                                                color: const Color(0xFF4C95EF),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              DateFormat('MMM dd, EEEE').format(
                                                  laundryOrderPayload
                                                      .pickupDropOffTime
                                                      .dropOffDate!),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: const Color(0xFF4C95EF),
                                              ),
                                            ),
                                          ),
                                          const Gap(28),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0x33D7F0FF),
                                              border: Border.all(
                                                color: const Color(0xFF4C95EF),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              MaterialLocalizations.of(context)
                                                  .formatTimeOfDay(
                                                      laundryOrderPayload
                                                          .pickupDropOffTime
                                                          .dropOffTime!,
                                                      alwaysUse24HourFormat:
                                                          false),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: const Color(0xFF4C95EF),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
                  if (defaultAddressId != null) {
                    print(defaultAddressId);
                    postLaundryOrder(defaultAddressId, ref).then((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderTrackingScreen()),
                      );
                    }).catchError((error) {
                      print(error);
                    });
                  } else {
                    print("defaultAddressId is null");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Address is not set. Please set it and try again.')),
                    );
                  }
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
