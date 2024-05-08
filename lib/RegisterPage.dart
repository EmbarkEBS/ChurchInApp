// ignore_for_file: avoid_print, non_constant_identifier_names, use_build_context_synchronously, unused_field, unused_catch_clause, unnecessary_null_comparison, file_names, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:new_churchlin/ProfileEditPage.dart';
import 'package:new_churchlin/helpers/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helpers/encrypter.dart';
import 'utils/validator.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _gender = "Gender";
  String successtxt = "", errtxt = "";

  final TextEditingController _fullnamecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _citycontroller = TextEditingController();
  final TextEditingController _statecontroller = TextEditingController();
  final TextEditingController _countrycontroller = TextEditingController();
  final TextEditingController _postalcodecontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _occupationcontroller = TextEditingController();
  final TextEditingController _teachercontroller = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController anniversaryInput = TextEditingController();
  String imageurl = "";
  String fullname = "";
  String address = "";
  String email = "";
  String city = "";
  String postalcode = "";
  String state_1 = "";
  String country = "";
  String phone = "";
  String occupation = "";
  bool isShow = false;
  String dropdownvalue1 = 'Gender';
  var items1 = [
    'Gender',
    'Male',
    'Female',
  ];
  String referred_by = 'Referred By';
  var referrence = [
    'Referred By',
    'Invited By Friend',
    'Google',
    'Youtube',
    'Facebook',
    'Instagram',
  ];
  String teacher = "";
  String classgroup = 'Select Age(In Years)';
  var items4 = [
    'Select Age(In Years)',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    //'Optional',
    /* '9-12 years',
    '13-18 years',
    '19-25 years',*/
  ];
  String marital = '-';
  var items2 = [
    '-',
    'Married',
    'Unmarried',
  ];
  String children = '0';
  var items3 = [
    '0',
    '1',
    '2',
  ];
  // String _selectedType = "-";
  // final _formkey = GlobalKey<FormState>();
  final _formkey_1 = GlobalKey<FormState>();
  // final _formkey_2 = GlobalKey<FormState>();
  final _formkey_4 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final eventid =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("ddddddd$eventid");
    if (Helper.type == "2") {
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
                        errtxt =
                            "${response.statusCode} :Please Check your Internet Connection And data";
                      });
                    }
                  } on TimeoutException catch (e) {
                    Navigator.of(context).pop();
                    setState(() {
                      errtxt = "Please Check your Internet Connection And data";
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
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formkey_1,
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
                          /*IconButton(
                        onPressed: (){
                        Navigator.pushNamed(context, "/menu",arguments: eventid);
                        },
                        icon: Icon(
                        Icons.home, size: 30,color: Colors.orange,
                        )
                        ),*/
                        ]),

                    //Image(image: AssetImage('assets/images/UA_170_Logo.png'),width: 200,),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Children Entry',
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
                      controller: _fullnamecontroller,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          prefixIcon: const Icon(Icons.account_circle_rounded,
                              color: Colors.orange),
                          //labelText: "Full Name",
                          hintText: "Full Name",
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
                      /* validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter name';
    }
    return null;
    },*/
                      validator: (value) =>
                          FieldValidator.validateFullname(value!),
                      onChanged: (value) {
                        setState(() {
                          fullname = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField(
                      value: _gender,
                      validator: (value) {
                        if (value == null || value == "Gender") {
                          return 'Please select Gender';
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
                          _gender = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.orange),
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
                      controller: _teachercontroller,
                      validator: (value) =>
                          FieldValidator.validateTeacherName(value!),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.orange),
                          //labelText: "Full Name",
                          hintText: "Teacher Name",
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
                      onChanged: (value) {
                        setState(() {
                          teacher = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField(
                      value: classgroup,
                      validator: (value) {
                        if (value == null || value == "Select Age(In Years)") {
                          return 'Please select age';
                        }
                        return null;
                      },
                      items: items4.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          classgroup = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.orange),
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
                      height: 25,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey_1.currentState!.validate()) {
                          DateTime now = DateTime.now();
                          DateFormat formatter = DateFormat('M/d/y');
                          String formatted = formatter.format(now);
                          DateFormat formatter1 = DateFormat('jm');
                          String formatted1 = formatter1.format(now);
                          //print(formatted);
                          var url =
                              'https://app.churchinapp.com/api/signinchildren';
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          print('USer Id: ${sp.getInt('user_id')}');
                          final Map<String, String> data = {
                            "entry_date": formatted,
                            "entry_time": formatted1,
                            "user_id": sp.getInt("user_id").toString(),
                            'qrcode': eventid["value"],
                            "member_type": Helper.type.toString(),
                            "name": fullname,
                            "gender": _gender,
                            "teacher": teacher,
                            "class_group": classgroup
                          };
                          print("testing data$data");
                          print("testing data" +
                              json.encode(
                                  {"data": encryption(json.encode(data))}));
                          /*  setState(()
    {
    vaue.text=encryption(json.encode(data)).toString();
    });*/
                          try {
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
                            if (response.statusCode == 200) {
                              Map<String, dynamic> result = jsonDecode(
                                  decryption(response.body.toString().trim())
                                          .split("}")[0] +
                                      "}") as Map<String, dynamic>;
                              /*final Map<String,dynamic> result = {
    "message":"success","user_id":"1"};*/
                              if (result["status"] == "success") {
                                setState(() {
                                  successtxt = result["message"];
                                  errtxt = "";
                                  _formkey_1.currentState!.reset();
                                  _fullnamecontroller.clear();
                                  classgroup = "Select Age(In Years)";
                                  _teachercontroller.clear();
                                  _gender = 'Gender';
                                });
                              } else {
                                setState(() {
                                  errtxt = result["message"];
                                  successtxt = "";
                                  _formkey_1.currentState!.reset();
                                });
                              }
                            } else {
                              setState(() {
                                errtxt =
                                    "Please Check your Internet Connection And data";
                                successtxt = "";
                                _formkey_1.currentState!.reset();
                              });
                            }
                          } on TimeoutException catch (e) {
                            setState(() {
                              errtxt =
                                  "Please Check your Internet Connection And data";
                              successtxt = "";
                              _formkey_1.currentState!.reset();
                            });
                          } on Exception catch (e) {
                            setState(() {
                              errtxt = e.toString();
                              successtxt = "";
                              _formkey_1.currentState!.reset();
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
                        "Register",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _fullnamecontroller.clear();
                          classgroup = "Select Age(In Years)";
                          _teachercontroller.clear();
                          _gender = 'Gender';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(150, 40),
                        shape: RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.circular(10)), // NEW
                      ),
                      child: const Text(
                        "Reset",
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
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
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
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
                            " :Please Check your Internet Connection And data";
                      });
                    }
                  } on TimeoutException catch (e) {
                    Navigator.of(context).pop();
                    setState(() {
                      errtxt = "Please Check your Internet Connection And data";
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
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Form(
            key: _formkey_4,
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
                  'Event Entry',
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
                  controller: _fullnamecontroller,
                  validator: (value) => FieldValidator.validateFullname(value!),
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: const Icon(Icons.account_circle_rounded,
                          color: Colors.orange),
                      hintText: "Full Name",
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
                  onChanged: (value) {
                    setState(() {
                      fullname = value;
                    });
                  },
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
                      hintText: "Email",
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
                    controller: _phonecontroller,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.orange,
                        ),
                        hintText: "Enter Phone",
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
                    validator: (value) => FieldValidator.validateMobile(value!),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {
                        phone = value;
                      });
                    }),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                    controller: _occupationcontroller,
                    validator: (value) =>
                        FieldValidator.validateOccupation(value!),
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        prefixIcon: const Icon(
                          Icons.laptop,
                          color: Colors.orange,
                        ),
                        hintText: "Enter Occupation",
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
                    onChanged: (value) {
                      setState(() {
                        occupation = value;
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
                ElevatedButton(
                  onPressed: () async {
                    if (_formkey_4.currentState!.validate()) {
                      DateTime now = DateTime.now();
                      DateFormat formatter = DateFormat('M/d/y');
                      String formatted = formatter.format(now);
                      DateFormat formatter1 = DateFormat('jm');
                      String formatted1 = formatter1.format(now);
                      var url = 'https://app.churchinapp.com/api/eventregister';
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();

                      final Map<String, String> data = {
                        "entry_date": formatted,
                        "entry_time": formatted1,
                        "user_id": sp.getInt("user_id").toString(),
                        'qrcode': eventid["value"],
                        "member_type": Helper.type.toString(),
                        "name": fullname,
                        "email": email,
                        "phone_no": phone,
                        "occupation": occupation
                      };
                      print("testing data" + data.toString());
                      print("testing data" +
                          json.encode({"data": encryption(json.encode(data))}));
                      try {
                        final response = await http.post(Uri.parse(url),
                            body: json.encode(
                                {"data": encryption(json.encode(data))}),
                            encoding: Encoding.getByName('utf-8'),
                            headers: {
                              "CONTENT-TYPE": "application/json"
                            }).timeout(const Duration(seconds: 20));
                        if (response.statusCode == 200) {
                          Map<String, dynamic> result = jsonDecode(
                              decryption(response.body.toString().trim())
                                      .split("}")[0] +
                                  "}") as Map<String, dynamic>;
                          print('Result: $result');
                          print('Result 2: ${result['status']}');
                          if (result["status"] == "success") {
                            setState(() {
                              successtxt = result["message"];
                              errtxt = "";
                              _fullnamecontroller.clear();
                              _emailcontroller.clear();
                              _phonecontroller.clear();
                              _occupationcontroller.clear();
                              //isShow=true;
                            });
                          } else {
                            setState(() {
                              errtxt = result["message"];
                              successtxt = "";
                            });
                          }
                        }
                        // else {
                        //   setState(() {
                        //     successtxt = "";
                        //     errtxt =
                        //         "Please Check your Internet Connection And data" /*+response.statusCode.toString()+response.body*/;
                        //   });
                        // }
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
                    "Register",
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    /*final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
    'qrcode':eventid["value"],"member_type":Helper.type.toString(),"name":fullname,"gender":dropdownvalue1,"dob":dateInput.text,"address":address,"city":city,"state":state_1,"pincode":postalcode,"country":country,"marital_status":marital,"wed_anniversary":anniversaryInput.text,"no_of_child":children,"email":email,"phone_no":phone,"occupation":occupation};
    print("testing data"+data.toString());*/
                    setState(() {
                      _fullnamecontroller.clear();
                      _emailcontroller.clear();
                      _phonecontroller.clear();
                      _occupationcontroller.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(150, 40),
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(10)), // NEW
                  ),
                  child: const Text(
                    "Reset",
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                        visible: isShow,
                        child:
                            const Text("Are you Interested to do offerings")),
                    Visibility(
                        visible: isShow,
                        child: const SizedBox(
                          height: 16,
                        )),
                    Visibility(
                        visible: isShow,
                        child: TextButton(
                          //color: carribean_green,
                          //textColor: white,
                          //borderColor: carribean_green,
                          //text: "Signin For Children",
                          /*onTap: () async {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      prefs.setString("user_type", "2");
                      Helper.type="2";
                      Navigator.pushNamed(context, "/scanner");
                    }, */
                          onPressed: () {
                            Navigator.pushNamed(context, "/offerings",
                                arguments: eventid);
                          },

                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepOrange.shade500,
                            minimumSize: const Size(250, 50),
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(10)), // NEW
                          ),
                          child: const Text("Click Here"),
                        )),
                    Visibility(
                      visible: isShow,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),
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
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        )),
      );
    }
  }

  _launchURL() async {
    const url = 'https://churchinapp.com/privacypolicy';
    try {
      final uri = Uri.parse(url);

      await launchUrl(uri);
    } on Exception catch (e) {
      print("Exception in launching the url");
    }
  }
}
