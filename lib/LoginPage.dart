// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, file_names

import 'dart:async';
import 'dart:convert';

// import 'package:new_churchlin/utils/validator.dart';
import 'package:churchIn/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:churchIn/utils/valiidator.dart';

import 'helpers/encrypter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String successtxt = "", errtxt = "";
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  String email = "";
  String password = "";
  // ignore: non_constant_identifier_names
  bool stay_signed = false;
  final _formkey_2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Form(
          key: _formkey_2,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 100,
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
                'Login',
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
              TextFormField(
                controller: _emailcontroller,
                validator: (value) => FieldValidator.validateEmail(value!),
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    prefixIcon: const Icon(Icons.email, color: Colors.orange),
                    //labelText: "Full Name",
                    hintText: "Email",
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
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _passwordcontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    prefixIcon:
                        const Icon(Icons.password, color: Colors.orange),
                    //labelText: "Full Name",
                    hintText: "Password",
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
                obscureText: true,
                obscuringCharacter: "*",
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/forgot");
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 14),
                      )),
                ],
              ),
              const SizedBox(
                height: 0,
              ),
              Row(
                children: [
                  Checkbox(
                    value: stay_signed,
                    onChanged: (value) {
                      setState(() {
                        stay_signed = value!;
                      });
                    },
                  ),
                  const Text(
                    "Stay Signed",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )
                ],
              ), //Checkbox
              const SizedBox(
                height: 10,
              ),

              (errtxt != "" && errtxt != null)
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
                height: 10,
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formkey_2.currentState!.validate()) {
                    DateTime now = DateTime.now();
                    DateFormat formatter = DateFormat('M/d/y');
                    String formatted = formatter.format(now);
                    DateFormat formatter1 = DateFormat('jm');
                    String formatted1 = formatter1.format(now);
                    //print(formatted);
                    var url = 'https://app.churchinapp.com/api/memberlogin';
                    final Map<String, String> data = {
                      "entry_date": formatted,
                      "entry_time": formatted1,
                      "password": password,
                      "email": email
                    };
                    print("testing data$data");
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
                          }).timeout(const Duration(
                          seconds:
                              20)); /*setState(() {
      vaue.text=response.statusCode.toString();
    });*/
                      Map<String, String> dat = {
                        "data": encryption(json.encode(data))
                      };
                      print("testing data$dat");
                      print("testing data${response.statusCode}");
                      if (response.statusCode == 200) {
                        Map<String, dynamic> result = jsonDecode(
                            decryption(response.body.toString().trim())
                                    .split("}")[0] +
                                "}") as Map<String, dynamic>;
                        print(result.toString());
                        /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
                        if (result["status"] == "success") {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          // if(stay_signed){
                          sp.setInt("user_id", result["user_id"]);
                          sp.setString("email", email);
                          //}
                          sp.setBool("stay_signed", stay_signed);
                          setState(() {
                            successtxt = "LoggedIn Successfully";
                            errtxt = "";
                            _passwordcontroller.clear();
                            _emailcontroller.clear();
                          });
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            setState(() {
                              Navigator.pushNamed(context, "/scanner");
                            });
                          });
                        } else if (result["status"] == "not_verified") {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          // if(stay_signed){
                          sp.setInt("user_id", result["user_id"]);
                          sp.setString("email", email);
                          //}
                          sp.setBool("stay_signed", stay_signed);
                          sp.setBool("resend", false);
                          setState(() {
                            successtxt =
                                "You Already Registered But not verified";
                            errtxt = "";
                            _passwordcontroller.clear();
                            _emailcontroller.clear();
                          });
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            setState(() {
                              Navigator.pushNamed(context, "/verification");
                            });
                          });
                        } else if (result["status"] == "expired") {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          // if(stay_signed){
                          sp.setInt("user_id", result["user_id"]);
                          sp.setString("email", email);
                          //}
                          sp.setBool("stay_signed", stay_signed);
                          sp.setBool("resend", true);
                          try {
                            var url =
                                'https://app.churchinapp.com/api/resendotp';
                            final Map<String, String> data = {"email": email};
                            final response = await http.post(Uri.parse(url),
                                body: json.encode(
                                    {"data": encryption(json.encode(data))}),
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
                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  setState(() {
                                    Navigator.pushNamed(
                                        context, "/verification");
                                  });
                                });
                              } else {
                                setState(() {
                                  errtxt = result_1["message"];
                                  successtxt = "";
                                  _passwordcontroller.clear();
                                  _emailcontroller.clear();
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
                        } else {
                          setState(() {
                            successtxt = "";
                            errtxt = result["message"];
                          });
                          //Navigator.pushNamed(context, "/scanner");
                        }
                      } else {
                        setState(() {
                          successtxt = "";
                          errtxt ==
                              "Please Check your Internet Connection And data -  3";
                        });
                      }
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
                child: const Text(
                  "Login",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text(
                      "Register Now",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
              /*ElevatedButton(
        onPressed: (){
          Navigator.pushNamed(context, "/signup");
        },
        child: Text("Register Now"),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        minimumSize: Size(150, 40),
        shape: RoundedRectangleBorder( //to set border radius to button
            borderRadius: BorderRadius.circular(10)
        ),// NEW
      ),
    ),*/
              /*Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextButton(onPressed: (){
        Navigator.pushNamed(context, "/signup");
      }, child: Text("Register Now",
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: black),
      ),),
      SizedBox(
        width: 25,
      ),
     TextButton(onPressed: (){
        Navigator.pushNamed(context, "/forgot");
      }, child: Text("Forgot Password",
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: black),
      ),)

    ],
    )*/
            ],
          ),
        ),
      )),
    );
  }
}
