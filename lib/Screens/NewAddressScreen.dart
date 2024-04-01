import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:choice/choice.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:laundryonapp/Models/address.dart';
import 'package:laundryonapp/Provider/location_provider.dart';
import 'package:laundryonapp/Provider/authData_provider.dart';
import 'package:laundryonapp/Screens/HomeScreen.dart';
import 'package:laundryonapp/API_calls/get_address_list.dart';

class NewAddressScreen extends ConsumerStatefulWidget {
  const NewAddressScreen({Key? key}) : super(key: key);
  @override
  NewAddressScreenState createState() => NewAddressScreenState();
}

CameraPosition? _initialCameraPosition;
bool _isFetchingLocation = true;
double? selectedLatitude;
double? selectedLongitude;
TextEditingController _fullAddress = TextEditingController();
TextEditingController _landmark = TextEditingController();
TextEditingController _buzzercode = TextEditingController();
String? selectedDeliveryDoor;
String? selectedAddressType;

class NewAddressScreenState extends ConsumerState<NewAddressScreen> {
  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  TextEditingController _searchController = TextEditingController();
  List<dynamic> _placeSuggestions = [];
  GoogleMapController? _mapController;
  String apiKey = 'AIzaSyBkGBM8chYfUdEj6j2Wwxj_LV7KTQQMwg0';

  void updateAddress() async {
    String token = ref.watch(authDataProvider).token;

    bool success = await addAddress(
      ref,
      token,
      _fullAddress.text,
      _landmark.text,
      _buzzercode.text,
      selectedDeliveryDoor ?? "",
      selectedLatitude ?? 0.0,
      selectedLongitude ?? 0.0,
      selectedAddressType ?? "Home",
    );

    if (success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add address. Please try again.')),
      );
    }
  }

  List<String> doorChoices = [
    'Front Door',
    'Back Door',
    'Side Door',
    'Basement Door',
  ];

  List<String> addressType = [
    'Home',
    'Hotel',
    'Friends and Family',
    'Other',
  ];

  void setSelectedDeliveryDoor(String? value) {
    setState(() => selectedDeliveryDoor = value);
  }

  void setSelectedAddressType(String? value) {
    setState(() => selectedDeliveryDoor = value);
  }

  late CameraPosition _currentCameraPosition;

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
      _isFetchingLocation = false;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _currentCameraPosition = position;
  }

  void _selectLocation() {
    double selectedLatitude = _currentCameraPosition.target.latitude;
    double selectedLongitude = _currentCameraPosition.target.longitude;
  }

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _placeSuggestions = data['predictions'];
        });
      }
    } else {
      setState(() {
        _placeSuggestions = [];
      });
    }
  }

  Future<void> _onSuggestionSelected(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      final LatLng selectedLocation = LatLng(location['lat'], location['lng']);
      _mapController
          ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: selectedLocation,
        zoom: 14.4746,
      )));
      setState(() {
        _placeSuggestions = [];
        _searchController.text = data['result']['name'];
      });
    } else {
      print('Failed to fetch place details');
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Gap(15),
                Row(
                  children: [
                    SvgPicture.asset('assets/location.svg'),
                    const Gap(15),
                    Text(
                      'Enter Address Details',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF1C2649),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFE5E5E5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 54,
                  padding: const EdgeInsets.only(left: 20),
                  child: Center(
                    child: TextField(
                      controller: _fullAddress,
                      autocorrect: false,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1C2649),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Full Address',
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0xFF677294),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFE5E5E5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 54,
                  padding: const EdgeInsets.only(left: 20),
                  child: Center(
                    child: TextField(
                      controller: _landmark,
                      autocorrect: false,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1C2649),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Landmark (optional)',
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0xFF677294),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFE5E5E5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 54,
                  padding: const EdgeInsets.only(left: 20),
                  child: Center(
                    child: TextField(
                      controller: _buzzercode,
                      autocorrect: false,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1C2649),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buzzer Code (optional)',
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0xFF677294),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Gap(30),
                Container(
                  height: 1,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 173, 182, 209),
                        Color.fromARGB(255, 235, 237, 243)
                      ],
                    ),
                  ),
                ),
                const Gap(30),
                Text(
                  'Where to leave delivery?',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF1C2649),
                  ),
                ),
                const Gap(10),
                InlineChoice<String>.single(
                  clearable: true,
                  value: selectedDeliveryDoor,
                  onChanged: setSelectedDeliveryDoor,
                  itemCount: doorChoices.length,
                  itemBuilder: (selection, i) {
                    return ChoiceChip(
                      showCheckmark: false,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF1C2649),
                      ),
                      selected: selection.selected(doorChoices[i]),
                      onSelected: selection.onSelected(doorChoices[i]),
                      label: Text(doorChoices[i]),
                    );
                  },
                  listBuilder: ChoiceList.createWrapped(
                    spacing: 10,
                    runSpacing: 2,
                  ),
                ),
                const Gap(30),
                Container(
                  height: 1,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 173, 182, 209),
                        Color.fromARGB(255, 235, 237, 243)
                      ],
                    ),
                  ),
                ),
                const Gap(30),
                Text(
                  'Save as',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF1C2649),
                  ),
                ),
                const Gap(10),
                InlineChoice<String>.single(
                  clearable: true,
                  value: selectedAddressType,
                  onChanged: setSelectedDeliveryDoor,
                  itemCount: addressType.length,
                  itemBuilder: (selection, i) {
                    return ChoiceChip(
                      showCheckmark: false,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF1C2649),
                      ),
                      selected: selection.selected(addressType[i]),
                      onSelected: selection.onSelected(addressType[i]),
                      label: Text(addressType[i]),
                    );
                  },
                  listBuilder: ChoiceList.createWrapped(
                    spacing: 10,
                    runSpacing: 2,
                  ),
                ),
                const Gap(55),
                SizedBox(
                  height: 51,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => updateAddress(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C95EF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'SAVE ADDRESS',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _isFetchingLocation
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _initialCameraPosition!,
                  onCameraMove: _onCameraMove,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
          const Center(
            child: Icon(Icons.location_pin, color: Color(0xFF723CE8), size: 35),
          ),
          Positioned(
            top: 110,
            left: 20,
            right: 20,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for places...',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _onSearchChanged,
                ),
                if (_placeSuggestions.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _placeSuggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_placeSuggestions[index]['description']),
                          onTap: () => _onSuggestionSelected(
                              _placeSuggestions[index]['place_id']),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset('assets/Back-arrow.svg'),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 51,
              child: ElevatedButton(
                onPressed: () {
                  _selectLocation();
                  _showModalBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C95EF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'CONFIRM LOCATION',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFfFFFFFF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
