// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, use_build_context_synchronously, file_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_sdk_plus/stripe_sdk.dart';
import 'package:stripe_sdk_plus/stripe_sdk_ui.dart';
import 'helpers/encrypter.dart';

// String stripePublicKey =
//     'pk_live_51Ng67tDQl3PE9TbWyjcnvsHu5WWLI6U58zj8z8XOgYFq9c7X9p8bku2SO4lY1WxF6kvxErbqVyudLoQKrmZYcHT600LJQQAqrP';
//String stripePublicKey = 'pk_test_51Ng67tDQl3PE9TbWpta2oL2VNnUcvoWTrJg2Qld15zzotIppyxZTPA42zfJRc9A07Z2GjGIq5l4den3qM21vhGKs00L9VWLNTk';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final String postCreateIntentURL = "https:/yourserver/postPaymentIntent";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();

  Map<String, dynamic> eventid = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    eventid =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final StripeApi stripe = StripeApi(
      "pk_live_51Ng67tDQl3PE9TbWyjcnvsHu5WWLI6U58zj8z8XOgYFq9c7X9p8bku2SO4lY1WxF6kvxErbqVyudLoQKrmZYcHT600LJQQAqrP", //Your Publishable Key
      stripeAccount: eventid[
          "stripe_id"], //Merchant Connected Account ID. It is the same ID set on server-side.
      // returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Stripe Payment"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: Column(
              children: [
                CardForm(formKey: formKey, card: card),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(150, 40),
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(10)), // NEW
                  ),
                  onPressed: () {
                    formKey.currentState!.validate();
                    formKey.currentState!.save();

                    buy(context, stripe);
                  },
                  child: const Text(
                    'Pay Now',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void buy(context, StripeApi stripe) async {
    final StripeCard stripeCard = card;
    final Future<String> customerEmail = getCustomerEmail();

    if (!stripeCard.validateCVC()) {
      showAlertDialog(context, "Error", "CVC not valid.");
      return;
    }
    if (!stripeCard.validateDate()) {
      showAlertDialog(context, "Error", "Date not valid.");
      return;
    }
    if (!stripeCard.validateNumber()) {
      showAlertDialog(context, "Error", "Number not valid.");
      return;
    }

    Map<String, dynamic> paymentIntentRes =
        await createPaymentIntent(stripeCard, customerEmail.toString(), stripe);
    String clientSecret = paymentIntentRes['client_secret'];
    String paymentMethodId = paymentIntentRes['payment_method'];
    String status = paymentIntentRes['status'];
    print("bbbbbb $paymentMethodId,$status");
    if (status == 'requires_action') {
      //3D secure is enable in this card
      paymentIntentRes =
          await confirmPayment3DSecure(clientSecret, paymentMethodId, stripe);
    }

    if (paymentIntentRes['status'] != 'succeeded') {
      showAlertDialog(context, "Warning", "Canceled Transaction.");
      return;
    }

    if (paymentIntentRes['status'] == 'succeeded') {
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('M/d/y');
      String formatted = formatter.format(now);
      DateFormat formatter1 = DateFormat('jm');
      String formatted1 = formatter1.format(now);
      //print(formatted);
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = 'https://app.churchinapp.com/api/givinggift';
      final Map<String, String> data = {
        "offer_type": eventid["offer_type"],
        "offer_amt": eventid["offer_amt"],
        "entry_date": formatted,
        "entry_time": formatted1,
        "member_type": "5",
        'qrcode': eventid["value"],
        "user_id": sp.getInt("user_id").toString(),
        "payment_status": paymentIntentRes['status'],
        "payment_id": paymentIntentRes['payment_method']
      };
      print("testing data$data");
      print(url.toString());
      Map<String, String> dat = {"data": encryption(json.encode(data))};
      print("testing data$dat");
      try {
        final response = await http.post(Uri.parse(url), body: dat, headers: {
          "CONTENT-TYPE": "application/json"
        }).timeout(const Duration(seconds: 20));
        print("Status code:" + response.statusCode.toString());

        //Navigator.pushNamed(context, "/offerings",arguments: eventid);
        if (response.statusCode == 200) {
          Map<String, dynamic> result = jsonDecode(
              decryption(response.body.toString().trim()).split("}")[0] +
                  "}") as Map<String, dynamic>;
          if (result["status"] == "success") {
            showAlertDialog(context, "Success", "Thanks for your giving!");
          } else {
            showAlertDialog(context, "Failed", 'Failed ${result["message"]}');
          }
        } else {
          showAlertDialog(
              context, "Failed", 'Failed 3${response.statusCode.toString()}');
        }
      } on TimeoutException catch (e) {
        showAlertDialog(context, "Failed", 'Failed 1${e.toString()}');
      } on Exception catch (e) {
        showAlertDialog(context, "Failed", 'Failed2 ${e.toString()}');
      }

      return;
    }
    showAlertDialog(
        context, "Warning", "Transaction rejected.\nSomething went wrong");
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      StripeCard stripeCard, String customerEmail, StripeApi stripe) async {
    String clientSecret;
    Map<String, dynamic> paymentIntentRes = <String, dynamic>{}, paymentMethod;
    try {
      paymentMethod = await stripe.createPaymentMethodFromCard(card);
      // showAlertDialog(context, "Error", "Failed5 ");

      print("payment method: " + paymentMethod.toString());
      clientSecret =
          await postCreatePaymentIntent(customerEmail, paymentMethod['id']);
      // showAlertDialog(context, "Error", "Failed6 ");
      print("clientSecret: " + clientSecret.toString());
      paymentIntentRes = await stripe.retrievePaymentIntent(clientSecret);
      print("paymentIntentRes: " + paymentIntentRes.toString());
      // showAlertDialog(context, "Error", "Failed7 ");
    } catch (e) {
      // print("ERROR_CreatePaymentIntentAndSubmit: $e");
      showAlertDialog(context, "Error", "Failed4 $e");
    }
    // print(paymentIntentRes.toString());
    return paymentIntentRes;
  }

  Future<String> postCreatePaymentIntent(
      String email, String paymentMethodId) async {
    String clientSecret = "";

    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = 'https://app.churchinapp.com/api/checkoutsession';
    final Map<String, String> data = {
      "amount": sp.getString("amount")!,
      "account_id": eventid["stripe_id"],
      'payment_id': paymentMethodId,
      "member_type": "5",
      "email": sp.getString("email")!,
      "quantity": "1"
    };
    print("testing data" + data.toString());

    // Map<String, String> dat = {"data": encryption(json.encode(data))};
    // print("testing data" + dat.toString());
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({"data": encryption(json.encode(data))}),
          headers: {
            "CONTENT-TYPE": "application/json"
          }).timeout(const Duration(seconds: 20));

      print(response.statusCode.toString() + "ffhhhh");
      print(response.body.toString() + "ffhhhh");

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(
                decryption(response.body.toString().trim()).split("}")[0] + "}")
            as Map<String, dynamic>;

        clientSecret = result["client_secret"];
        print('Secert $clientSecret');
      } else {
        print(response.statusCode.toString() + "Vfvfv");
      }
    } on TimeoutException catch (e) {
      print(e.toString());
    } on Exception catch (e) {
      print(e.toString());
    }

    return clientSecret;
  }

  Future<Map<String, dynamic>> confirmPayment3DSecure(
      String clientSecret, String paymentMethodId, StripeApi stripe) async {
    Map<String, dynamic> paymentIntentRes_3dSecure = <String, dynamic>{};
    try {
      Stripe stripekey = Stripe(
          'pk_test_51Ng67tDQl3PE9TbWpta2oL2VNnUcvoWTrJg2Qld15zzotIppyxZTPA42zfJRc9A07Z2GjGIq5l4den3qM21vhGKs00L9VWLNTk');
      await stripekey.confirmPayment(clientSecret, context);
      paymentIntentRes_3dSecure =
          await stripe.retrievePaymentIntent(clientSecret);
    } catch (e) {
      print("ERROR_ConfirmPayment3DSecure: $e");
      showAlertDialog(context, "Error", "Something went wrong.");
    }
    print(paymentIntentRes_3dSecure.toString());
    return paymentIntentRes_3dSecure;
  }

  Future<String> getCustomerEmail() async {
    String customerEmail = "";
    // email = "ebs.sandbox@gmail.com";
    SharedPreferences sp = await SharedPreferences.getInstance();
    print('Email: ${sp.getString("email")}');
    customerEmail = sp.getString("email") ?? "ebs.sandbox@gmail.com";
    // email = customerEmail;
    return customerEmail;
  }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.popUntil(
                  context, ModalRoute.withName("/offerings")), // dismiss dialog
            ),
          ],
        );
      },
    );
  }
}
