import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:laundryonapp/Widgets/service_Appbar.dart';
import 'package:laundryonapp/Models/garmentType.dart';
import 'package:laundryonapp/Provider/laundryOrder_provider.dart';
import 'package:laundryonapp/Screens/DeliveryTypeScreen.dart';

class ClothScreenIroning extends ConsumerStatefulWidget {
  const ClothScreenIroning({super.key});

  @override
  ClothScreenIroningState createState() => ClothScreenIroningState();
}

class ClothScreenIroningState extends ConsumerState<ClothScreenIroning> {
  late final TextEditingController _searchString;
  @override
  void initState() {
    super.initState();
    _searchString = TextEditingController();
    _searchString.addListener(
      () {
        filterList();
      },
    );
    filteredGarments = ironingGarments;
  }

  @override
  void dispose() {
    print('Disposing ClothScreenIroningState');
    _searchString.removeListener(filterList);
    _searchString.dispose();
  }

  void filterList() {
    String filter = _searchString.text.toLowerCase();
    setState(
      () {
        filteredGarments = ironingGarments.where(
          (item) {
            return item.name.toLowerCase().contains(filter);
          },
        ).toList();
      },
    );
  }

  void clearFilteredList() {
    setState(
      () {
        filteredGarments = [...ironingGarments];
        _searchString.clear();
      },
    );
  }

  void onSelectGarment(GarmentType garment, dynamic value) {
    setState(() {
      int index =
          selectedGarments.indexWhere((element) => element.id == garment.id);

      if (index != -1) {
        if (value == 0) {
          selectedGarments.removeAt(index);
        } else {
          GarmentType updatedGarment = GarmentType(
            id: garment.id,
            name: garment.name,
            imagepath: garment.imagepath,
            weight: garment.weight,
            category: garment.category,
            price: garment.price,
            quantity: value,
          );

          selectedGarments[index] = updatedGarment;
          print(garment.price);
        }
      } else if (value > 0) {
        selectedGarments.add(garment);
      }
    });
  }

  updateLaundryOrderPayload() {
    ref
        .read(ironingOrderPayloadProvider.notifier)
        .updateSelectedGarments(selectedGarments);
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var garment in selectedGarments) {
      int quantity = 0;
      try {
        if (garment.quantity is int) {
          quantity = garment.quantity;
        } else if (garment.quantity is double) {
          quantity = garment.quantity.toInt();
        } else {
          double quantityAsDouble = double.parse(garment.quantity.toString());
          quantity = quantityAsDouble.toInt();
        }
      } catch (e) {
        print("Error parsing quantity for garment ${garment.name}: $e");
      }
      totalPrice += garment.price * quantity;
    }
    return totalPrice;
  }

  List<GarmentType> filteredGarments = [];
  List<GarmentType> selectedGarments = [];

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(240),
        child: ServiceAppbar(
          TextSvg: 'assets/Iron-text.svg',
          MainPng: 'assets/Iron-main.png',
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.only(left: 20),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/search.svg'),
                                const Gap(13),
                                Expanded(
                                  child: TextField(
                                    controller: _searchString,
                                    autocorrect: false,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF1C2649),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Search garment type',
                                      hintStyle: GoogleFonts.poppins(
                                        color: const Color(0xFF677294),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: clearFilteredList,
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(0),
                                    ),
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  icon: SvgPicture.asset('assets/close.svg'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 65),
                      itemBuilder: (context, i) => Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.08),
                                    blurRadius: 20,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SvgPicture.asset(
                                    filteredGarments[i].imagepath,
                                  ),
                                  title: Text(
                                    filteredGarments[i].name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF677294),
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF4C95EF),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: InputQty(
                                      maxVal: 50,
                                      initVal: 0,
                                      steps: 1,
                                      minVal: 0,
                                      onQtyChanged: (value) {
                                        onSelectGarment(
                                          GarmentType(
                                            id: filteredGarments[i].id,
                                            name: filteredGarments[i].name,
                                            imagepath:
                                                filteredGarments[i].imagepath,
                                            weight: filteredGarments[i].weight,
                                            category:
                                                filteredGarments[i].category,
                                            price: filteredGarments[i].price,
                                            quantity: value,
                                          ),
                                          value,
                                        );
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
                                        iconColor:
                                            const Color.fromRGBO(255, 0, 0, 1),
                                        isBordered: false,
                                        fillColor: const Color(0xFFF7FCFF),
                                        minusBtn: SizedBox(
                                          height: 26,
                                          width: 20,
                                          child: Center(
                                            child: SvgPicture.asset(
                                                'assets/minus.svg'),
                                          ),
                                        ),
                                        plusBtn: SizedBox(
                                          height: 26,
                                          width: 20,
                                          child: Center(
                                            child: SvgPicture.asset(
                                                'assets/plus.svg'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      itemCount: filteredGarments.length),
                ),
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
                            builder: (context) =>
                                const DeliveryTypeScreen(type: 'ironing'),
                          ),
                        );
                        updateLaundryOrderPayload();
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
                                      totalPrice == 0
                                          ? '0 CAD'
                                          : '${totalPrice.toStringAsFixed(2)} CAD',
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
