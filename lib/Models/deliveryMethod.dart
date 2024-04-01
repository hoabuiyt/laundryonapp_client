import 'package:laundryonapp/Widgets/delivery_option_checkbox.dart';

class DeliveryType {
  DeliveryMethod deliveryMethod;
  bool sameDayDelivery;

  DeliveryType(
      {this.deliveryMethod = DeliveryMethod.normalPickUpandDrop,
      this.sameDayDelivery = false});
}
