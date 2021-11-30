import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF0277BD);

Map<int, Color> color = {
  50: const Color.fromRGBO(2, 119, 189, .1),
  100: const Color.fromRGBO(2, 119, 189, .2),
  200: const Color.fromRGBO(2, 119, 189, .3),
  300: const Color.fromRGBO(2, 119, 189, .4),
  400: const Color.fromRGBO(2, 119, 189, .5),
  500: const Color.fromRGBO(2, 119, 189, .6),
  600: const Color.fromRGBO(2, 119, 189, .7),
  700: const Color.fromRGBO(2, 119, 189, .8),
  800: const Color.fromRGBO(2, 119, 189, .9),
  900: const Color.fromRGBO(2, 119, 189, 1),
};

MaterialColor kPrimaryMaterialColor = MaterialColor(0xFF0277BD, color);
