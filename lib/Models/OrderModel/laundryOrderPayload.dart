import 'package:laundryonapp/Models/garmentType.dart';

class LaundryOrder {
  final List<GarmentType> garments;
  final double weightOfLoad;
  final bool unscented;
  final bool delicatesSeparate;
  final bool hypoallergenicUnscented;
  final bool hangerService;
  final bool warmWater;
  final bool ownProducts;
  final String specialInstructions;
  final String deliveryType;
  final bool sameDay;
  final String pickUpDate;
  final String pickUpTime;
  final String dropOffDate;
  final String dropOffTime;

  LaundryOrder({
    required this.garments,
    required this.weightOfLoad,
    this.unscented = false,
    this.delicatesSeparate = false,
    this.hypoallergenicUnscented = false,
    this.hangerService = false,
    this.warmWater = false,
    this.ownProducts = false,
    this.specialInstructions = '',
    this.deliveryType = '',
    this.sameDay = false,
    this.pickUpDate = '',
    this.pickUpTime = '',
    this.dropOffDate = '',
    this.dropOffTime = '',
  });

  LaundryOrder copyWith({
    List<GarmentType>? garments,
    double? weightOfLoad,
    bool? unscented,
    bool? delicatesSeparate,
    bool? hypoallergenicUnscented,
    bool? hangerService,
    bool? warmWater,
    bool? ownProducts,
    String? specialInstructions,
    String? deliveryType,
    bool? sameDay,
    String? pickUpDate,
    String? pickUpTime,
    String? dropOffDate,
    String? dropOffTime,
  }) {
    return LaundryOrder(
      garments: garments ?? this.garments,
      weightOfLoad: weightOfLoad ?? this.weightOfLoad,
      unscented: unscented ?? this.unscented,
      delicatesSeparate: delicatesSeparate ?? this.delicatesSeparate,
      hypoallergenicUnscented:
          hypoallergenicUnscented ?? this.hypoallergenicUnscented,
      hangerService: hangerService ?? this.hangerService,
      warmWater: warmWater ?? this.warmWater,
      ownProducts: ownProducts ?? this.ownProducts,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      deliveryType: deliveryType ?? this.deliveryType,
      sameDay: sameDay ?? this.sameDay,
      pickUpDate: pickUpDate ?? this.pickUpDate,
      pickUpTime: pickUpTime ?? this.pickUpTime,
      dropOffDate: dropOffDate ?? this.dropOffDate,
      dropOffTime: dropOffTime ?? this.dropOffTime,
    );
  }
}
