import 'dart:developer';

import 'package:driver_app/constants/constants.dart';
import 'package:driver_app/providers/auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:driver_app/providers/services.dart';
import 'package:driver_app/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/domain/user.dart';
import 'package:driver_app/providers/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  User user;
  Map<String, dynamic> driverStat;

  final Future<User> _loadUser = Future<User>.delayed(
    const Duration(milliseconds: 1),
    () => UserPreferences().getUser(),
  );

  final Future _loadCurrentActivity = Future.delayed(
    const Duration(milliseconds: 1),
    () => activity(),
  );

  final Future _loadFutureActivity = Future.delayed(
    const Duration(milliseconds: 1),
    () => futureActivity(),
  );

  final Future _loadPassedActivity = Future.delayed(
    const Duration(milliseconds: 1),
    () => passedActivity(),
  );

  @override
  Widget build(BuildContext context) {
    String intToTimeLeft(int value) {
      int h, m, s;
      h = value ~/ 3600;
      m = ((value - h * 3600)) ~/ 60;
      s = value - (h * 3600) - (m * 60);
      String result = "$h h $m min";
      return result;
    }

    return ScreenUtilInit(
      builder: () => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              backgroundColor: primary,
              flexibleSpace: FlexibleSpaceBar(
                title: FutureBuilder(
                  future: Future.wait([
                    _loadUser,
                    _loadCurrentActivity,
                    _loadPassedActivity,
                    _loadFutureActivity,
                  ]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        Text(
                          'Tableau de bord',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Text(
                          snapshot.data[0].name,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ];
                    } else {
                      children = <Widget>[
                        Text(
                          'Tableau de bord',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 28.0.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                      ];
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    );
                  },
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                    child: Text(
                      'Activité en cours',
                      style: GoogleFonts.montserrat(
                          fontSize: 20.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      future: Future.wait([
                        _loadUser,
                        _loadCurrentActivity,
                        _loadFutureActivity,
                        _loadPassedActivity,
                      ]),
                      builder: (context, ticketSnap) {
                        if (ticketSnap.hasData) {
                          inspect(ticketSnap);
                          if (ticketSnap.data[1]['status']) {
                            return Container(
                              padding: EdgeInsets.all(26.r),
                              margin:
                                  EdgeInsets.fromLTRB(26.w, 26.h, 26.w, 12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.r),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2.r,
                                    blurRadius: 4.r,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 28.h),
                                      Text(
                                        ticketSnap.data[1]['current']
                                            ['date_departure'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 25.sp,
                                        ),
                                      ),
                                      SizedBox(height: 28.h),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        Text(
                                                          ticketSnap.data[1]
                                                                  ['current']
                                                              ['departure'],
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 22.0.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .arrow_right_alt_rounded,
                                                        ),
                                                        Text(
                                                          ticketSnap.data[1]
                                                                  ['current']
                                                              ['arrival'],
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 22.0.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      ticketSnap.data[1]
                                                              ['current']
                                                          ['time_departure'],
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 20.0.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'De',
                                                style: GoogleFonts.montserrat(
                                                    color: purple),
                                              ),
                                              Text(
                                                ticketSnap.data[1]['current']
                                                    ['departure'],
                                                style: GoogleFonts.montserrat(),
                                              ),
                                              SizedBox(height: 28.h),
                                              Text(
                                                'A',
                                                style: GoogleFonts.montserrat(
                                                    color: purple),
                                              ),
                                              Text(
                                                ticketSnap.data[1]['current']
                                                    ['arrival'],
                                                style: GoogleFonts.montserrat(),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Départ',
                                                style: GoogleFonts.montserrat(
                                                    color: purple),
                                              ),
                                              Text(
                                                ticketSnap.data[1]['current']
                                                    ['time_departure'],
                                                style: GoogleFonts.montserrat(),
                                              ),
                                              SizedBox(height: 28.h),
                                              Text(
                                                'Arrivée',
                                                style: GoogleFonts.montserrat(
                                                    color: purple),
                                              ),
                                              Text(
                                                ticketSnap.data[1]['current']
                                                    ['time_arrival'],
                                                style: GoogleFonts.montserrat(),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Container(
                                        padding: EdgeInsets.only(right: 5.w),
                                        child: Icon(
                                          Icons.calendar_today_rounded,
                                          color: Colors.black38,
                                          size: 22.sp,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ticketSnap.data[1]['message'],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20.sp,
                                          color: Colors.black38),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white10,
                              color: primary,
                              minHeight: 1.h,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                    child: Text(
                      'Prochainement',
                      style: GoogleFonts.montserrat(
                          fontSize: 20.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      future: Future.wait([
                        _loadUser,
                        _loadCurrentActivity,
                        _loadFutureActivity,
                        _loadPassedActivity,
                      ]),
                      builder: (context, ticketSnap) {
                        if (ticketSnap.hasData) {
                          if (ticketSnap.data[2]['status']) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              itemCount: ticketSnap.data[2]['future'].length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          padding: EdgeInsets.all(26.r),
                                          margin: EdgeInsets.fromLTRB(
                                              26.w, 26.h, 26.w, 12.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.r),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2.r,
                                                blurRadius: 4.r,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              ticketSnap.data[2]
                                                                          [
                                                                          'future']
                                                                      [index]
                                                                  ['departure'],
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize:
                                                                    22.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .arrow_right_alt_rounded,
                                                            ),
                                                            Text(
                                                              ticketSnap.data[2]
                                                                          [
                                                                          'future']
                                                                      [index]
                                                                  ['arrival'],
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize:
                                                                    22.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          ticketSnap.data[2]
                                                                      ['future']
                                                                  [index][
                                                              'date_departure'],
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 20.0.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Container(
                                        padding: EdgeInsets.only(right: 5.w),
                                        child: Icon(
                                          Icons.clear_rounded,
                                          color: Colors.black38,
                                          size: 22.sp,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ticketSnap.data[2]['message'],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20.sp,
                                          color: Colors.black38),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white10,
                              color: primary,
                              minHeight: 1.h,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                    child: Text(
                      'Anciennement',
                      style: GoogleFonts.montserrat(
                          fontSize: 20.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      future: Future.wait([
                        _loadUser,
                        _loadCurrentActivity,
                        _loadFutureActivity,
                        _loadPassedActivity,
                      ]),
                      builder: (context, ticketSnap) {
                        if (ticketSnap.hasData) {
                          if (ticketSnap.data[3]['status']) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 10.h),
                              itemCount: ticketSnap.data[3]['passed'].length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          padding: EdgeInsets.all(16.r),
                                          margin: EdgeInsets.fromLTRB(
                                              12.w, 12.h, 12.w, 12.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.r),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2.r,
                                                blurRadius: 4.r,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              ticketSnap.data[3]
                                                                          [
                                                                          'passed']
                                                                      [index]
                                                                  ['departure'],
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize:
                                                                    22.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .arrow_right_alt_rounded,
                                                            ),
                                                            Text(
                                                              ticketSnap.data[3]
                                                                          [
                                                                          'passed']
                                                                      [index]
                                                                  ['arrival'],
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize:
                                                                    22.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          ticketSnap.data[3]
                                                                      ['passed']
                                                                  [index][
                                                              'date_departure'],
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 20.0.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Container(
                                        padding: EdgeInsets.only(right: 5.w),
                                        child: Icon(
                                          Icons.history,
                                          color: Colors.black38,
                                          size: 22.sp,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ticketSnap.data[3]['message'],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20.sp,
                                          color: Colors.black38),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white10,
                              color: primary,
                              minHeight: 1.h,
                            ),
                          );
                        }
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
