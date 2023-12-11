import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/pages/tdee_calculator_input_page.dart';

class TDEECalculatorResultPage extends StatefulWidget {
  final int umur;
  final double tinggi;
  final double berat;
  final String aktivitas;
  final double bodyfat;
  final String gender;
  const TDEECalculatorResultPage(
      {super.key,
      required this.umur,
      required this.tinggi,
      required this.berat,
      required this.aktivitas,
      required this.bodyfat,
      required this.gender});

  @override
  State<TDEECalculatorResultPage> createState() =>
      _TDEECalculatorResultPageState();
}

class _TDEECalculatorResultPageState extends State<TDEECalculatorResultPage> {
  @override
  Widget build(BuildContext context) {
    String gender = widget.gender;
    int umur = widget.umur;
    double tinggi = widget.tinggi;
    double berat = widget.berat;
    String aktivitas = widget.aktivitas;
    double bodyfat = widget.bodyfat;
    String resultCalories = resultDailyCalories().toStringAsFixed(0);
    String deficitCalories = (resultDailyCalories() - 500).toStringAsFixed(0);
    String surplusCalories = (resultDailyCalories() + 500).toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: Text('TDEE Calculator'),
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
                'Hasil TDEE Anda',
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
                'Anda adalah seorang $gender berumur $umur tahun yang memiliki tinggi $tinggi cm dan berat $berat kg dengan aktivitas $aktivitas serta memiliki bodyfat $bodyfat.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Status TDEE Anda',
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
                            resultDailyCalories().toStringAsFixed(0),
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
                          Divider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          Text(
                            (resultDailyCalories().toDouble() * 7)
                                .toStringAsFixed(0),
                            style: GoogleFonts.crimsonPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          Text(
                            'Kalori per minggu',
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TDEECalculatorInputPage(),
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
                'Hitung TDEE Kembali',
                style: GoogleFonts.crimsonPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Berdasarkan data anda, estimasi terbaik untuk TDEE anda adalah $resultCalories kalori per hari berdasarkan Formula Mifflin-St Jeor, yang dikenal sebagai formula paling akurat. Tabel dibawah ini memperlihatkan perbedaan jika anda memilih aktivitas yang berbeda.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Basal Metabolic Rate',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            resultDailyCalories().toStringAsFixed(0) +
                                " kalori per hari",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sedentary',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            (resultDailyCalories() * 1.2).toStringAsFixed(0) +
                                " kalori per hari",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Light Exercise',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            (resultDailyCalories() * 1.375).toStringAsFixed(0) +
                                " kalori per hari",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Moderate Exercise',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            (resultDailyCalories() * 1.55).toStringAsFixed(0) +
                                " kalori per hari",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Heavy Exercise',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            (resultDailyCalories() * 1.725).toStringAsFixed(0) +
                                " kalori per hari",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Athlete',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            (resultDailyCalories() * 1.9).toStringAsFixed(0) +
                                " kalori per hari",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Berat Badan Ideal Anda : +- ' +
                    idealWeight().toStringAsFixed(0) +
                    " kg",
                textAlign: TextAlign.justify,
                style: GoogleFonts.crimsonPro(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Skor BMI Anda : ' + calculateBMI().toStringAsFixed(1),
                textAlign: TextAlign.justify,
                style: GoogleFonts.crimsonPro(
                  fontSize: 24.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Macronutrients :',
              style: GoogleFonts.rubik(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Nilai Makronutrients berikut merepresentasikan status TDEE anda yang mana adalah $resultCalories kalori per hari.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Color.fromARGB(102, 253, 246, 229),
                  child: Container(
                    width: 130.0,
                    height: 280.0,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Text(
                                  'Moderate Carb',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  '(30/35/35)',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  moderateCarbProtein().toStringAsFixed(0) +
                                      'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'Protein',
                                  style: GoogleFonts.crimsonPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  moderateCarbFats().toStringAsFixed(0) + 'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'fats',
                                  style: GoogleFonts.crimsonPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  moderateCarbCarbs().toStringAsFixed(0) + 'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'carbs',
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
                ),
                Card(
                  color: Color.fromARGB(102, 253, 246, 229),
                  child: Container(
                    width: 130.0,
                    height: 280.0,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Text(
                                  'Moderate Carb',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  '(40/40/20)',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  lowCarbProtein().toStringAsFixed(0) + 'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'Protein',
                                  style: GoogleFonts.crimsonPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  lowCarbFats().toStringAsFixed(0) + 'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'fats',
                                  style: GoogleFonts.crimsonPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  lowCarbCarbs().toStringAsFixed(0) + 'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'carbs',
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
                ),
                Card(
                  color: Color.fromARGB(102, 253, 246, 229),
                  child: Container(
                    width: 130.0,
                    height: 280.0,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Text(
                                  'Higher Carb',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  '(30/20/50)',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  highCarbProtein().toStringAsFixed(0) + 'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'Protein',
                                  style: GoogleFonts.crimsonPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  highCarbFats().toStringAsFixed(0) + 'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'fats',
                                  style: GoogleFonts.crimsonPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Text(
                                  highCarbCarbs().toStringAsFixed(0) + 'g',
                                  style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'carbs',
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
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Data tersebut berdasarkan 4 kalori per gram protein dan karbohidrat, dan 9 kalori per gram lemak.',
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Anda Ingin Cutting?',
              style: GoogleFonts.rubik(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Jika anda ingin Cutting (mengurangi berat badan), anda dapat mengonsumsi kalori sebanyak $deficitCalories kalori per hari, yang merupakan 500 kalori defisit per hari dari TDEE harian anda yaitu $resultCalories kalori per hari. Namun, anda harus menghitung kembali Macronutrients yang anda harus konsumsi.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Anda Ingin Bulking?',
              style: GoogleFonts.rubik(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Jika anda ingin Bulking (menambah berat badan), anda dapat mengonsumsi kalori sebanyak $surplusCalories kalori per hari, yang merupakan +500 kalori surplus per hari dari TDEE harian anda yaitu $resultCalories kalori per hari. Namun, anda harus menghitung kembali Macronutrients yang anda harus konsumsi.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.rubik(),
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

  double idealWeight() {
    double result = 0.0;
    if (widget.gender == 'Laki-laki') {
      result = 50 + (0.91 * (widget.tinggi - 152.4));
    } else if (widget.gender == 'Perempuan') {
      result = 45.5 + (0.91 * (widget.tinggi - 152.4));
    } else {
      result = 0;
    }
    return result;
  }

  double moderateCarbProtein() {
    double result = 0.0;
    result = resultDailyCalories() * 0.3 / 4;
    return result;
  }

  double moderateCarbFats() {
    double result = 0.0;
    result = resultDailyCalories() * 0.35 / 9;
    return result;
  }

  double moderateCarbCarbs() {
    double result = 0.0;
    result = resultDailyCalories() * 0.35 / 4;
    return result;
  }

  double lowCarbProtein() {
    double result = 0.0;
    result = resultDailyCalories() * 0.4 / 4;
    return result;
  }

  double lowCarbFats() {
    double result = 0.0;
    result = resultDailyCalories() * 0.4 / 9;
    return result;
  }

  double lowCarbCarbs() {
    double result = 0.0;
    result = resultDailyCalories() * 0.2 / 4;
    return result;
  }

  double highCarbProtein() {
    double result = 0.0;
    result = resultDailyCalories() * 0.3 / 4;
    return result;
  }

  double highCarbFats() {
    double result = 0.0;
    result = resultDailyCalories() * 0.2 / 9;
    return result;
  }

  double highCarbCarbs() {
    double result = 0.0;
    result = resultDailyCalories() * 0.5 / 4;
    return result;
  }
}
