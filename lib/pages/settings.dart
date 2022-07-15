import 'package:another_flushbar/flushbar.dart';
import 'package:driver_app/constants/constants.dart';
import 'package:driver_app/domain/user.dart';
import 'package:driver_app/providers/auth.dart';
import 'package:driver_app/providers/user_provider.dart';
import 'package:driver_app/util/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showPassword = false;
  final Future<User> _loadUser = Future<User>.delayed(
    const Duration(milliseconds: 1),
    () => UserPreferences().getUser(),
  );

  @override
  Widget build(BuildContext context) {
    doLogout() {
      final Future<Map<String, dynamic>> res = AuthProvider().logout();

      res.then((response) {
        if (response['status']) {
          Provider.of<UserProvider>(context, listen: false).user = null;
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          Flushbar(
            title: "Erreur",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    }

    return ScreenUtilInit(
      builder: () => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: primary,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16.w, top: 25.h, right: 16.w),
          child: ListView(
            children: [
              Text(
                "Paramètres",
                style: GoogleFonts.montserrat(
                    fontSize: 25.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: primary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Comptes",
                    style: GoogleFonts.montserrat(
                        fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Divider(
                height: 15.h,
                thickness: 2,
              ),
              SizedBox(
                height: 10.h,
              ),
              // GestureDetector(
              //   onTap: () async {
              //     User user = await UserPreferences().getUser();
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => PersonalSettings(user: user),
              //       ),
              //     );
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(vertical: 8.0.h),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           'Informations personnelles',
              //           style: GoogleFonts.montserrat(
              //             fontSize: 18.sp,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.grey[600],
              //           ),
              //         ),
              //         const Icon(
              //           Icons.mode_edit_outline_outlined,
              //           color: Colors.grey,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () async {
              //     User user = await UserPreferences().getUser();
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => SecuritySettings(user: user),
              //       ),
              //     );
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(vertical: 8.0.h),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           'Informations de sécurité',
              //           style: GoogleFonts.montserrat(
              //             fontSize: 18.sp,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.grey[600],
              //           ),
              //         ),
              //         const Icon(
              //           Icons.mode_edit_outline_outlined,
              //           color: Colors.grey,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Se déconnecter',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          child: const Icon(Icons.logout),
          onPressed: () => doLogout(),
        ),
      ),
      designSize: const Size(480, 640),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              activeColor: Colors.deepPurple.shade800,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
