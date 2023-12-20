import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/pages/login_page.dart';
import 'package:nutrisee/pages/profile_page.dart';
import 'package:nutrisee/pages/register_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              ProfilePage(user: user, loggedEmail: user.email.toString()),
        ),
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'nutrisee.jpg',
                height: 200,
                width: 200,
              ),
              Text(
                'Welcome!',
                style: GoogleFonts.crimsonPro(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 0, 120, 74)),
              ),
              SizedBox(height: 24.0),
              Text(
                'Hitung Kalori, Seimbangkan Nutrisi, \nRaih Kesehatan Optimal dengan Nutrisee!',
                style: GoogleFonts.rubik(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 200.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  side: BorderSide(color: Colors.blue),
                  minimumSize: Size(237, 58),
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.crimsonPro(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue),
                  minimumSize: Size(237, 58),
                ),
                child: Text(
                  'Register',
                  style: GoogleFonts.crimsonPro(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
