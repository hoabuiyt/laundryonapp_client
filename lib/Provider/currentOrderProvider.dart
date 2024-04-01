import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/OrderModel/currentOrder.dart';

class CurrentOrderStateNotifier extends StateNotifier<CurrentOrder?> {
  CurrentOrderStateNotifier() : super(null);

  void setCurrentOrder(CurrentOrder? newOrder) {
    state = newOrder;
  }

  void updatePaymentStatus(String newPaymentStatus) {
    if (state != null) {
      state = CurrentOrder(
        id: state!.id,
        category: state!.category,
        details: state!.details,
        pickupTime: state!.pickupTime,
        dropoffTime: state!.dropoffTime,
        customer: state!.customer,
        customerAddress: state!.customerAddress,
        laundromartAddress: state!.laundromartAddress,
        pickupDriverId: state!.pickupDriverId,
        dropoffDriverId: state!.dropoffDriverId,
        orderPayment: state!.orderPayment,
        orderStatus: state!.orderStatus,
        orderMeta: state!.orderMeta,
        paymentStatus: newPaymentStatus,
        createdAt: state!.createdAt,
        updatedAt: state!.updatedAt,
        deletedAt: state!.deletedAt,
      );
    }
  }
}

final currentOrderProvider =
    StateNotifierProvider<CurrentOrderStateNotifier, CurrentOrder?>((ref) {
  return CurrentOrderStateNotifier();
});
