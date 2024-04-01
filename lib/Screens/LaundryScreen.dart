import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:laundryonapp/Widgets/service_Appbar.dart';
import 'package:laundryonapp/Widgets/option_checkbox.dart';
import 'package:laundryonapp/Provider/laundryOrder_provider.dart';
import 'package:laundryonapp/Models/laundryOrderSettings.dart';
import 'package:laundryonapp/Screens/ClothSelectionScreen.dart';

class Laundry extends ConsumerStatefulWidget {
  const Laundry({super.key});

  @override
  LaundryState createState() => LaundryState();
}

class LaundryState extends ConsumerState<Laundry> {
  LaundryOption _selectedOption = LaundryOption.wash;
  bool unscentedisChecked = false;
  bool delicatesSeparateisChecked = false;
  bool hypoallergenicUnscentedisChecked = false;
  bool hangarServiceisChecked = false;
  bool warmWaterisChecked = false;
  bool ownProductsisChecked = false;
  dynamic weightOfLoad = 10;
  TextEditingController? specialInstructionsController =
      TextEditingController();

  void unscentedCheck(bool value) {
    setState(() {
      unscentedisChecked = value;
      if (unscentedisChecked == true) {
        hypoallergenicUnscentedisChecked = false;
      }
    });
  }

  void hypoallergenicUnscentedCheck(bool value) {
    setState(() {
      hypoallergenicUnscentedisChecked = value;
      if (hypoallergenicUnscentedisChecked == true) {
        unscentedisChecked = false;
      }
    });
  }

  void selectOption(LaundryOption option) {
    setState(
      () {
        if (_selectedOption == option) {
          return;
        } else {
          _selectedOption = option;
        }
      },
    );
  }

  bool isSelected(LaundryOption option) {
    return _selectedOption == option;
  }

  void updateLaundryOrderSettings() {
    LaundrySettings newLaundrySettings = LaundrySettings(
      selectedOption: _selectedOption,
      unscented: unscentedisChecked,
      delicatesSeparate: delicatesSeparateisChecked,
      hypoallergenicUnscented: hypoallergenicUnscentedisChecked,
      hangarService: hangarServiceisChecked,
      warmWater: warmWaterisChecked,
      ownProducts: ownProductsisChecked,
      weightOfLoad: weightOfLoad,
      specialInstructions:
          specialInstructionsController?.text ?? 'No special Instructions',
    );

    ref
        .read(laundryOrderPayloadProvider.notifier)
        .updateLaundryData(newLaundrySettings);
  }

  double _calculatedprice = 20;

  double calculatePrice(double weightOfLoad) {
    if (weightOfLoad < 10) {
      return 20;
    }
    double basePrice = 20;
    double additionalWeight = weightOfLoad - 10;
    double additionalPrice = additionalWeight * 2.1;
    return basePrice + additionalPrice;
  }

  void _updatePrice() {
    setState(() {
      _calculatedprice = calculatePrice(weightOfLoad);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(240),
        child: ServiceAppbar(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LaundryButton(
                      option: LaundryOption.wash,
                      selectedOption: _selectedOption,
                      onSelected: selectOption,
                      imagePath: 'laundry.svg',
                      text: 'Wash',
                      padding: const EdgeInsets.fromLTRB(27, 12, 27, 21),
                    ),
                    LaundryButton(
                      option: LaundryOption.washFold,
                      selectedOption: _selectedOption,
                      onSelected: selectOption,
                      imagePath: 'wash_fold.svg',
                      text: 'Wash & Fold',
                      padding: const EdgeInsets.fromLTRB(13, 12, 13, 21),
                    ),
                    LaundryButton(
                      option: LaundryOption.washIronFold,
                      selectedOption: _selectedOption,
                      onSelected: selectOption,
                      imagePath: 'wash_iron_fold.svg',
                      text: 'Wash, Iron\n& Fold',
                      padding: const EdgeInsets.fromLTRB(11, 12, 11, 12),
                    ),
                  ],
                ),
                const Gap(20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFBCBCBC),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Weight of the load',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF1C2649),
                            ),
                          ),
                          InputQty(
                            maxVal: 50,
                            initVal: 10,
                            steps: 1,
                            minVal: 10,
                            onQtyChanged: (value) {
                              (weightOfLoad = value.toDouble());
                              _updatePrice();
                            },
                            qtyFormProps: const QtyFormProps(
                              enableTyping: false,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF4C95EF),
                              ),
                            ),
                            decoration: QtyDecorationProps(
                              width: 8,
                              iconColor: const Color.fromRGBO(255, 0, 0, 1),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color(0xFF4C95EF),
                                ),
                              ),
                              isBordered: true,
                              fillColor: const Color(0xFFF7FCFF),
                              minusBtn: SizedBox(
                                height: 26,
                                width: 20,
                                child: Center(
                                  child: SvgPicture.asset('assets/minus.svg'),
                                ),
                              ),
                              plusBtn: SizedBox(
                                height: 26,
                                width: 20,
                                child: Center(
                                  child: SvgPicture.asset('assets/plus.svg'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      const Divider(
                        color: Color(0xFFBCBCBC),
                        thickness: 1,
                      ),
                      const Gap(20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Additional Requests',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1C2649),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: Checkbox(
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                        width: 1.0,
                                        color: Color(0xFF4C95EF),
                                      ),
                                    ),
                                    splashRadius: 0,
                                    checkColor: const Color(0xFF4C95EF),
                                    activeColor: Colors.white,
                                    value: unscentedisChecked,
                                    onChanged: (bool? value) {
                                      setState(
                                        () {
                                          unscentedCheck(value!);
                                        },
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'Scented',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: Checkbox(
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                        width: 1.0,
                                        color: Color(0xFF4C95EF),
                                      ),
                                    ),
                                    splashRadius: 0,
                                    checkColor: const Color(0xFF4C95EF),
                                    activeColor: Colors.white,
                                    value: delicatesSeparateisChecked,
                                    onChanged: (bool? value) {
                                      setState(
                                        () {
                                          delicatesSeparateisChecked = value!;
                                        },
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'Delicates separate',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: Checkbox(
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => const BorderSide(
                                          width: 1.0,
                                          color: Color(0xFF4C95EF),
                                        ),
                                      ),
                                      splashRadius: 0,
                                      checkColor: const Color(0xFF4C95EF),
                                      activeColor: Colors.white,
                                      value: hypoallergenicUnscentedisChecked,
                                      onChanged: (bool? value) {
                                        setState(
                                          () {
                                            hypoallergenicUnscentedCheck(
                                                value!);
                                          },
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'Hypoallergenic\nunscented',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: Checkbox(
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                        width: 1.0,
                                        color: Color(0xFF4C95EF),
                                      ),
                                    ),
                                    splashRadius: 0,
                                    checkColor: const Color(0xFF4C95EF),
                                    activeColor: Colors.white,
                                    value: hangarServiceisChecked,
                                    onChanged: (bool? value) {
                                      setState(
                                        () {
                                          hangarServiceisChecked = value!;
                                        },
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'Hanger Service',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: Checkbox(
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                        width: 1.0,
                                        color: Color(0xFF4C95EF),
                                      ),
                                    ),
                                    splashRadius: 0,
                                    checkColor: const Color(0xFF4C95EF),
                                    activeColor: Colors.white,
                                    value: warmWaterisChecked,
                                    onChanged: (bool? value) {
                                      setState(
                                        () {
                                          warmWaterisChecked = value!;
                                        },
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'Warm water',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: Checkbox(
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                        width: 1.0,
                                        color: Color(0xFF4C95EF),
                                      ),
                                    ),
                                    splashRadius: 0,
                                    checkColor: const Color(0xFF4C95EF),
                                    activeColor: Colors.white,
                                    value: ownProductsisChecked,
                                    onChanged: (bool? value) {
                                      setState(
                                        () {
                                          ownProductsisChecked = value!;
                                        },
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'I will provide my own products',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      const Divider(
                        color: Color(0xFFBCBCBC),
                        thickness: 1,
                      ),
                      const Gap(20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Special Instructions',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1C2649),
                          ),
                        ),
                      ),
                      TextField(
                        controller: specialInstructionsController,
                        maxLines: null,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF1C2649),
                        ),
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFFBCBCBC),
                          ),
                          hintText: 'Add notes',
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFBCBCBC),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(150),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/pickup_dropoff_bottom_icon.svg'),
                      const Gap(8),
                      Text(
                        'Pick up &\nDrop off',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            height: 15 / 12,
                            color: const Color(0xFF1C2649)),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 230,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF723CE8),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 14),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClothScreen(
                              calculatedPrice: _calculatedprice,
                            ),
                          ),
                        );
                        updateLaundryOrderSettings();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_calculatedprice.toStringAsFixed(0)} CDN',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        height: 21 / 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Total',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        height: 18 / 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Add Items',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 20 / 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const Gap(15),
                                SvgPicture.asset(
                                    'assets/right_small_arrow_bottom.svg'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
