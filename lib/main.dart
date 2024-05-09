// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_print

import 'dart:async';

import 'package:churchIn/ChangePwdPage.dart';
import 'package:churchIn/CheckoutPage.dart';
import 'package:churchIn/ForgotPwdPage.dart';
import 'package:churchIn/LoginPage.dart';
import 'package:churchIn/MenuPage.dart';
import 'package:churchIn/OfferingPage.dart';
import 'package:churchIn/RegisterPage.dart';
import 'package:churchIn/ScannerPage.dart';
import 'package:churchIn/SignUpPage.dart';
import 'package:churchIn/Verfication%7Bage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:new_churchlin/ChangePwdPage.dart';
// import 'package:new_churchlin/CheckoutPage.dart';
// import 'package:new_churchlin/ForgotPwdPage.dart';
// import 'package:new_churchlin/LoginPage.dart';
// import 'package:new_churchlin/MenuPage.dart';
// import 'package:new_churchlin/OfferingPage.dart';
// import 'package:new_churchlin/RegisterPage.dart';
// import 'package:new_churchlin/ScannerPage.dart';
// import 'package:new_churchlin/SignUpPage.dart';
// import 'package:new_churchlin/Verfication%7Bage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/helper.dart';
import 'utils/colors.dart';

void main() {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    /*DevicePreview(
      enabled: true,
      tools: [
        ...DevicePreview.defaultTools,
        const DevicePreviewScreenshot(),
      ],
      builder: (context) =>  AlfaApp(),
    )*/
    const AlfaApp(),
  );
}

class AlfaApp extends StatelessWidget {
  const AlfaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //  useInheritedMediaQuery: true,
      //  locale: DevicePreview.locale(context),
      //  builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Alfa',
      theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.blue,
          primaryColor: persian_blue),

      home: const AlfaSplashScreen(),
      /*Simple_splashscreen(
        context: context,
        gotoWidget: MyHomePage(title: 'start now'),
        splashscreenWidget: AlfaSplashScreen(),
        timerInSeconds: 5,
      ),*/
      //MyHomePage(title: 'Start Now'),
      routes: {
        '/login': (context) => const LoginPage(),
        '/forgot': (context) => const ForgotPwdPage(),
        '/change': (context) => const ChangePwdPage(),
        '/verification': (context) => const VerificationPage(),
        '/signup': (context) => const SignUpPage(),
        '/scanner': (context) => const ScannerPage(),
        '/register': (context) => const RegisterPage(),
        '/menu': (context) => const MenuPage(),
        '/offerings': (context) => const OfferingPage(),
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}

class AlfaSplashScreen extends StatefulWidget {
  const AlfaSplashScreen({super.key});

  @override
  State<AlfaSplashScreen> createState() => _AlfaSplashScreenState();
}

class _AlfaSplashScreenState extends State<AlfaSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'start now'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "assets/images/alfanewlogo.svg",
                width: 300,
                height: 300,
              ),
              SizedBox(
                width: 300,
                height: 200,
                child: OverflowBox(
                  alignment: Alignment.center,
                  minWidth: 435,
                  minHeight: 438,
                  maxWidth: 500,
                  maxHeight: 510,
                  child: SvgPicture.asset(
                    'assets/images/alfasplashperson.svg',
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.contain,
                    //allowDrawingOutsideViewBox: true,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? user_id = 0;
  bool stay_signed = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    stay_signed =
        sp.containsKey("stay_signed") ? sp.getBool("stay_signed")! : false;
    print("${stay_signed}sdfd");
    if (stay_signed != true && sp.containsKey("user_id")) {
      sp.setInt("user_id", 0);
      sp.setString("email", "");
    }
    user_id = sp.containsKey("user_id") ? sp.getInt("user_id") : 0;
    return stay_signed;
  }

  @override
  Widget build(BuildContext context) {
    Helper helper = Helper();
    return FutureBuilder<bool>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != true) {
              return const LoginPage();
            } else {
              return const ScannerPage();
            }
          } else {
            return const LoginPage();
          }
        });
  }
}
