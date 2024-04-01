import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String clientSecret =
      'pi_3OVxGFG8qLogHio903iPJaJj_secret_Jzm10CWBIhmkvEzWc5ETkwCTn';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Pay with Stripe'),
          onPressed: makePayment,
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      // Make sure to call `initPaymentSheet` before showing the payment sheet.
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your Merchant Name',
        ),
      );

      // Present the Stripe payment sheet
      await Stripe.instance.presentPaymentSheet();

      // If the payment is successful, you can handle the success state here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful')),
      );
    } catch (e) {
      // If the payment fails, handle the error state here
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment error: ${e.error.localizedMessage}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment error: $e')),
        );
      }
    }
  }
}
