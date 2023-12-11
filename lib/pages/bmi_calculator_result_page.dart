import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/pages/bmi_calculator_input_page.dart';

class BMICalculatorResultPage extends StatefulWidget {
  final double tinggi;
  final double berat;
  const BMICalculatorResultPage(
      {super.key, required this.tinggi, required this.berat});

  @override
  State<BMICalculatorResultPage> createState() =>
      _BMICalculatorResultPageState();
}

late double bmi;

class _BMICalculatorResultPageState extends State<BMICalculatorResultPage> {
  String resultText = '';
  String resultStatus = '';

  @override
  Widget build(BuildContext context) {
    if (calculateBMI() < 18.5) {
      resultText = 'Underweight';
      resultStatus = 'Anda Memiliki Berat Badan Underweight';
    } else if (calculateBMI() >= 18.5 && calculateBMI() <= 24.9) {
      resultText = 'Normal';
      resultStatus = 'Anda Memiliki Berat Badan Normal';
    } else if (calculateBMI() >= 25.0 && calculateBMI() <= 29.9) {
      resultText = 'Overweight';
      resultStatus = 'Anda Memiliki Berat Badan Overweight';
    } else {
      resultText = 'Obese';
      resultStatus = 'Anda Memiliki Berat Badan Obese';
    }

    Color _getResultColor(String resultText) {
      switch (resultText) {
        case 'Underweight':
          return Color.fromARGB(
              255, 0, 116, 217); // Ganti dengan warna sesuai keinginan
        case 'Normal':
          return Color.fromARGB(
              255, 63, 156, 53); // Ganti dengan warna sesuai keinginan
        case 'Overweight':
          return Color.fromARGB(
              255, 234, 171, 0); // Ganti dengan warna sesuai keinginan
        case 'Obese':
          return Color.fromARGB(
              255, 255, 61, 61); // Ganti dengan warna sesuai keinginan
        default:
          return Colors.black; // Ganti dengan warna sesuai keinginan
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        foregroundColor: Color.fromARGB(255, 250, 250, 250),
        backgroundColor: Color.fromARGB(255, 0, 120, 74),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Hasil BMI Anda',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(255, 229, 229, 229),
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Text(
                            resultText,
                            style: GoogleFonts.crimsonPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: _getResultColor(resultText)),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            calculateBMI().toStringAsFixed(1),
                            style: GoogleFonts.crimsonPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 64.0,
                                color: Color.fromARGB(255, 15, 15, 15)),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            resultStatus,
                            style: GoogleFonts.crimsonPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Color.fromARGB(255, 15, 15, 15)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const BMICalculatorInputPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 0, 106, 194),
                onPrimary: Colors.white,
                side: BorderSide(color: Colors.white, width: 2),
                minimumSize: Size(237, 58),
              ),
              child: Text(
                'Hitung Kembali',
                style: GoogleFonts.crimsonPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Klasifikasi',
                      style: GoogleFonts.crimsonPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Icon(Icons.circle,
                                color: Color.fromARGB(255, 0, 116, 217),
                                size: 20),
                            Icon(Icons.circle,
                                color: Color.fromARGB(255, 63, 156, 53),
                                size: 20),
                            Icon(Icons.circle,
                                color: Color.fromARGB(255, 234, 171, 0),
                                size: 20),
                            Icon(Icons.circle,
                                color: Color.fromARGB(255, 255, 61, 61),
                                size: 20),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Underweight :'),
                            Text('Normal :'),
                            Text('Overweight :'),
                            Text('Obese :'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 48.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'BMI',
                      style: GoogleFonts.crimsonPro(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text('< 18.5'),
                    Text('18.5 - 24.9'),
                    Text('25.0 - 29.9'),
                    Text('>= 30'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  double calculateBMI() {
    bmi = widget.berat / ((widget.tinggi * 0.01) * (widget.tinggi * 0.01));
    return bmi;
  }
}
