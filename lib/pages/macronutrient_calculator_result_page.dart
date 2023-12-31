import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/pages/macronutrient_calculator_input_page.dart';

class MacronutrientCalculatorResultPage extends StatefulWidget {
  final int umur;
  final double tinggi;
  final double berat;
  final String gender;

  const MacronutrientCalculatorResultPage(
      {super.key,
      required this.umur,
      required this.tinggi,
      required this.berat,
      required this.gender});

  @override
  State<MacronutrientCalculatorResultPage> createState() =>
      _MacronutrientCalculatorResultPageState();
}

class _MacronutrientCalculatorResultPageState
    extends State<MacronutrientCalculatorResultPage> {
  @override
  Widget build(BuildContext context) {
    String gender = widget.gender;
    int umur = widget.umur;
    double tinggi = widget.tinggi;
    double berat = widget.berat;
    String resultCalories = resultDailyCalories().toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Macro Calculator'),
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
                'Hasil Macro Anda',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Anda adalah seorang $gender berumur $umur tahun yang memiliki tinggi $tinggi cm dan berat $berat kg.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Status',
                textAlign: TextAlign.justify,
                style: GoogleFonts.crimsonPro(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(178, 229, 229, 229),
              margin: EdgeInsets.only(left: 100.0, right: 100.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Text(
                            resultCalories,
                            style: GoogleFonts.crimsonPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          Text(
                            'Kalori per hari',
                            style: GoogleFonts.crimsonPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Dengan demikian, kebutuhan zat gizi makro Anda adalah sebagai berikut.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                  '1. Kebutuhan protein: 15% x ${resultDailyCalories().toStringAsFixed(0)} kalori = ${resultProtein().toStringAsFixed(0)} kalori. Ubah menjadi gram dengan cara membagi ${resultProtein().toStringAsFixed(0)} dengan 4. Hasilnya, Anda membutuhkan ${(resultProtein() / 4).toStringAsFixed(0)} gram protein.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.rubik()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                  '2. Kebutuhan lemak: 20% x ${resultDailyCalories().toStringAsFixed(0)} kalori = ${resultFats().toStringAsFixed(0)} kalori. Ubah menjadi gram dengan cara membagi ${resultFats().toStringAsFixed(0)} dengan 9. Hasilnya, Anda membutuhkan ${(resultFats() / 9).toStringAsFixed(0)} gram lemak.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.rubik()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                  '3. Kebutuhan karbohidrat: 65% x ${resultDailyCalories().toStringAsFixed(0)} kalori = ${resultCarbs().toStringAsFixed(0)} kalori. Ubah menjadi gram dengan cara membagi ${resultCarbs().toStringAsFixed(0)} dengan 4. Hasilnya, Anda membutuhkan ${(resultCarbs() / 4).toStringAsFixed(0)} gram karbohidrat.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.rubik()),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const MacronutrientCalculatorInputPage(),
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
                'Hitung Macro Kembali',
                style: GoogleFonts.crimsonPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  double calculateBMI() {
    double bmi =
        widget.berat / ((widget.tinggi * 0.01) * (widget.tinggi * 0.01));
    return bmi;
  }

  double resultDailyCalories() {
    double result = 0.0;
    if (widget.gender == 'Laki-laki') {
      result =
          (10 * widget.berat) + (6.25 * widget.tinggi) - (5 * widget.umur) + 5;
    } else if (widget.gender == 'Perempuan') {
      result = (10 * widget.berat) +
          (6.25 * widget.tinggi) -
          (5 * widget.umur) -
          161;
    } else {
      result = 0;
    }

    // if (widget.aktivitas == 'Sedentary (office job)') {
    //   result = result * 1.2;
    // } else if (widget.aktivitas == 'Light Exercise') {
    //   result = result * 1.375;
    // } else if (widget.aktivitas == 'Moderate Exercise') {
    //   result = result * 1.55;
    // } else if (widget.aktivitas == 'Heavy Exercise') {
    //   result = result * 1.725;
    // } else if (widget.aktivitas == 'Athlete') {
    //   result = result * 1.9;
    // } else {
    //   result = result;
    // }
    return result;
  }

  double resultProtein() {
    double result = 0.0;
    result = resultDailyCalories() * 0.15;
    return result;
  }

  double resultFats() {
    double result = 0.0;
    result = resultDailyCalories() * 0.20;
    return result;
  }

  double resultCarbs() {
    double result = 0.0;
    result = resultDailyCalories() * 0.65;
    return result;
  }
}
