// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously, unused_catch_clause, unnecessary_null_comparison, file_names, empty_catches

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ProfileEditPage.dart';
import 'helpers/encrypter.dart';

class ChangePwdPage extends StatefulWidget {
  const ChangePwdPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<ChangePwdPage> createState() => _ChangePwdPageState();
}

class _ChangePwdPageState extends State<ChangePwdPage> {
  String successtxt = "", errtxt = "";
  final TextEditingController _oldcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  String cpwd = "";
  String opwd = "";
  String password = "";
  final _formkey_2 = GlobalKey<FormState>();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventid =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("ddddddd$eventid");
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
                  /*  setState(()
        {
          vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
        });*/
                  Map<String, String> dat = {
                    "data": encryption(json.encode(data))
                  };
                  print("testing data$dat");
                  try {
                    final response = await http.post(Uri.parse(url),
                        body: json.encode(dat),
                        headers: {
                          "CONTENT-TYPE": "application/json"
                        }).timeout(const Duration(
                        seconds:
                            20)); /*setState(() {
    vaue.text=decryption(response.body.toString().trim()).split("}")[0]+"}hai";
    });*/
                    print("status code:${response.statusCode}");
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

                      // Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}}") as Map<String,dynamic>;
                      if (result["status"] == "success") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileEditPage(
                                        result["results"], eventid)));
                      }
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
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
                  } on Exception catch (e) {}
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.password,
                ),
                title: const Text('Change Password'),
                onTap: () async {
                  /* SharedPreferences sp=await SharedPreferences.getInstance();
                  sp.setBool("stay_signed",false);
                  sp.setInt("user_id",0);
                  Navigator.of(context).pushNamedAndRemoveUntil("/login",(route) => route.isFirst);*/
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
                    child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Form(
                      key: _formkey_2,
                      child: Column(
                        children: <Widget>[
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
                            'Change Password',
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
                            controller: _oldcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter old password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(Icons.password,
                                    color: Colors.orange),
                                //labelText: "Full Name",
                                hintText: "Old Password",
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
                                opwd = value;
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
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(Icons.password,
                                    color: Colors.orange),
                                //labelText: "Full Name",
                                hintText: "New Password",
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
                            height: 15,
                          ),
                          TextFormField(
                            controller: _confirmpasswordcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid password';
                              } else if (value != password) {
                                return 'Password Not matching';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(Icons.password,
                                    color: Colors.orange),
                                //labelText: "Full Name",
                                hintText: "Confirm New Password",
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
                                cpwd = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          (errtxt != "" && errtxt != null)
                              ? Text(
                                  errtxt,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
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

                          ElevatedButton(
                            onPressed: () async {
                              if (_formkey_2.currentState!.validate()) {
                                var url =
                                    'https://app.churchinapp.com/api/changepassword';
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                var email = sp.getString("email");
                                final Map<String, String> data = {
                                  "old_password": opwd,
                                  "email": email.toString(),
                                  "new_password": cpwd
                                };
                                print("testing data" + data.toString());
                                Map<String, String> dat = {
                                  "data": encryption(json.encode(data))
                                };
                                print("testing data" + dat.toString());
                                /* setState(()
          {
            vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
          });*/
                                try {
                                  final response = await http.post(
                                      Uri.parse(url),
                                      body: json.encode({
                                        "data": encryption(json.encode(data))
                                      }),
                                      encoding: Encoding.getByName('utf-8'),
                                      headers: {
                                        "CONTENT-TYPE": "application/json"
                                      }).timeout(const Duration(
                                      seconds:
                                          20)); /*setState(() {
      vaue.text=response.statusCode.toString();
    });*/

                                  print("testing data" +
                                      response.statusCode.toString());
                                  if (response.statusCode == 200) {
                                    Map<String, dynamic> result = jsonDecode(
                                        decryption(response.body
                                                    .toString()
                                                    .trim())
                                                .split("}")[0] +
                                            "}") as Map<String, dynamic>;
                                    print(result.toString());
                                    /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
                                    if (result["status"] == "success") {
                                      setState(() {
                                        successtxt = result["message"];
                                        errtxt = "";
                                        _passwordcontroller.clear();
                                        _oldcontroller.clear();
                                        _confirmpasswordcontroller.clear();
                                      });
                                      SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      sp.setBool("stay_signed", false);
                                      sp.setInt("user_id", 0);
                                      // Navigator.of(context).pushNamedAndRemoveUntil("/login",(route) => route.isFirst);
                                      Future.delayed(
                                          const Duration(milliseconds: 1000),
                                          () {
                                        setState(() {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil("/login",
                                                  (route) => route.isFirst);
                                        });
                                      });
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
                                          response.statusCode.toString() +
                                              "Please Check your Internet Connection And data - 3";
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
                                  borderRadius:
                                      BorderRadius.circular(10)), // NEW
                            ),
                            child: const Text(
                              "Change Password",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))));
  }
}
