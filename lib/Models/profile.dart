class Profile {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final int id;
  final bool isActive;
  final bool isVerified;
  final int? defaultAddressId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.id,
    required this.isActive,
    required this.isVerified,
    this.defaultAddressId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNo: json['phone_no'] as String,
      id: json['id'] as int,
      isActive: json['is_active'] as bool,
      isVerified: json['is_verified'] as bool,
      defaultAddressId: json['default_address_id'] as int?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_no': phoneNo,
      'id': id,
      'is_active': isActive,
      'is_verified': isVerified,
      'default_address_id': defaultAddressId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
