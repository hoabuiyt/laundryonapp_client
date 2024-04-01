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
import 'package:laundryonapp/Screens/DateTimeScreen.dart';
import 'package:laundryonapp/Screens/IroningOrderSummaryScreen.dart';
import 'package:laundryonapp/Screens/LaundryOrderSummaryScreen.dart';
import 'package:laundryonapp/Screens/DryCleaningOrderSummaryScreen.dart';

class DeliveryTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const DeliveryTypeScreen({super.key, required this.type});

  @override
  DeliveryTypeScreenState createState() => DeliveryTypeScreenState();
}

class DeliveryTypeScreenState extends ConsumerState<DeliveryTypeScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool sameDayDeliveryischecked = false;
  DeliveryMethod _selectedOption = DeliveryMethod.normalPickUpandDrop;

  onselected(option) {
    setState(() {
      if (_selectedOption == option) {
        return;
      } else {
        (_selectedOption = option);
      }
    });
  }

  updateLaundryPayloadDeliveryType() {
    DeliveryType updatedDeliveryType = DeliveryType(
        deliveryMethod: _selectedOption,
        sameDayDelivery: sameDayDeliveryischecked);

    ref
        .read(laundryOrderPayloadProvider.notifier)
        .updateDeliveryType(updatedDeliveryType);
  }

  @override
  Widget build(BuildContext context) {
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
                        'Select one of the following',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF1C2649),
                        ),
                      ),
                    ),
                  ),
                  const Gap(38),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        DeliveryCheckbox(
                            option: DeliveryMethod.normalPickUpandDrop,
                            selectedOption: _selectedOption,
                            onSelected: onselected,
                            imagePath: 'normal_delivery.svg',
                            text: 'Pick up & Drop off',
                            padding: const EdgeInsets.fromLTRB(36, 24, 60, 24),
                            gap: 45),
                        const Gap(20),
                        DeliveryCheckbox(
                            option: DeliveryMethod.leaveOutsideDoor,
                            selectedOption: _selectedOption,
                            onSelected: onselected,
                            imagePath: 'doorstep.svg',
                            text:
                                'Leave outside the door\nfor Pick up & Drop off',
                            padding: const EdgeInsets.fromLTRB(36, 24, 40, 24),
                            gap: 25),
                        const Gap(20),
                        DeliveryCheckbox(
                            option: DeliveryMethod.selfPickUpAndDrop,
                            selectedOption: _selectedOption,
                            onSelected: onselected,
                            imagePath: 'store_pickup.svg',
                            text: 'Self Drop off & Pickup',
                            padding: const EdgeInsets.fromLTRB(36, 29, 47, 29),
                            gap: 25),
                        const Gap(30),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: Checkbox(
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => const BorderSide(
                                      width: 1.0,
                                      color: Color(0xFF723CE8),
                                    ),
                                  ),
                                  splashRadius: 0,
                                  checkColor: const Color(0xFF723CE8),
                                  activeColor: Colors.white,
                                  value: sameDayDeliveryischecked,
                                  onChanged: (bool? value) {
                                    setState(
                                      () {
                                        sameDayDeliveryischecked = value!;
                                      },
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(12),
                            Text(
                              'Same day pick up & delivery',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                height: 1.5,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF1C2649),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(30),
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
                  if (widget.type == 'laundry') {
                    updateLaundryPayloadDeliveryType();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DateTimeScreen(),
                      ),
                    );
                  } else if (widget.type == 'ironing') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IroningOrderSummaryScreen(),
                      ),
                    );
                  } else if (widget.type == 'dryCleaning') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DryCleaningOrderSummaryScreen(),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DateTimeScreen(),
                      ),
                    );
                  }
                },
                child: Text(
                  'NEXT',
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
