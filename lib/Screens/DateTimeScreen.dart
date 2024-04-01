import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:laundryonapp/Provider/laundryOrder_provider.dart';
import 'package:laundryonapp/Models/pickupDropoffTime.dart';
import 'package:laundryonapp/Screens/LaundryOrderSummaryScreen.dart';

class DateTimeScreen extends ConsumerStatefulWidget {
  const DateTimeScreen({super.key});

  @override
  DateTimeScreenState createState() => DateTimeScreenState();
}

class DateTimeScreenState extends ConsumerState<DateTimeScreen> {
  @override
  void initState() {
    super.initState();
  }

  DateTime? selectedPickUpDate;
  String? formattedPickUpDate;
  final Time _initialPickupTime =
      Time(hour: DateTime.now().hour, minute: DateTime.now().minute);
  Time? _selectedPickupTime;

  DateTime? selectedDropOffDate;
  String? formattedDropOffDate;
  final Time _initialDropOffTime =
      Time(hour: DateTime.now().hour, minute: DateTime.now().minute);
  Time? _selectedDropOffTime;

  void setPickupTime(Time newTime) {
    setState(
      () {
        _selectedPickupTime = newTime;
      },
    );
  }

  void setDropOffTime(Time newTime) {
    setState(
      () {
        _selectedDropOffTime = newTime;
      },
    );
  }

  String convertTo12HourFormat(String timeOfDayString) {
    final timePart = timeOfDayString.substring(
        timeOfDayString.indexOf('(') + 1, timeOfDayString.indexOf(')'));

    List<String> parts = timePart.split(':');
    int hour = int.parse(parts[0]);

    String amPm = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    hour = hour != 0 ? hour : 12;

    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${parts[1]} $amPm';

    return formattedTime;
  }

  Future<void> _openPickUpDatePicker(BuildContext context, String type) async {
    DateTime currentDate = DateTime.now();

    DateTime? newDate = await showRoundedDatePicker(
      height: 350,
      styleDatePicker: MaterialRoundedDatePickerStyle(
        textStyleDayOnCalendarSelected: const TextStyle(
          color: Colors.white,
        ),
        decorationDateSelected: const BoxDecoration(
          color: Color(0xFF723CE8),
          shape: BoxShape.circle,
        ),
      ),
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 211, 190, 255),
      ),
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(const Duration(days: 7)),
      borderRadius: 16,
    );
    if (type == "pickupDate") {
      if (newDate != null && newDate != selectedPickUpDate) {
        setState(
          () {
            selectedPickUpDate = newDate;
            formattedPickUpDate =
                DateFormat('MMMM dd, EEEE').format(selectedPickUpDate!);
          },
        );
      }
    } else if (type == "dropOffDate") {
      if (newDate != null && newDate != selectedDropOffDate) {
        setState(
          () {
            selectedDropOffDate = newDate;
            formattedDropOffDate =
                DateFormat('MMMM dd, EEEE').format(selectedDropOffDate!);
          },
        );
      }
    }
  }

  updateLaundryPayloadPickupDropoffTime() {
    PickupDropOffTime updatedPickupDropoffTime = PickupDropOffTime(
      pickUpDate: selectedPickUpDate,
      dropOffDate: selectedDropOffDate,
      pickUpTime: _selectedPickupTime,
      dropOffTime: _selectedDropOffTime,
    );
    print('Pickup Date - $selectedPickUpDate');
    print('Pickup Time - $_selectedPickupTime');
    print('Dropoff Date - $selectedDropOffDate');
    print('Dropoff Time - $_selectedDropOffTime');

    ref
        .read(laundryOrderPayloadProvider.notifier)
        .updatePickupDropoffTime(updatedPickupDropoffTime);
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
                        'A minimum of 24 hrs gap is necessary',
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
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Set Pick Up:',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1C2649),
                          ),
                        ),
                        const Gap(8),
                        ElevatedButton(
                          onPressed: () {
                            _openPickUpDatePicker(context, "pickupDate");
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            elevation: MaterialStateProperty.all(0),
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFFFFF),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 14.0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(18, 14, 24, 14),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedPickUpDate != null
                                      ? formattedPickUpDate!.toString()
                                      : 'Select Date',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 21 / 14,
                                    fontWeight: FontWeight.normal,
                                    color: formattedPickUpDate != null
                                        ? const Color(0xFF1C2649)
                                        : const Color.fromARGB(127, 60, 60, 60),
                                  ),
                                ),
                                SvgPicture.asset('assets/down-arrow.svg'),
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _initialPickupTime,
                                onChange: setPickupTime,
                                minuteInterval: TimePickerInterval.THIRTY,
                                onChangeDateTime: (DateTime dateTime) {
                                  debugPrint("[debug datetime]:  $dateTime");
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            elevation: MaterialStateProperty.all(0),
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFFFFF),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 14.0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(18, 14, 24, 14),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedPickupTime != null
                                      ? convertTo12HourFormat(
                                          _selectedPickupTime.toString(),
                                        )
                                      : 'Select Pickup Time',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 21 / 14,
                                    fontWeight: FontWeight.normal,
                                    color: _selectedPickupTime != null
                                        ? const Color(0xFF1C2649)
                                        : const Color.fromARGB(127, 60, 60, 60),
                                  ),
                                ),
                                SvgPicture.asset('assets/down-arrow.svg'),
                              ],
                            ),
                          ),
                        ),
                        const Gap(30),
                        Text(
                          'Set Drop Off:',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1C2649),
                          ),
                        ),
                        const Gap(8),
                        ElevatedButton(
                          onPressed: () {
                            _openPickUpDatePicker(context, "dropOffDate");
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            elevation: MaterialStateProperty.all(0),
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFFFFF),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 14.0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(18, 14, 24, 14),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDropOffDate != null
                                      ? formattedDropOffDate!.toString()
                                      : 'Select Date',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 21 / 14,
                                    fontWeight: FontWeight.normal,
                                    color: formattedDropOffDate != null
                                        ? const Color(0xFF1C2649)
                                        : const Color.fromARGB(127, 60, 60, 60),
                                  ),
                                ),
                                SvgPicture.asset('assets/down-arrow.svg'),
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _initialDropOffTime,
                                onChange: setDropOffTime,
                                minuteInterval: TimePickerInterval.THIRTY,
                                onChangeDateTime: (DateTime dateTime) {
                                  debugPrint("[debug datetime]:  $dateTime");
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            elevation: MaterialStateProperty.all(0),
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFFFFF),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 14.0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(18, 14, 24, 14),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDropOffTime != null
                                      ? convertTo12HourFormat(
                                          _selectedDropOffTime.toString(),
                                        )
                                      : 'Select Dropoff Time',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 21 / 14,
                                    fontWeight: FontWeight.normal,
                                    color: _selectedDropOffTime != null
                                        ? const Color(0xFF1C2649)
                                        : const Color.fromARGB(127, 60, 60, 60),
                                  ),
                                ),
                                SvgPicture.asset('assets/down-arrow.svg'),
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
                  updateLaundryPayloadPickupDropoffTime();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LaundryOrderSummaryScreen(),
                    ),
                  );
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
