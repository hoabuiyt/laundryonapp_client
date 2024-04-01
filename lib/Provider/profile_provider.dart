import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryonapp/Models/profile.dart';

class ProfileNotifier extends StateNotifier<Profile?> {
  ProfileNotifier() : super(null);

  void setProfile(Profile profile) {
    state = profile;
  }

  void updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNo,
    int? id,
    bool? isActive,
    bool? isVerified,
    int? defaultAddressId,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    if (state == null) return;
    state = Profile(
      firstName: firstName ?? state!.firstName,
      lastName: lastName ?? state!.lastName,
      email: email ?? state!.email,
      phoneNo: phoneNo ?? state!.phoneNo,
      id: id ?? state!.id,
      isActive: isActive ?? state!.isActive,
      isVerified: isVerified ?? state!.isVerified,
      defaultAddressId: defaultAddressId ?? state!.defaultAddressId,
      createdAt: createdAt ?? state!.createdAt,
      updatedAt: updatedAt ?? state!.updatedAt,
      deletedAt: deletedAt ?? state!.deletedAt,
    );
  }

  void updateDefaultAddressId(int defaultAddressId) {
    if (state == null) return;
    state = Profile(
      firstName: state!.firstName,
      lastName: state!.lastName,
      email: state!.email,
      phoneNo: state!.phoneNo,
      id: state!.id,
      isActive: state!.isActive,
      isVerified: state!.isVerified,
      defaultAddressId: defaultAddressId,
      createdAt: state!.createdAt,
      updatedAt: state!.updatedAt,
      deletedAt: state!.deletedAt,
    );
    print('Updated default address ID to ${state!.defaultAddressId}');
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile?>(
    (ref) => ProfileNotifier());
