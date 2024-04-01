class CurrentOrder {
  int? id;
  String? category;
  Details? details;
  String? pickupTime;
  String? dropoffTime;
  Customer? customer;
  CustomerAddress? customerAddress;
  dynamic laundromartAddress;
  dynamic pickupDriverId;
  dynamic dropoffDriverId;
  dynamic orderPayment;
  String? orderStatus;
  Map<String, dynamic>? orderMeta;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  CurrentOrder({
    this.id,
    this.category,
    this.details,
    this.pickupTime,
    this.dropoffTime,
    this.customer,
    this.customerAddress,
    this.laundromartAddress,
    this.pickupDriverId,
    this.dropoffDriverId,
    this.orderPayment,
    this.orderStatus,
    this.orderMeta,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CurrentOrder.fromJson(Map<String, dynamic> json) => CurrentOrder(
        id: json['id'],
        category: json['category'],
        details:
            json['details'] == null ? null : Details.fromJson(json['details']),
        pickupTime: json['pickup_time'],
        dropoffTime: json['dropoff_time'],
        customer: json['customer'] == null
            ? null
            : Customer.fromJson(json['customer']),
        customerAddress: json['customer_address'] == null
            ? null
            : CustomerAddress.fromJson(json['customer_address']),
        laundromartAddress: json['laundromart_address'],
        pickupDriverId: json['pickup_driver_id'],
        dropoffDriverId: json['dropoff_driver_id'],
        orderPayment: json['order_payment'],
        orderStatus: json['order_status'],
        orderMeta: json['order_meta'],
        paymentStatus: json['payment_status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        deletedAt: json['deleted_at'],
      );
}

class Details {
  double? weight;
  Map<String, int>? items;
  dynamic additionalRequests;
  dynamic specialInstructions;

  Details(
      {this.weight,
      this.items,
      this.additionalRequests,
      this.specialInstructions});

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        weight: json['weight'],
        items:
            Map.from(json['items']).map((k, v) => MapEntry<String, int>(k, v)),
        additionalRequests: json['additional_requests'],
        specialInstructions: json['special_instructions'],
      );
}

class Customer {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNo;
  int? id;
  bool? isActive;
  bool? isVerified;
  int? defaultAddressId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Customer({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNo,
    this.id,
    this.isActive,
    this.isVerified,
    this.defaultAddressId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        phoneNo: json['phone_no'],
        id: json['id'],
        isActive: json['is_active'],
        isVerified: json['is_verified'],
        defaultAddressId: json['default_address_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        deletedAt: json['deleted_at'],
      );
}

class CustomerAddress {
  String? landmark;
  double? latitude;
  double? longitude;
  String? buzzerCode;
  String? addressType;
  String? fullAddress;
  String? deliveryDoor;

  CustomerAddress({
    this.landmark,
    this.latitude,
    this.longitude,
    this.buzzerCode,
    this.addressType,
    this.fullAddress,
    this.deliveryDoor,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
        landmark: json['landmark'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        buzzerCode: json['buzzer_code'],
        addressType: json['address_type'],
        fullAddress: json['full_address'],
        deliveryDoor: json['delivery_door'],
      );
}
