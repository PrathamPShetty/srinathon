import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../consts/assets.dart';
import '../consts/ip.dart';
import 'package:intl/intl.dart';import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../location/location.dart';
import '../../../utils/payment_utils.dart';
import 'package:farm_link_ai/consts/ip.dart';




class RazorpayUtils {
  late Razorpay _razorpay;



  void initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(String orderId, int amount, String key) {
    initRazorpay();
    var options = {
      'key': key,
      'amount': amount,
      'name': 'Aikyam',
      'description': 'Payment for Order $orderId',
      'order_id': orderId,
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
      'theme': {'color': '#3399cc'},


    };
    try {
      _razorpay.open(options);

    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<String?> createOrder(int amount) async {
    try {

      final response = await http.post(
        Uri.parse('$host:5000/create_order?amount=$amount'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['order_id'];  // Replace with the actual response format
      } else {
        debugPrint("Failed to create order");
        return null;
      }
    } catch (e) {
      debugPrint("Error creating order: $e");
      return null;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{

    debugPrint("Payment success: ${response.toString()}");

    final position = await LocationService.getCurrentLocation();


    // final response = await http.post(
    //   Uri.parse('$host:8000/api/bookings/'),
    //   body: jsonEncode({
    //     "user": 1,
    //     "service": userId,
    //     "additional_service": "Extra towels",
    //     "call": '$call',
    //     "time": DateFormat('HH:mm:ss').format(now),
    //     "date":  DateFormat('yyyy-MM-dd').format(now),
    //     "latitude": position['latitude'],
    //     "longitude": position['longitude'],
    //
    //   }),
    //   headers: {'Content-Type': 'application/json'},
    // );

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment error: ${response.message}");
    // Handle payment error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External wallet selected: ${response.walletName}");
    // Handle external wallet selection
  }

  Future<void> _verifyPayment(String paymentId, String orderId) async {
    try {
      final response = await http.post(
        Uri.parse('$host:8000/verify-payment'),
        body: {
          'payment_id': paymentId,
          'order_id': orderId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          debugPrint("Payment verified successfully");
        } else {
          debugPrint("Payment verification failed");
        }
      } else {
        debugPrint("Failed to verify payment");
      }
    } catch (e) {
      debugPrint("Error verifying payment: $e");
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
