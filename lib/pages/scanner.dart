import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:driver_app/pages/layout.dart';
import 'package:driver_app/providers/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  _onScanQrCode(String qrData) {
    final Future<Map<String, dynamic>> res = controlQrTicket(qrData);

    res.then((response) {
      inspect(response['message']);
      if (response['status']) {
        Flushbar(
          title: "Succes",
          message: response['message'].toString(),
          backgroundColor: Colors.green,
          flushbarPosition: FlushbarPosition.BOTTOM,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          duration: const Duration(seconds: 2),
          isDismissible: false,
        ).show(context).then(
              (value) => controller.resumeCamera(),
            );
        // return response['message'].toString();
      } else {
        Flushbar(
          title: "Erreur",
          message: response['message'].toString(),
          backgroundColor: Colors.red,
          flushbarPosition: FlushbarPosition.BOTTOM,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          duration: const Duration(seconds: 2),
          isDismissible: false,
        ).show(context).then(
              (value) => controller.resumeCamera(),
            );
        // return response['message'].toString();
      }
    });
  }

  final qrKey = GlobalKey(debugLabel: 'QR');

  String message = 'Scannez un code';
  Barcode barcode;
  QRViewController controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
            // Positioned(bottom: 10, child: buildResult()),
            Positioned(top: 10, child: buildControlButtons()),
          ],
        ),
      ),
    );
  }

  // Widget buildResult() => Container(
  //       padding: EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         color: Colors.white24,
  //       ),
  //       child:
  //           // RichText(
  //           //   text: TextSpan(
  //           //     children: [
  //           //       barcode != null
  //           //           ? const WidgetSpan(
  //           //               child: Padding(
  //           //                 padding: EdgeInsets.symmetric(horizontal: 2.0),
  //           //                 child: Icon(CupertinoIcons.check_mark),
  //           //               ),
  //           //             )
  //           //           : const WidgetSpan(
  //           //               child: Padding(
  //           //                 padding: EdgeInsets.symmetric(horizontal: 2.0),
  //           //                 child: Icon(CupertinoIcons.xmark),
  //           //               ),
  //           //             ),
  //           //       barcode != null
  //           //           ? TextSpan(text: ' Resultat : ${barcode.code}')
  //           //           : const TextSpan(text: ' Scanner un code!'),
  //           //     ],
  //           //   ),
  //           // ),
  //           Text(
  //         barcode != null
  //             ? 'Resultat : ${barcode.code}'
  //             : 'Scanner un code!',
  //         message,
  //         maxLines: 3,
  //       ),
  //     );

  Widget buildControlButtons() => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              icon: FutureBuilder<bool>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                        snapshot.data ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          borderColor: Theme.of(context).accentColor,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      controller.pauseCamera();
      setState(
        () async {
          await _onScanQrCode(barcode.code);
          this.barcode = barcode;
        },
      );
    });
  }
}
