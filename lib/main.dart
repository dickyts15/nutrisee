import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutrisee/firebase_options.dart';
import 'package:nutrisee/pages/edit_profile_page.dart';
import 'package:nutrisee/pages/splash_screen.dart';
import 'package:nutrisee/services/edit_sasaran.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        home: const SplashScreen(),
        routes: {
          'edit_profile': (context) => EditProfile(),
          'edit_sasaran': (context) => EditSasaran(),
        });
  }
}
