// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, use_build_context_synchronously, prefer_is_empty, file_names, unused_catch_clause, unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:churchIn/helpers/encrypter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
// import 'package:new_churchlin/ProfileEditPage.dart';
// import 'package:new_churchlin/helpers/encrypter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'ProfileEditPage.dart';

class OfferingPage extends StatefulWidget {
  const OfferingPage({super.key});

  @override
  State<OfferingPage> createState() => _OfferingPageState();
}

class _OfferingPageState extends State<OfferingPage> {
  String _amnt = "\$10";
  String successtxt = "", errtxt = "";

  final TextEditingController _othercontroller = TextEditingController();
  bool isShow = false, _isreadonly = true;
  String dropdownvalue1 = 'Select Giving ->';
  var items1 = [
    'Select Giving ->',
    'Offering',
    'Tithe',
    'Pastor Appreciation',
    'Thanksgiving Offering',
    'Children\'s Church',
    'Others'
  ];
  String referred_by = 'Select Amount ->';
  var referrence = [
    'Select Amount ->',
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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventid =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("ddddddd" + eventid.toString());
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
        drawer: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.75, // 75% of screen will be occupied
            child: Drawer(
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
                    onTap: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();

                      var url = 'https://app.churchinapp.com/api/userprofile';
                      final Map<String, String> data = {
                        "user_id": sp.getInt("user_id").toString()
                      };
                      print("testing data$data");
                      /*  setState(()
        {
          vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
        });*/
                      Map<String, String> dat = {
                        "data": encryption(json.encode(data))
                      };
                      print("testing data" + dat.toString());
                      try {
                        final response = await http.post(Uri.parse(url),
                            body: json.encode(dat),
                            headers: {
                              "CONTENT-TYPE": "application/json"
                            }).timeout(const Duration(seconds: 20));
                        print("status code:" + response.statusCode.toString());
                        if (response.statusCode == 200) {
                          String a = decryption(response.body.toString().trim())
                                      .split("}")
                                      .length >
                                  2
                              ? decryption(response.body.toString().trim())
                                      .split("}")[0] +
                                  "}}"
                              : decryption(response.body.toString().trim())
                                      .split("}")[0] +
                                  "}";
                          Map<String, dynamic> result =
                              jsonDecode(a) as Map<String, dynamic>;

                          if (result["status"] == "success")
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfileEditPage(
                                            result["results"], eventid)));
                        } else {
                          Navigator.of(context).pop();
                          setState(() {
                            successtxt = "";
                            errtxt = response.statusCode.toString() +
                                " :Please Check your Internet Connection And data - 1";
                          });
                        }
                      } on TimeoutException catch (e) {
                        Navigator.of(context).pop();
                        setState(() {
                          errtxt =
                              "Please Check your Internet Connection And data - 2";
                          successtxt = "";
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.password,
                    ),
                    title: const Text('Change Password'),
                    onTap: () async {
                      Navigator.pushNamed(context, "/change",
                          arguments: eventid);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                    ),
                    title: const Text('Logout'),
                    onTap: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.setBool("stay_signed", false);
                      sp.setInt("user_id", 0);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login", (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            )),
        body: Center(
            child: _loading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
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
                              // dropdownColor: Colors.orange,
                              validator: (value) {
                                if (value == null ||
                                    value == "Select Giving ->") {
                                  return 'Please select Giving';
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
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  prefixIcon: const Icon(
                                    Icons.card_giftcard,
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
                                if (value == null ||
                                    value == "Select Amount ->") {
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
                                    _othercontroller.text =
                                        newValue.split("\$")[1];
                                    _amnt = newValue.split("\$")[1];
                                    _isreadonly = true;
                                  } else {
                                    _isreadonly = false;
                                  }
                                  referred_by = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  prefixIcon: const Icon(
                                    Icons.money,
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
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    prefixIcon: const Icon(
                                      Icons.money,
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
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length <= 0) {
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
                            (errtxt != "")
                                ? Text(
                                    errtxt,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                : (successtxt != "")
                                    ? Text(
                                        successtxt,
                                        style: TextStyle(
                                            color: Colors.purple.shade900,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
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

                                  SharedPreferences sp =
                                      await SharedPreferences.getInstance();

                                  sp.setString("offering_type", dropdownvalue1);
                                  sp.setString("amount", _amnt);
                                  // print(_offerings.toString());
                                  eventid["offer_type"] =
                                      dropdownvalue1.toString();
                                  eventid["offer_amt"] = _amnt.toString();
                                  print('Stripe ID: ${eventid["stripe_id"]}');
                                  print('Amount: $_amnt');
                                  print('Value: $dropdownvalue1');
                                  // Navigator.pushNamed(context, "/checkout",
                                  //     arguments: eventid);
                                  String url =
                                      'https://app.churchinapp.com/api/checkoutsession';
                                  final Map<String, String> data = {
                                    "amount": sp.getString("amount")!,
                                    "account_id": eventid["stripe_id"],
                                    "email": sp.getString("email")!,
                                    "offer_type": eventid["offer_type"],
                                    "offer_amt": eventid["offer_amt"],
                                    "entry_date": formatted,
                                    "entry_time": formatted1,
                                    "member_type": "5",
                                    'qrcode': eventid["value"],
                                    "user_id": sp.getInt("user_id").toString(),
                                    "quantity": "1"
                                  };
                                  print("testing data" + data.toString());
                                  Map<String, String> dat = {
                                    "data": encryption(json.encode(data))
                                  };
                                  print("testing data" + dat.toString());
                                  try {
                                    final response = await http.post(
                                        Uri.parse(url),
                                        body: json.encode({
                                          "data": encryption(json.encode(data))
                                        }),
                                        headers: {
                                          "CONTENT-TYPE": "application/json"
                                        }).timeout(const Duration(seconds: 20));
                                    print(response.statusCode.toString() +
                                        "ffhhhh");
                                    Map<String, dynamic> result = jsonDecode(
                                        decryption(response.body
                                                    .toString()
                                                    .trim())
                                                .split("}")[0] +
                                            "}") as Map<String, dynamic>;
                                    print("dec result:" + result.toString());
                                    // print("ddfg"+decryption(response.body.toString()));
                                    if (response.statusCode == 200) {
                                      Map<String, dynamic> result = jsonDecode(
                                          decryption(response.body
                                                      .toString()
                                                      .trim())
                                                  .split("}")[0] +
                                              "}") as Map<String, dynamic>;
                                      print("result:" + result.toString());
                                      var stripepaymenturl = result["url"];
                                      print(stripepaymenturl.toString());
                                      showToastMessage(
                                          'Redirecting to payment page');
                                      if (await stripepaymenturl.isNotEmpty) {
                                        final uri = Uri.parse(stripepaymenturl);
                                        Timer(const Duration(seconds: 2), () {
                                          launchUrl(uri,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        });
                                      } else {
                                        showToastMessage(
                                            "Failed to open the browser.");
                                      }
                                      //final uri = Uri.parse(stripepaymenturl);
                                      // await launchUrl(uri,mode: LaunchMode.externalApplication);
                                    } else {
                                      print(response.statusCode.toString() +
                                          "Vfvfv");
                                    }
                                  } on TimeoutException catch (e) {
                                    print(e.toString());
                                  } on Exception catch (e) {
                                    print(e.toString());
                                  }
                                  // String url =
                                  //     'https://app.churchinapp.com/api/checkout-session?mobile=true&account_id=$eventid["stripe_id"]&amount=$_amnt&title=$dropdownvalue1&quantity=1&currency=USD';
                                  // try {
                                  //   final uri = Uri.parse(url);

                                  //   await launchUrl(uri,
                                  //       mode: LaunchMode.externalApplication);
                                  // } on Exception catch (e) {
                                  //   print("Exception in launching the url");
                                  // }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                minimumSize: const Size(150, 40),
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius:
                                        BorderRadius.circular(10)), // NEW
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
                                            decoration:
                                                TextDecoration.underline,
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
                  )));
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

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // Duration of the toast message
      gravity: ToastGravity.NONE, // Position of the toast message
      timeInSecForIosWeb: 3, // Duration for iOS and web
      backgroundColor: Colors.orange.shade100, // Background color of the toast
      textColor: Colors.black, // Text color of the toast
      fontSize: 18.0, // Font size of the toast message
    );
  }
}
