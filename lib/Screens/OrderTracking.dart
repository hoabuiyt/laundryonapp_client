import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:laundryonapp/Provider/currentOrderProvider.dart';
import 'package:laundryonapp/API_calls/get_current_order.dart';
import 'package:laundryonapp/Provider/authData_provider.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart' as lottie;

class OrderTrackingScreen extends ConsumerStatefulWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle();
  }

  Future<void> _setMapStyle() async {
    String style =
        '[{"featureType": "poi","elementType": "all","stylers": [{"visibility": "off"}]}]';
    mapController.setMapStyle(style);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("Loading start icon...");
      final BitmapDescriptor startIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'assets/car.png',
      );
      print("Start icon loaded.");
      final BitmapDescriptor endIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'assets/home.png',
      );

      final token = ref.read(authDataProvider).token;
      final currentOrder = ref.read(currentOrderProvider);
      if (currentOrder == null) {
        getCurrentOrder(token, ref);
      }

      final LatLng initialPosition = LatLng(
          // currentOrder?.customerAddress?.latitude ?? 49.140838,
          49.140838,
          // currentOrder?.customerAddress?.longitude ??
          -122.845290);

      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId('startMarker'),
            position: initialPosition,
          ),
        );
      });
      if (mapController != null) {
        _updateCameraBounds();
      }
    });
  }

  Future<void> fetchDirectionsAndDrawPolyline(LatLng start, LatLng end) async {
    final String googleApiKey = 'AIzaSyBkGBM8chYfUdEj6j2Wwxj_LV7KTQQMwg0';
    final Uri requestUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$googleApiKey');

    print('Making request to: $requestUri');

    final response = await http.get(requestUri);

    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Directions API response data: $data');

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final routePolyline = route['overview_polyline']['points'];
        final points = _decodePoly(routePolyline);

        setState(() {
          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: points,
              color: const Color(0xFF723CE8),
              width: 5,
            ),
          );
        });
      } else {
        print('No routes found in the response.');
      }
    } else {
      print('Error fetching directions: ${response.body}');
      if (response.body.contains('REQUEST_DENIED')) {
        print(
            'Directions API request was denied. Check if the API is enabled and the API key is correct.');
      }
    }
  }

  List<LatLng> _convertToLatLng(List<dynamic> polyline) {
    List<LatLng> result = [];
    for (int i = 0; i < polyline.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(polyline[i - 1], polyline[i]));
      }
    }
    return result;
  }

  List<LatLng> _decodePoly(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }

    return poly;
  }

  void _updateCameraBounds() {
    if (markers.isNotEmpty) {
      var minLat = markers.first.position.latitude;
      var maxLat = markers.first.position.latitude;
      var minLng = markers.first.position.longitude;
      var maxLng = markers.first.position.longitude;

      for (var marker in markers) {
        minLat = min(minLat, marker.position.latitude);
        maxLat = max(maxLat, marker.position.latitude);
        minLng = min(minLng, marker.position.longitude);
        maxLng = max(maxLng, marker.position.longitude);
      }

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      CameraUpdate update = CameraUpdate.newLatLngBounds(bounds, 50);
      mapController.animateCamera(update);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentOrder = ref.watch(currentOrderProvider);
    final latitude = currentOrder?.customerAddress?.latitude ?? 22.589397;
    final longitude = currentOrder?.customerAddress?.longitude ?? 88.309083;
    final initialPosition = LatLng(49.140838, -122.845290);

    markers.add(
      Marker(
        markerId: const MarkerId('centerMarker'),
        position: initialPosition,
      ),
    );

    return MaterialApp(
      title: 'Order Tracking',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Order Tracking'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            const Text(
              'Looking for Laundromat',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            lottie.Lottie.asset(
              'assets/loading_dots.json',
              width: 60,
              height: 60,
            ),
            Stack(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: 350,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 15.0,
                    ),
                    zoomControlsEnabled: false,
                    markers: markers,
                    polylines: polylines,
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
