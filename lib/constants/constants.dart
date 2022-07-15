import 'package:flutter/material.dart';

enum Payment { Cash, BankCard }

//padding
const double appPadding = 20.0;

//colors used in this app
const Color primary = Color(0xFF168cd0);
const Color complementary = Color(0xFFd05a16);
const Color analogous1 = Color(0xFF16d0b7);
const Color analogous2 = Color(0xFF162fd0);
const Color triadic1 = Color(0xFFb716d0);
const Color triadic2 = Color(0xFFd0162f);

const MaterialColor primaryColor = MaterialColor(
  0xFF162fd0,
  <int, Color>{
    50: Color(0xFFe2f6fe),
    100: Color(0xFFb5e6fb),
    200: Color(0xFF84d6f9),
    300: Color(0xFF56c6f6),
    400: Color(0xFF36b9f5),
    500: Color(0xFF1fadf3),
    600: Color(0xFF1b9fe4),
    700: Color(0xFF168cd0),
    800: Color(0xFF147bbc),
    900: Color(0xFF0e5b9a),
  },
);

const Color secondary = Color(0xFFC62828);
const Color white = Colors.white;
const Color black = Colors.black;
const Color grey = Colors.grey;
const Color purple = Color(0xFF3594DD);
const Color purpleAccent = Color(0xFF4563DB);
