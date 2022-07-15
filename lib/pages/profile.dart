import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:driver_app/constants/constants.dart';
import 'package:driver_app/domain/user.dart';
import 'package:driver_app/pages/settings.dart';
import 'package:driver_app/providers/services.dart';
import 'package:driver_app/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showPassword = false;
  final Future<User> _loadUser = Future<User>.delayed(
    const Duration(milliseconds: 1),
    () => UserPreferences().getUser(),
  );

  final Future _loadStat = Future.delayed(
    const Duration(milliseconds: 1),
    () => stat(),
  );

  @override
  Widget build(BuildContext context) {
    String intToTimeLeft(num value) {
      num h, m, s;
      h = value ~/ 3600;
      m = ((value - h * 3600)) ~/ 60;
      s = value - (h * 3600) - (m * 60);
      String result = "$h h $m min";
      return result;
    }

    return ScreenUtilInit(
      builder: () => Scaffold(
        appBar: AppBar(
          title: Text(
            'Profil',
            style: GoogleFonts.montserrat(
              color: Colors.black54,
              fontSize: 25.0.sp,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              color: primary,
              tooltip: 'Paramètres',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0.0.h,
        ),
        backgroundColor: const Color(0xffffffff),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              backgroundColor: const Color(0xffffffff),
              flexibleSpace: FlexibleSpaceBar(
                title: Expanded(
                  child: FutureBuilder(
                    future: Future.wait([
                      _loadUser,
                      _loadStat,
                    ]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = <Widget>[
                          Text(
                            snapshot.data[0].name,
                            style: GoogleFonts.montserrat(
                              fontSize: 24.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ];
                      } else {
                        children = <Widget>[
                          Text(
                            '..',
                            style: GoogleFonts.montserrat(),
                          ),
                        ];
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    margin: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      future: Future.wait([
                        _loadUser,
                        _loadStat,
                      ]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          children = <Widget>[
                            Divider(
                              height: 40.h,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1.r,
                                    blurRadius: 3.r,
                                    offset: Offset(
                                        0.w, 1.h), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 16.h,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Distance parcourue',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 22.0.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data[1]['stat']['distance']} km',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20.0.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1.r,
                                    blurRadius: 3.r,
                                    offset: Offset(
                                        0.w, 1.h), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 16.h,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Kilométrage moyen mensuel',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 22.0.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data[1]['avg']['avg_distance']} km',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20.0.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1.r,
                                    blurRadius: 3.r,
                                    offset: Offset(
                                        0.w, 1.h), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 16.h,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Temps de voyage',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 22.0.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          intToTimeLeft(double.parse(snapshot
                                              .data[1]['stat']['duration'])),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20.0.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1.r,
                                    blurRadius: 3.r,
                                    offset: Offset(
                                        0.w, 1.h), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 16.h,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Temps de voyage moyen mensuel',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 22.0.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          intToTimeLeft(snapshot.data[1]['avg']
                                              ['avg_duration']),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20.0.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        } else {
                          children = <Widget>[
                            CircularProgressIndicator(
                              backgroundColor: Colors.black12,
                              // color: Color(0xFF5036D5),
                            ),
                          ];
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: children,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      designSize: const Size(480, 640),
    );
  }
}
