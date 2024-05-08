// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, avoid_print, unused_local_variable, unnecessary_null_comparison, unused_catch_clause, file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:new_churchlin/payment/CheckoutSessionResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class OfferingPage extends StatefulWidget {
  const OfferingPage({super.key});

  @override
  State<OfferingPage> createState() => _OfferingPageState();
}

class _OfferingPageState extends State<OfferingPage> {
  final String _offerings = "Offerings";
  String _amnt = "\$10";
  String successtxt = "", errtxt = "";

  final TextEditingController _othercontroller = TextEditingController();
  bool isShow = false, _isreadonly = true;
  String dropdownvalue1 = 'Offerings';
  var items1 = [
    'Offerings',
    'Tithe',
    'Pastors Appreciation',
    'Thanks Giving',
    'Children Church',
  ];
  String referred_by = 'Select Amount';
  var referrence = [
    'Select Amount',
    '\$10',
    '\$25',
    '\$50',
    '\$100',
    '\$250',
    '\$500',
    '\$1000',
    '\$2500',
    'Other'
  ];
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final eventid =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("ddddddd" + eventid.toString());
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //centerTitle: true,
          title: const Text(
            'ChurchIn',
          ),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/menu", arguments: eventid);
                },
                icon: const Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.white,
                )),
          ],
        ),
        drawer: Drawer(
          width: 250,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: SvgPicture.asset(
                    "assets/images/newlogo.svg",
                    width: 50,
                    height: 50,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_circle_rounded,
                ),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //FlutterLogo(size: 100,),
                        SvgPicture.asset(
                          "assets/images/newlogo.svg",
                          width: 50,
                          height: 50,
                        ),
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Donation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    value: dropdownvalue1,
                    validator: (value) {
                      if (value == null || value == "Offerings") {
                        return 'Please select offerings';
                      }
                      return null;
                    },
                    items: items1.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue1 = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.orange,
                        ),
                        fillColor: Colors.orange.shade50,
                        filled: true,
                        hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.deepOrange.shade200,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.red.shade200,
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.red.shade200,
                            width: 1.0,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    value: referred_by,
                    validator: (value) {
                      if (value == null || value == "Select Amount") {
                        return 'Please select Amount';
                      }
                      return null;
                    },
                    items: referrence.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _amnt = newValue!;
                        if (_amnt != "Other") {
                          _othercontroller.text = newValue.split("\$")[1];
                          _isreadonly = true;
                        } else {
                          _isreadonly = false;
                        }
                        referred_by = newValue;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.orange,
                        ),
                        fillColor: Colors.orange.shade50,
                        filled: true,
                        hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.deepOrange.shade200,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.red.shade200,
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.red.shade200,
                            width: 1.0,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      controller: _othercontroller,
                      readOnly: _isreadonly,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.orange,
                          ),
                          //labelText: "Email",
                          hintText: "Enter Amount",
                          fillColor: Colors.orange.shade50,
                          filled: true,
                          //labelStyle: TextStyle(fontSize: 15,color: Colors.blue),
                          hintStyle: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.deepOrange.shade200,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.red.shade200,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.red.shade200,
                              width: 1.0,
                            ),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _amnt = value;
                        });
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  (errtxt != "" && errtxt != null)
                      ? Text(
                          errtxt,
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        )
                      : (successtxt != "")
                          ? Text(
                              successtxt,
                              style: TextStyle(
                                  color: Colors.purple.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            )
                          : const Text(
                              "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        DateTime now = DateTime.now();
                        DateFormat formatter = DateFormat('M/d/y');
                        String formatted = formatter.format(now);
                        DateFormat formatter1 = DateFormat('jm');
                        String formatted1 = formatter1.format(now);
                        //print(formatted);
                        var url =
                            'https://app.churchinapp.com/api/checkout-session?mobile=true&account_id=$eventid["stripe_id"]&amount=$_amnt&title=$dropdownvalue1&quantity=1&currency=USD';
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        print('Stripe ID: ${eventid["stripe_id"]}');
                        sp.setString("offering_type", _offerings);
                        sp.setString("amount", _amnt);
                        try {
                          final response = await http.post(Uri.parse(url),
                              encoding: Encoding.getByName('utf-8'),
                              headers: {
                                "CONTENT-TYPE": "application/json"
                              }).timeout(const Duration(seconds: 20));
                          print('Body: ${response.body}');
                          if (response.statusCode == 200) {
                            Map<String, dynamic> body =
                                jsonDecode(response.body);
                            CheckoutSessionResponse session_info =
                                CheckoutSessionResponse(body['session']);
                            setState(() {
                              successtxt = session_info.session.toString();
                            });
                          } else {
                            setState(() {
                              successtxt = "";
                              errtxt =
                                  "Please Check your Internet Connection And data";
                            });
                          }
                        } on TimeoutException catch (_) {
                          setState(() {
                            successtxt = "";
                            errtxt =
                                "Please Check your Internet Connection And data";
                          });
                          //return false;
                        } on Exception catch (e) {
                          setState(() {
                            errtxt = e.toString();
                            successtxt = "";
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(150, 40),
                      shape: RoundedRectangleBorder(
                          //to set border radius to button
                          borderRadius: BorderRadius.circular(10)), // NEW
                    ),
                    child: const Text(
                      "Payment",
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                _launchURL();
                              },
                              child: const Text(
                                "Privacy Policy",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              )),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _launchURL() async {
    const url = 'https://app.churchinapp.com/privacypolicy';
    try {
      final uri = Uri.parse(url);

      await launchUrl(uri);
    } on Exception catch (e) {
      print("Exception in launching the url");
    }
  }
}
