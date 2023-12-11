import 'package:flutter/material.dart';
import 'package:nutrisee/pages/bmi_calculator_input_page.dart';
import 'package:nutrisee/pages/bmi_calculator_result_page.dart';
import 'package:nutrisee/pages/home_page.dart';
import 'package:nutrisee/pages/register_page.dart';
import 'package:nutrisee/pages/tdee_calculator_input_page.dart';
import 'package:nutrisee/pages/tdee_calculator_result_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrisee',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
