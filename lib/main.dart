import 'package:flutter/material.dart';
import 'package:ping_me/pages/details_list.dart';
import 'package:ping_me/pages/day_time.dart';

void main() => runApp(MaterialApp(

  debugShowCheckedModeBanner: false,

  initialRoute: '/details_list',

  routes: {
    '/details_list': (context) => DetailsListPage(),
    '/day_time': (context) => DayTimePage()
  },

));

