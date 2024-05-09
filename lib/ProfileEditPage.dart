// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously, unused_field, unused_catch_clause, unnecessary_null_comparison, file_names

import 'dart:async';
import 'dart:convert';

import 'package:churchIn/helpers/encrypter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// import 'package:new_churchlin/helpers/encrypter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'utils/validator.dart';

class ProfileEditPage extends StatefulWidget {
  final Map<String, dynamic> results;
  final Map<String, dynamic> eventid;
  const ProfileEditPage(this.results, this.eventid, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
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
  TextEditingController dateInput = TextEditingController();
  TextEditingController anniversaryInput = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
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
  String aod = "";
  String dob = "";
  String password = "";
  bool isEnabled = false;
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
  String marital = '-';
  var items2 = [
    '-',
    'Married',
    'Unmarried',
  ];
  String children = '0';
  var items3 = [
    'Number Of Kids',
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
    '12'
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
    fullname = _fullnamecontroller.text = widget.results["name"];
    _gender = widget.results["gender"];
    address = _addresscontroller.text = widget.results["address"];
    city = _citycontroller.text = widget.results["city"];
    country = _countrycontroller.text = widget.results["country"];
    state_1 = _statecontroller.text = "TN";
    dropdownvalue1 = widget.results["gender"];
    email = _emailcontroller.text = widget.results["email"];
    postalcode = _postalcodecontroller.text = widget.results["pincode"];
    marital = widget.results["marital_status"];
    children = widget.results["no_of_child"];
    phone = _phonecontroller.text = widget.results["phone_no"];
    occupation = _occupationcontroller.text = widget.results["occupation"];
    referred_by = widget.results["referred_by"];
    aod = anniversaryInput.text = widget.results["wed_anniversary"];
    dob = dateInput.text = widget.results["dob"];
  }

  @override
  Widget build(BuildContext context) {
    print("fbgnbgn${widget.eventid}");
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
                Navigator.pushNamed(context, "/menu",
                    arguments: widget.eventid);
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
                    print("testing data" + data.toString());
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
                                          result["results"], widget.eventid)));
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
                    Navigator.pushNamed(context, "/change",
                        arguments: widget.eventid);
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
                            height: 10,
                          ),
                          const Text(
                            'My Profile',
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
                            enabled: isEnabled,
                            style: const TextStyle(
                              height: 0,
                            ),
                            controller: _fullnamecontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(
                                  Icons.account_circle_rounded,
                                  color: Colors.orange,
                                ),
                                //labelText: "Full Name",
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
                                    color: Colors.deepPurple.shade200,
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
                              fullname = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField(
                            value: dropdownvalue1,
                            validator: (value) {
                              if (value == null || value == "Gender") {
                                return 'Please select gender';
                              }
                              return null;
                            },
                            items: items1.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: isEnabled
                                ? (String? newValue) {
                                    setState(() {
                                      dropdownvalue1 = newValue!;
                                    });
                                  }
                                : null,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
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
                            enabled: isEnabled,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter date of birth';
                              }
                              return null;
                            },
                            controller: dateInput,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.orange,
                                ), //icon of text field
                                // labelText: "Enter DOB",
                                hintText: "Enter DOB",
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

                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2015),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2015));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  dob = formattedDate;
                                  dateInput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              enabled: isEnabled,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Address';
                                }
                                return null;
                              },
                              controller: _addresscontroller,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  prefixIcon: const Icon(
                                    Icons.notes,
                                    color: Colors.orange,
                                  ),
                                  //labelText: "Address",
                                  hintText: "Enter Address",
                                  fillColor: Colors.orange.shade50,
                                  filled: true,
                                  // labelStyle: TextStyle(fontSize: 15,color: Colors.blue),
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
                                  address = value;
                                });
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            enabled: isEnabled,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter City';
                              }
                              return null;
                            },
                            controller: _citycontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(
                                  Icons.location_city,
                                  color: Colors.orange,
                                ),
                                //labelText: "City",
                                hintText: "Enter City",
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
                                city = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            enabled: isEnabled,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter State';
                              }
                              return null;
                            },
                            controller: _statecontroller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(
                                  Icons.location_city,
                                  color: Colors.orange,
                                ),
                                //labelText: "City",
                                hintText: "Enter State",
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
                                state_1 = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            enabled: isEnabled,
                            controller: _countrycontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid country';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(
                                  Icons.location_city,
                                  color: Colors.orange,
                                ),
                                //labelText: "City",
                                hintText: "Enter Country",
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
                                country = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              enabled: isEnabled,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter valid postal code';
                                }
                                return null;
                              },
                              controller: _postalcodecontroller,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  prefixIcon: const Icon(
                                    Icons.pin_drop,
                                    color: Colors.orange,
                                  ),
                                  //labelText: "City",
                                  hintText: "Enter Postal Code",
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
                                  postalcode = value;
                                });
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              enabled: false,
                              controller: _emailcontroller,
                              validator: (value) =>
                                  FieldValidator.validateEmail(value!),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.orange,
                                  ),
                                  //labelText: "Email",
                                  hintText: "Enter Email",
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
                                  email = value;
                                });
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField(
                            value: marital,
                            validator: (value) {
                              if (value == null || value == "-") {
                                return 'Please enter valid Marital status';
                              }
                              return null;
                            },
                            items: items2.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: isEnabled
                                ? (String? newValue) {
                                    setState(() {
                                      marital = newValue!;
                                    });
                                  }
                                : null,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.orange,
                                ),
                                fillColor: Colors.orange.shade50,
                                filled: true,
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
                            enabled: isEnabled,
                            controller: anniversaryInput,
                            validator: (value) {
                              if (value == null ||
                                  (value.isEmpty && marital == "Married")) {
                                return 'Please enter anniversary date';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.orange,
                                ), //icon of text field
                                // labelText: "Enter DOB",
                                hintText: "Enter Date",
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
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now());

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  aod = formattedDate;
                                  anniversaryInput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField(
                            value: children,
                            items: items3.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: isEnabled
                                ? (String? newValue) {
                                    setState(() {
                                      children = newValue!;
                                    });
                                  }
                                : null,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.orange,
                                ),
                                fillColor: Colors.orange.shade50,
                                filled: true,
                                hintText: "No of childs",
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
                              enabled: isEnabled,
                              controller: _phonecontroller,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Colors.orange,
                                  ),
                                  //labelText: "Email",
                                  hintText: "Enter Phone",
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
                                    value.length != 10) {
                                  return 'Please enter valid phone number';
                                }
                                return null;
                              },
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
                              enabled: isEnabled,
                              controller: _occupationcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Occupation';
                                }
                                return null;
                                //return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  prefixIcon: const Icon(
                                    Icons.laptop,
                                    color: Colors.orange,
                                  ),
                                  //labelText: "Email",
                                  hintText: "Enter Occupation",
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
                                  occupation = value;
                                });
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField(
                            value: referred_by,
                            validator: (value) {
                              if (value == null || value == "Referred By") {
                                return 'Please select how do you know';
                              }
                              return null;
                            },
                            items: referrence.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: isEnabled
                                ? (String? newValue) {
                                    setState(() {
                                      referred_by = newValue!;
                                    });
                                  }
                                : null,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
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
                              if (!isEnabled) {
                                setState(() {
                                  isEnabled = true;
                                });
                              } else {
                                if (_formkey.currentState!.validate()) {
                                  DateTime now = DateTime.now();
                                  DateFormat formatter = DateFormat('M/d/y');
                                  String formatted = formatter.format(now);
                                  DateFormat formatter1 = DateFormat('jm');
                                  String formatted1 = formatter1.format(now);
                                  //print(formatted);

                                  var url =
                                      'https://app.churchinapp.com/api/profileupdate';
                                  final Map<String, String> data = {
                                    "user_id": widget.results["appuser_id"],
                                    "entry_date": formatted,
                                    "entry_time": formatted1,
                                    "name": fullname,
                                    "teacher": "",
                                    "class_group": "",
                                    "gender": dropdownvalue1,
                                    "dob": dob,
                                    "address": address,
                                    "city": city,
                                    "state": state_1,
                                    "pincode": postalcode,
                                    "country": country,
                                    "marital_status": marital,
                                    "wed_anniversary": aod,
                                    "no_of_child": children,
                                    "email": email,
                                    "phone_no": phone,
                                    "occupation": occupation,
                                    "referred_by": referred_by
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
                                        }).timeout(const Duration(seconds: 20));
                                    print(response.statusCode.toString() +
                                        "bfbfb");
                                    if (response.statusCode == 200) {
                                      Map<String, dynamic> result = jsonDecode(
                                          decryption(response.body
                                                      .toString()
                                                      .trim())
                                                  .split("}")[0] +
                                              "}") as Map<String, dynamic>;
                                      print(result.toString() + "bfbfb");

                                      if (result["status"] == "success") {
                                        SharedPreferences sp =
                                            await SharedPreferences
                                                .getInstance();
                                        sp.setInt(
                                            "user_id",
                                            int.parse(
                                                widget.results["appuser_id"]));
                                        sp.setString("email", email);
                                        // if(result["message"]=="Registered Successfully"){
                                        setState(() {
                                          successtxt = result["message"];
                                          errtxt = "";
                                          isEnabled = false;
                                        });
                                      } else if (result["status"] ==
                                          "not_verified") {
                                        setState(() {
                                          errtxt = result["message"];
                                          successtxt = "";
                                        });
                                      } else {
                                        setState(() {
                                          successtxt = "";
                                          errtxt ==
                                              "Please Check your Internet Connection And data - 3" +
                                                  result["status"];
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        successtxt = "";
                                        errtxt ==
                                            "Please Check your Internet Connection And data - 4" +
                                                response.statusCode.toString();
                                      });
                                    }
                                  } on TimeoutException catch (_) {
                                    setState(() {
                                      successtxt = "";
                                      errtxt =
                                          "Please Check your Internet Connection And data - 5";
                                    });
                                    //return false;
                                  } on Exception catch (e) {
                                    setState(() {
                                      errtxt = e.toString();
                                      successtxt = "";
                                    });
                                  }
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
                            child: Text(
                              isEnabled ? "Update" : "Edit Now",
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showConfirmationDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              minimumSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                  //to set border radius to button
                                  borderRadius:
                                      BorderRadius.circular(10)), // NEW
                            ),
                            child: const Text('Delete Account'),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this user account?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                //Navigator.of(context).pop();
                var url = 'https://app.churchinapp.com/api/deleteaccount';
                final Map<String, String> data = {
                  "user_id": widget.results["appuser_id"],
                };
                print("testing data" + data.toString());
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
                  print(response.statusCode.toString() + "dadada");
                  if (response.statusCode == 200) {
                    Map<String, dynamic> result = jsonDecode(
                        decryption(response.body.toString().trim())
                                .split("}")[0] +
                            "}") as Map<String, dynamic>;
                    print(result.toString() + "bfbfb");
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.setInt("user_id", 0);
                    sp.clear();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/signup", (route) => route.isFirst);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            content: const Text("Account Deleted Successfully",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            contentPadding: const EdgeInsets.all(30),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: Colors.orange),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          );
                        });
                  }
                } on TimeoutException catch (_) {
                  setState(() {
                    successtxt = "";
                    errtxt =
                        "Please Check your Internet Connection And data - 5";
                  });
                } on Exception catch (e) {
                  setState(() {
                    errtxt = e.toString();
                    successtxt = "";
                  });
                }
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
