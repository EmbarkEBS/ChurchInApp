// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_print, file_names, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:churchIn/helpers/encrypter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// import 'package:new_churchlin/helpers/encrypter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'utils/colors.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String successtxt = "", errtxt = "";
  String email = "";
  String password = "";
  bool stay_signed = false;
  final _formkey_2 = GlobalKey<FormState>();
  TextEditingController contrller1 = TextEditingController();
  TextEditingController contrller2 = TextEditingController();
  TextEditingController contrller3 = TextEditingController();
  TextEditingController contrller4 = TextEditingController();
  TextEditingController contrller5 = TextEditingController();
  TextEditingController contrller6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Form(
          key: _formkey_2,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
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
                    //SizedBox(width: 100,),
                  ]),

              //Image(image: AssetImage('assets/images/UA_170_Logo.png'),width: 200,),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _textFieldOTP(
                    first: true, last: false, controllerr: contrller1),
                _textFieldOTP(
                    first: false, last: false, controllerr: contrller2),
                _textFieldOTP(
                    first: false, last: false, controllerr: contrller3),
                _textFieldOTP(
                    first: false, last: false, controllerr: contrller4),
                /* _textFieldOTP(first: false, last: false, controllerr:
                        contrller5),
                        _textFieldOTP(first: false, last: true, controllerr:
                        contrller6)*/
              ]), //Checkbox
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
                          style: const TextStyle(
                              color: Colors.green,
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
              TextButton(
                onPressed: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  // ignore: unused_local_variable
                  var user_id = sp.containsKey("user_id")
                      ? sp.getInt("user_id")
                      : 0; //print(formatted);

                  var email = sp.getString("email");
                  print('Email: $email');
                  try {
                    var url = 'https://app.churchinapp.com/api/resendotp';
                    final Map<String, String> data = {
                      "email": email.toString()
                    };
                    final response = await http.post(Uri.parse(url),
                        body: json
                            .encode({"data": encryption(json.encode(data))}),
                        encoding: Encoding.getByName('utf-8'),
                        headers: {
                          "CONTENT-TYPE": "application/json"
                        }).timeout(const Duration(
                        seconds:
                            20)); /*setState(() {
      vaue.text=response.statusCode.toString();
    });*/
                    Map<String, String> dat = {
                      "data": encryption(json.encode(data))
                    };
                    print("testing data$dat");
                    if (response.statusCode == 200) {
                      Map<String, dynamic> result_1 = jsonDecode(
                          decryption(response.body.toString().trim())
                                  .split("}")[0] +
                              "}") as Map<String, dynamic>;

                      /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
                      if (result_1["status"] == "success") {
                        setState(() {
                          successtxt = result_1["message"];
                          errtxt = "";
                        });
                      } else {
                        setState(() {
                          errtxt = result_1["message"];
                          successtxt = "";
                        });
                      }
                    } else {
                      setState(() {
                        successtxt = "";
                        errtxt ==
                            "Please Check your Internet Connection And data - 1";
                      });
                    }
                  } on TimeoutException catch (_) {
                    setState(() {
                      successtxt = "";
                      errtxt =
                          "Please Check your Internet Connection And data - 2";
                    });
                    //return false;
                  } on Exception catch (e) {
                    setState(() {
                      errtxt = e.toString();
                      successtxt = "";
                    });
                  }
                },
                child: const Text(
                  "Resend OTP",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: black),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey_2.currentState!.validate()) {
                    DateTime now = DateTime.now();
                    DateFormat formatter = DateFormat('M/d/y');
                    String formatted = formatter.format(now);
                    DateFormat formatter1 = DateFormat('jm');
                    String formatted1 = formatter1.format(now);
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    var user_id = sp.containsKey("user_id")
                        ? sp.getInt("user_id")
                        : 0; //print(formatted);
                    var url = 'https://app.churchinapp.com/api/verifyotp';
                    var email = sp.getString("email");
                    final Map<String, String> data = {
                      "entry_date": formatted,
                      "entry_time": formatted1,
                      "email": email.toString(),
                      "otp": contrller1.text +
                          contrller2.text +
                          contrller3.text +
                          contrller4.text,
                      /*+contrller5.text+contrller6.text,*/ "user_id":
                          user_id!.toString()
                    };
                    print("testing data" + data.toString());
                    /* setState(()
          {
            vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
          });*/
                    try {
                      final response = await http.post(Uri.parse(url),
                          body: json
                              .encode({"data": encryption(json.encode(data))}),
                          encoding: Encoding.getByName('utf-8'),
                          headers: {
                            "CONTENT-TYPE": "application/json"
                          }).timeout(const Duration(seconds: 20));
                      /*setState(() {
      vaue.text=response.statusCode.toString();
    });*/
                      Map<String, String> dat = {
                        "data": encryption(json.encode(data))
                      };
                      print("testing data" + dat.toString());
                      if (response.statusCode == 200) {
                        Map<String, dynamic> result = jsonDecode(
                            decryption(response.body.toString().trim())
                                    .split("}")[0] +
                                "}") as Map<String, dynamic>;

                        /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
                        if (result["status"] == "success") {
                          Navigator.pushNamed(context, "/scanner");
                          print('success');
                        } else if (result["status"] == "expired") {
                          setState(() {
                            errtxt = "OTP Expired click resend OTP";
                            successtxt = "";
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
                          errtxt =
                              "Please Check your Internet Connection And data statusCode - 3" +
                                  response.statusCode.toString();
                        });
                        // Navigator.pushNamed(context, "/scanner");
                      } /*
    setState((){
    vaue.text="Please Check your Internet Connection And data";
    });*/
                    } on TimeoutException catch (_) {
                      setState(() {
                        successtxt = "";
                        errtxt =
                            "Please Check your Internet Connection And data - 4";
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
                child: const Text("Verify"),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _textFieldOTP(
      {bool? first, last, TextEditingController? controllerr}) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height / 12,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextFormField(
          controller: controllerr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter Valid OTP';
            }
            return null;
          },
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black54),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black54),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
