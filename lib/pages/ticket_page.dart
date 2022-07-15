import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:driver_app/constants/constants.dart';
import 'package:driver_app/domain/user.dart';
import 'package:driver_app/pages/scanner.dart';
import 'package:driver_app/providers/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketPage extends StatefulWidget {
  final Future<User> user;
  const TicketPage({Key key, this.user}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final _ticketController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    _onValidButtonPressed() {
      final Future<Map<String, dynamic>> response =
          controlTicket(_ticketController.text);

      response.then((response) {
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
          ).show(context);
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
          ).show(context);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        // centerTitle: false,
        // titleSpacing: 0.0,
        title: Text(
          'Contrôle',
          style:
              GoogleFonts.montserrat(color: Colors.black54, fontSize: 25.0.sp),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.camera_alt_rounded),
            color: primary,
            tooltip: 'Utiliser la caméra',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Scanner(),
                ),
              );
            },
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0.0.h,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                style: textTheme.headline5,
                controller: _ticketController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.number_square),
                  hintText: 'Numéro de ticket',
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: primaryColor.shade50,
        tooltip: 'Vérifier',
        child: const Icon(Icons.check),
        onPressed: () => _onValidButtonPressed(),
      ),
    );
  }
}
