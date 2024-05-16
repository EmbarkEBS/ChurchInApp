// ignore_for_file: avoid_print, non_constant_identifier_names, unused_catch_clause, prefer_interpolation_to_compose_strings, use_build_context_synchronously, unnecessary_null_comparison, file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ProfileEditPage.dart';
import 'helpers/encrypter.dart';
import 'helpers/helper.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String successtxt = "", errtxt = "";
  bool _loading = true;
  int? user_id = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });
    checkLoggedIn();
  }

  void checkLoggedIn() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    user_id = sp.containsKey("user_id") ? sp.getInt("user_id") : 0;
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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> eventid =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          //centerTitle: true,
          title: const Text(
            'ChurchIn',
          ),
          backgroundColor: Colors.orange,
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
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();

                  var url = 'https://app.churchinapp.com/api/userprofile';
                  final Map<String, String> data = {
                    "user_id": sp.getInt("user_id").toString()
                  };
                  print("testing data$data");

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

                      if (result["status"] == "success") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileEditPage(
                                        result["results"], eventid)));
                      }
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
                  Navigator.pushNamed(context, "/change", arguments: eventid);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text('Logout'),
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setBool("stay_signed", false);
                  sp.setInt("user_id", 0);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/login", (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                      Container(
                        height: 700,
                        color: Colors.white,
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //FlutterLogo(size: 100,),
                                SvgPicture.asset(
                                  "assets/images/alfanewlogo.svg",
                                  width: 200,
                                  height: 250,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (errtxt != "" && errtxt != null)
                                    ? Text(errtxt,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textAlign: TextAlign.center)
                                    : (successtxt != "")
                                        ? Text(successtxt,
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textAlign: TextAlign.center)
                                        : const Text("",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textAlign: TextAlign.center),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                    minimumSize: const Size(250, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () async {
                                    Helper.type = "1";
                                    DateTime now = DateTime.now();
                                    DateFormat formatter = DateFormat('M/d/y');
                                    String formatted = formatter.format(now);
                                    DateFormat formatter1 = DateFormat('jm');
                                    String formatted1 = formatter1.format(now);
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    var url =
                                        'https://app.churchinapp.com/api/currentmember';
                                    final Map<String, String> data = {
                                      "entry_date": formatted,
                                      "entry_time": formatted1,
                                      'qrcode': eventid["value"],
                                      "member_type": Helper.type.toString(),
                                      "user_id": sp.getInt("user_id").toString()
                                    };
                                    print("testing data" + data.toString());
                                    Map<String, String> dat = {
                                      "data": encryption(json.encode(data))
                                    };
                                    print("testing data" + dat.toString());
                                    try {
                                      final response = await http.post(
                                          Uri.parse(url),
                                          body: json.encode(dat),
                                          headers: {
                                            "CONTENT-TYPE": "application/json"
                                          }).timeout(
                                          const Duration(seconds: 20));
                                      print("status code:" +
                                          response.statusCode.toString());
                                      if (response.statusCode == 200) {
                                        Map<String, dynamic> result =
                                            jsonDecode(decryption(response.body
                                                        .toString()
                                                        .trim())
                                                    .split("}")[0] +
                                                "}") as Map<String, dynamic>;
                                        if (result["status"] == "success") {
                                          setState(() {
                                            successtxt = result["message"];
                                            errtxt = "";
                                          });
                                        } else {
                                          setState(() {
                                            errtxt = result["message"];
                                            successtxt = "";
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          successtxt = "";
                                          errtxt = response.statusCode
                                                  .toString() +
                                              " :Please Check your Internet Connection And data - 3";
                                        });
                                      }
                                    } on TimeoutException catch (e) {
                                      setState(() {
                                        errtxt =
                                            "Please Check your Internet Connection And data - 4";
                                        successtxt = "";
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "First Timer",
                                    style: TextStyle(
                                        color: Colors.white,
                                        // fontWeight: FontWeight.w300,
                                        fontSize: 16),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Helper.type = "3";
                                    DateTime now = DateTime.now();
                                    DateFormat formatter = DateFormat('M/d/y');
                                    String formatted = formatter.format(now);
                                    DateFormat formatter1 = DateFormat('jm');
                                    String formatted1 = formatter1.format(now);
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();

                                    var url =
                                        'https://app.churchinapp.com/api/currentmember';
                                    final Map<String, String> data = {
                                      "entry_date": formatted,
                                      "entry_time": formatted1,
                                      'qrcode': eventid["value"],
                                      "member_type": Helper.type.toString(),
                                      "user_id": sp.getInt("user_id").toString()
                                    };
                                    print("testing data" + data.toString());
                                    Map<String, String> dat = {
                                      "data": encryption(json.encode(data))
                                    };
                                    print("testing data" + dat.toString());
                                    try {
                                      final response = await http.post(
                                          Uri.parse(url),
                                          body: json.encode(dat),
                                          headers: {
                                            "CONTENT-TYPE": "application/json"
                                          }).timeout(
                                          const Duration(seconds: 20));
                                      print("status code:" +
                                          response.statusCode.toString());
                                      if (response.statusCode == 200) {
                                        Map<String, dynamic> result =
                                            jsonDecode(decryption(response.body
                                                        .toString()
                                                        .trim())
                                                    .split("}")[0] +
                                                "}") as Map<String, dynamic>;

                                        if (result["status"] == "success") {
                                          setState(() {
                                            successtxt = result["message"];
                                            errtxt = "";
                                          });
                                        } else {
                                          setState(() {
                                            errtxt = result["message"];
                                            successtxt = "";
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          successtxt = "";
                                          errtxt = response.statusCode
                                                  .toString() +
                                              " :Please Check your Internet Connection And data - 5";
                                        });
                                      }
                                    } on TimeoutException catch (e) {
                                      setState(() {
                                        errtxt =
                                            "Please Check your Internet Connection And data - 6";
                                        successtxt = "";
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: const Size(250, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: const Text(
                                    "Current member",
                                    style: TextStyle(
                                        color: Colors.white,
                                        // fontWeight: FontWeight.w300,
                                        fontSize: 16),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Helper.type = "2";

                                    Navigator.pushNamed(context, "/register",
                                        arguments: eventid);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff7E56C8),
                                    minimumSize: const Size(250, 50),
                                    shape: RoundedRectangleBorder(
                                        //to set border radius to button
                                        borderRadius:
                                            BorderRadius.circular(10)), // NEW
                                  ),
                                  child: const Text("Sign-in for Children",
                                      style: TextStyle(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.w300,
                                          fontSize: 16)),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Helper.type = "4";
                                    Navigator.pushNamed(context, "/register",
                                        arguments: eventid);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange.shade500,
                                    minimumSize: const Size(250, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: const Text("Event Entry",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          // fontWeight: FontWeight.w300
                                          )),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    DateTime now = DateTime.now();
                                    DateFormat formatter = DateFormat('M/d/y');
                                    String formatted = formatter.format(now);
                                    DateFormat formatter1 = DateFormat('jm');
                                    String formatted1 = formatter1.format(now);
                                    //print(formatted);
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    var url =
                                        'https://app.churchinapp.com/api/adminaccountinfo';
                                    final Map<String, String> data = {
                                      "entry_date": formatted,
                                      "entry_time": formatted1,
                                      'qrcode': eventid["value"],
                                      "user_id": sp.getInt("user_id").toString()
                                    };
                                    print("testing data" + data.toString());
                                    print(url.toString());

                                    Map<String, String> dat = {
                                      "data": encryption(json.encode(data))
                                    };
                                    print("testing data" + dat.toString());
                                    try {
                                      final response = await http.post(
                                          Uri.parse(url),
                                          body: json.encode(dat),
                                          headers: {
                                            "CONTENT-TYPE": "application/json"
                                          }).timeout(
                                          const Duration(seconds: 20));
                                      print("Status code:" +
                                          response.statusCode.toString());

                                      if (response.statusCode == 200) {
                                        Map<String, dynamic> result =
                                            jsonDecode(decryption(response.body
                                                        .toString()
                                                        .trim())
                                                    .split("}")[0] +
                                                "}") as Map<String, dynamic>;
                                        if (result["status"] == "success") {
                                          setState(() {
                                            successtxt =
                                                "Redirecting to Offerings";
                                            errtxt = "";
                                            eventid["stripe_id"] =
                                                result["stripeconnect_id"];
                                            Navigator.pushNamed(
                                                context, "/offerings",
                                                arguments: eventid);
                                          });
                                        } else {
                                          setState(() {
                                            errtxt = result["message"];
                                            successtxt = "";
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          successtxt = "";
                                          errtxt = response.statusCode
                                                  .toString() +
                                              " :Please Check your Internet Connection And data - 7";
                                        });
                                      }
                                    } on TimeoutException catch (e) {
                                      setState(() {
                                        errtxt =
                                            "Please Check your Internet Connection And data - 8";
                                        successtxt = "";
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.orangeAccent.shade200,
                                    minimumSize: const Size(250, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: const Text("Giving/Gift",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          // fontWeight: FontWeight.w300
                                          )),
                                ),
                              ],
                            ),
                          ],
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
                    ])),
        ));
  }
}
