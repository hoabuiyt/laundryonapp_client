import 'package:laundryonapp/Widgets/option_checkbox.dart';
import 'package:flutter/material.dart';

class LaundrySettings {
  LaundryOption selectedOption;
  bool unscented;
  bool delicatesSeparate;
  bool hypoallergenicUnscented;
  bool hangarService;
  bool warmWater;
  bool ownProducts;
  dynamic weightOfLoad;
  String? specialInstructions;

  LaundrySettings({
    this.selectedOption = LaundryOption.wash,
    this.unscented = false,
    this.delicatesSeparate = false,
    this.hypoallergenicUnscented = false,
    this.hangarService = false,
    this.warmWater = false,
    this.ownProducts = false,
    this.weightOfLoad,
    this.specialInstructions,
  });
}
