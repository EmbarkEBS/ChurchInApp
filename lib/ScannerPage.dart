// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, unused_catch_clause, avoid_print, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String errortxt = "";
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setBool("stay_signed", false);
        sp.setInt("user_id", 0);
        Navigator.pushNamed(context, "/login");
        break;
      case 'Offerings':
        break;
      case 'PrivacyPolicy':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 280.0
        : 300.0;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                      //Navigator.pushNamed(context, "/login");
                    },
                  ),
                ],
              ),
            ),
            body: Material(
                child: Container(
              color: Colors.grey.withOpacity(0.5),
              child: Stack(
                children: [
                  QRView(
                    //flex: 5,
                    // child: _buildQrView(context),
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                        borderColor: Colors.blue,
                        borderRadius: 10,
                        borderLength: 40,
                        borderWidth: 7,
                        cutOutSize: scanArea),
                    onPermissionSet: (ctrl, p) =>
                        _onPermissionSet(context, ctrl, p),
                  ),
                  Column(
                    children: [
                      Container(
                        //  color: Colors.grey.withOpacity(0.5),
                        padding: const EdgeInsets.fromLTRB(10, 30, 0, 10),
                        //margin: EdgeInsets.fromLTRB(0, 0, 5,5),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //FlutterLogo(size: 100,),
                              SvgPicture.asset(
                                "assets/images/newlogo.svg",
                                width: 70,
                                height: 70,
                              ),
                            ]),
                      ),
                      Center(
                          child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: (errortxt != "")
                            ? Text(
                                errortxt,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              )
                            : const Text(
                                "Place the QRCODE of your mobile \n"
                                "        camera on the blue box",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                      ))
                    ],
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
                  /*Expanded(
              flex: 1,
              child: Center(
                child: (result != null)
                    ? Text(
                    'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                    : Text('Scan a code'),
              ),
            )*/
                ],
              ),
            ))));
  }

  void _onQRViewCreated(QRViewController controller) {
    //setState(() {
    this.controller = controller;
    // });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (scanData != null) {
        String? value = scanData.code;
        List<String> txt =
            value!.split("_"); //print(value.toString()+" gggggg");
        if (txt.length > 1 && txt[0].toLowerCase() == "alpha") {
          final Map<String, dynamic> result = {"value": value};
          print('Values: $value');
          this.controller!.pauseCamera();
          Navigator.pushNamed(context, "/menu", arguments: result)
              .then((value) => this.controller!.resumeCamera());
          // no }
        } else {
          setState(() {
            errortxt = "Scan a valid QR";
          });
        }
      }
      //this.controller!.resumeCamera();
      // controller?.dispose();
    });
    this.controller!.pauseCamera();
    this.controller!.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
