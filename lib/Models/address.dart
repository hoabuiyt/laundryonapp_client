class AddressInfo {
  final String? fullAddress;
  final String? landmark;
  final String? buzzerCode;
  final String? deliveryDoor;
  final double? latitude;
  final double? longitude;
  final String? addressType;
  final int? addressId;
  bool isSelected;

  AddressInfo({
    this.fullAddress,
    this.landmark,
    this.buzzerCode,
    this.deliveryDoor,
    this.latitude,
    this.longitude,
    this.addressType,
    this.addressId,
    this.isSelected = false,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) => AddressInfo(
        fullAddress: json['full_address'] as String?,
        landmark: json['landmark'] as String?,
        buzzerCode: json['buzzer_code'] as String?,
        deliveryDoor: json['delivery_door'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        addressType: json['address_type'] as String?,
        addressId: json['id'] as int?,
      );
}
