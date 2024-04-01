import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:laundryonapp/Models/address.dart';
import 'package:laundryonapp/Models/laundryOrderSettings.dart';
import 'package:laundryonapp/Models/garmentType.dart';
import 'package:laundryonapp/Models/deliveryMethod.dart';
import 'package:laundryonapp/Models/pickupDropoffTime.dart';

class LaundryOrderPayload {
  LaundrySettings laundrySettingsData;
  AddressInfo locationData;
  List<GarmentType> selectedGarments;
  DeliveryType deliveryType;
  PickupDropOffTime pickupDropOffTime;

  LaundryOrderPayload(
      {required this.laundrySettingsData,
      required this.locationData,
      required this.selectedGarments,
      required this.deliveryType,
      required this.pickupDropOffTime});

  LaundryOrderPayload.initial()
      : laundrySettingsData = LaundrySettings(),
        locationData = AddressInfo(),
        selectedGarments = [],
        deliveryType = DeliveryType(),
        pickupDropOffTime = PickupDropOffTime();
}

class LaundryOrderPayloadNotifier extends StateNotifier<LaundryOrderPayload> {
  LaundryOrderPayloadNotifier() : super(LaundryOrderPayload.initial());

  void updateLaundryData(LaundrySettings newLaundryData) {
    state = LaundryOrderPayload(
      laundrySettingsData: newLaundryData,
      locationData: state.locationData,
      selectedGarments: state.selectedGarments,
      deliveryType: state.deliveryType,
      pickupDropOffTime: state.pickupDropOffTime,
    );
  }

  void updateLocationData(AddressInfo newLocationData) {
    state = LaundryOrderPayload(
      laundrySettingsData: state.laundrySettingsData,
      locationData: newLocationData,
      selectedGarments: state.selectedGarments,
      deliveryType: state.deliveryType,
      pickupDropOffTime: state.pickupDropOffTime,
    );
  }

  void updateSelectedGarments(List<GarmentType> newGarments) {
    state = LaundryOrderPayload(
      laundrySettingsData: state.laundrySettingsData,
      locationData: state.locationData,
      deliveryType: state.deliveryType,
      pickupDropOffTime: state.pickupDropOffTime,
      selectedGarments: newGarments,
    );
  }

  void updateDeliveryType(DeliveryType newDeliveryType) {
    state = LaundryOrderPayload(
      laundrySettingsData: state.laundrySettingsData,
      locationData: state.locationData,
      selectedGarments: state.selectedGarments,
      deliveryType: newDeliveryType,
      pickupDropOffTime: state.pickupDropOffTime,
    );
  }

  void updatePickupDropoffTime(PickupDropOffTime newPickupDropoffTime) {
    state = LaundryOrderPayload(
      laundrySettingsData: state.laundrySettingsData,
      locationData: state.locationData,
      selectedGarments: state.selectedGarments,
      deliveryType: state.deliveryType,
      pickupDropOffTime: newPickupDropoffTime,
    );
  }

  Map<String, dynamic> generateDetailsJson(LaundryOrderPayload state) {
    final items = <String, dynamic>{};
    for (var garment in state.selectedGarments) {
      items[garment.name] = garment.quantity is int
          ? garment.quantity
          : (garment.quantity as double).toInt();
    }

    int roundedWeight =
        (state.laundrySettingsData.weightOfLoad as double).round();

    return {
      'weight': roundedWeight,
      'items': items,
      'unscented': state.laundrySettingsData.unscented,
      'delicatesSeparate': state.laundrySettingsData.delicatesSeparate,
      'hypoallergenicUnscented':
          state.laundrySettingsData.hypoallergenicUnscented,
      'hangerService': state.laundrySettingsData.hangarService,
      'warmWater': state.laundrySettingsData.warmWater,
      'ownProducts': state.laundrySettingsData.ownProducts,
      'specialInstructions':
          state.laundrySettingsData.specialInstructions ?? '',
      'deliveryType': state.deliveryType.deliveryMethod.toString(),
      'sameDayDelivery': state.deliveryType.sameDayDelivery,
      'address': {
        'latitude': state.locationData.latitude,
        'longitude': state.locationData.longitude,
        'fullAddress': state.locationData.fullAddress,
        'landmark': state.locationData.landmark,
        'buzzerCode': state.locationData.buzzerCode,
        'deliveryDoor': state.locationData.deliveryDoor,
        'addressType': state.locationData.addressType,
      }
    };
  }

  String generatePayloadJson(int defaultAddressId) {
    final details = generateDetailsJson(state);

    String formatDateTime(DateTime date, TimeOfDay time) {
      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }

    String pickupDateTimeString = '';
    if (state.pickupDropOffTime.pickUpDate != null &&
        state.pickupDropOffTime.pickUpTime != null) {
      pickupDateTimeString = formatDateTime(state.pickupDropOffTime.pickUpDate!,
          state.pickupDropOffTime.pickUpTime!.toTimeOfDay());
    }

    String dropoffDateTimeString = '';
    if (state.pickupDropOffTime.dropOffDate != null &&
        state.pickupDropOffTime.dropOffTime != null) {
      dropoffDateTimeString = formatDateTime(
          state.pickupDropOffTime.dropOffDate!,
          state.pickupDropOffTime.dropOffTime!.toTimeOfDay());
    }

    final payload = {
      'category': 'Laundry',
      'details': details,
      "customer_address_id": defaultAddressId,
      'pickup_time': pickupDateTimeString,
      'dropoff_time': dropoffDateTimeString,
    };

    return jsonEncode(payload);
  }
}

final laundryOrderPayloadProvider =
    StateNotifierProvider<LaundryOrderPayloadNotifier, LaundryOrderPayload>(
  (ref) {
    return LaundryOrderPayloadNotifier();
  },
);

class IroningOrderPayload {
  AddressInfo locationData;
  List<GarmentType> selectedGarments;
  DeliveryType deliveryType;
  PickupDropOffTime pickupDropOffTime;

  IroningOrderPayload(
      {required this.locationData,
      required this.selectedGarments,
      required this.deliveryType,
      required this.pickupDropOffTime});

  IroningOrderPayload.initial()
      : locationData = AddressInfo(),
        selectedGarments = [],
        deliveryType = DeliveryType(),
        pickupDropOffTime = PickupDropOffTime();
}

class IroningOrderPayloadNotifier extends StateNotifier<IroningOrderPayload> {
  IroningOrderPayloadNotifier() : super(IroningOrderPayload.initial());

  void updateSelectedGarments(List<GarmentType> newGarments) {
    state = IroningOrderPayload(
      locationData: state.locationData,
      deliveryType: state.deliveryType,
      pickupDropOffTime: state.pickupDropOffTime,
      selectedGarments: newGarments,
    );
  }

  String generatePayloadJson(int defaultAddressId) {
    final items = <String, dynamic>{};
    for (var garment in state.selectedGarments) {
      String formattedName = garment.name.toLowerCase().replaceAll(' ', '_');
      items[formattedName] = garment.quantity is int
          ? garment.quantity
          : (garment.quantity as double).toInt();
    }

    final details = {
      'weight': 1,
      'items': items,
      'additional_requests': {},
    };

    String formatDateTime(DateTime date, TimeOfDay time) {
      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }

    String pickupDateTimeString = '';
    if (state.pickupDropOffTime.pickUpDate != null &&
        state.pickupDropOffTime.pickUpTime != null) {
      pickupDateTimeString = formatDateTime(state.pickupDropOffTime.pickUpDate!,
          state.pickupDropOffTime.pickUpTime!.toTimeOfDay());
    }

    String dropoffDateTimeString = '';
    if (state.pickupDropOffTime.dropOffDate != null &&
        state.pickupDropOffTime.dropOffTime != null) {
      dropoffDateTimeString = formatDateTime(
          state.pickupDropOffTime.dropOffDate!,
          state.pickupDropOffTime.dropOffTime!.toTimeOfDay());
    }

    final payload = {
      'category': 'ironing',
      'details': details,
      'customer_address_id': defaultAddressId,
      'pickup_time': '2024-01-12 17:21:30',
      'dropoff_time': '2024-01-13 17:21:30',
    };

    return jsonEncode(payload);
  }
}

final ironingOrderPayloadProvider =
    StateNotifierProvider<IroningOrderPayloadNotifier, IroningOrderPayload>(
  (ref) {
    return IroningOrderPayloadNotifier();
  },
);

class DryCleaningOrderPayload {
  AddressInfo locationData;
  List<GarmentType> selectedGarments;
  DeliveryType deliveryType;
  PickupDropOffTime pickupDropOffTime;

  DryCleaningOrderPayload(
      {required this.locationData,
      required this.selectedGarments,
      required this.deliveryType,
      required this.pickupDropOffTime});

  DryCleaningOrderPayload.initial()
      : locationData = AddressInfo(),
        selectedGarments = [],
        deliveryType = DeliveryType(),
        pickupDropOffTime = PickupDropOffTime();
}

class DryCleaningOrderPayloadNotifier
    extends StateNotifier<DryCleaningOrderPayload> {
  DryCleaningOrderPayloadNotifier() : super(DryCleaningOrderPayload.initial());

  void updateSelectedGarments(List<GarmentType> newGarments) {
    state = DryCleaningOrderPayload(
      locationData: state.locationData,
      deliveryType: state.deliveryType,
      pickupDropOffTime: state.pickupDropOffTime,
      selectedGarments: newGarments,
    );
  }

  String generatePayloadJson(int defaultAddressId) {
    final items = <String, dynamic>{};
    for (var garment in state.selectedGarments) {
      String formattedName = garment.name.toLowerCase().replaceAll(' ', '_');
      items[formattedName] = garment.quantity is int
          ? garment.quantity
          : (garment.quantity as double).toInt();
    }

    final details = {
      'weight': 1,
      'items': items,
      'additional_requests': {},
    };

    String formatDateTime(DateTime date, TimeOfDay time) {
      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }

    String pickupDateTimeString = '';
    if (state.pickupDropOffTime.pickUpDate != null &&
        state.pickupDropOffTime.pickUpTime != null) {
      pickupDateTimeString = formatDateTime(state.pickupDropOffTime.pickUpDate!,
          state.pickupDropOffTime.pickUpTime!.toTimeOfDay());
    }

    String dropoffDateTimeString = '';
    if (state.pickupDropOffTime.dropOffDate != null &&
        state.pickupDropOffTime.dropOffTime != null) {
      dropoffDateTimeString = formatDateTime(
          state.pickupDropOffTime.dropOffDate!,
          state.pickupDropOffTime.dropOffTime!.toTimeOfDay());
    }

    final payload = {
      'category': 'ironing',
      'details': details,
      'customer_address_id': defaultAddressId,
      'pickup_time': '2024-01-12 17:21:30',
      'dropoff_time': '2024-01-13 17:21:30',
    };

    return jsonEncode(payload);
  }
}

final dryCleaningOrderPayloadProvider = StateNotifierProvider<
    DryCleaningOrderPayloadNotifier, DryCleaningOrderPayload>(
  (ref) {
    return DryCleaningOrderPayloadNotifier();
  },
);
