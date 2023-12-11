import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/pages/bmi_calculator_result_page.dart';

class BMICalculatorInputPage extends StatefulWidget {
  const BMICalculatorInputPage({super.key});

  @override
  State<BMICalculatorInputPage> createState() => _BMICalculatorInputPageState();
}

class _BMICalculatorInputPageState extends State<BMICalculatorInputPage> {
  final _bmiKey = GlobalKey<FormState>();
  final _tinggiTextController = TextEditingController();
  final _beratTextController = TextEditingController();

  final _focusTinggi = FocusNode();
  final _focusBerat = FocusNode();

  String selectedGender = '';

  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusTinggi.unfocus();
        _focusBerat.unfocus();
      },
      child: Scaffold(
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
                  'Body Mass Index (BMI) adalah salah satu cara untuk  mengukur ukuran tubuh. BMI dapat dihitung dengan menggunakan kalkulator BMI dan mengelompokkan  orang sebagai kurus, normal, atau kelebihan berat badan berdasarkan tinggi dan berat badan mereka',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.rubik(),
                ),
              ),
              Card(
                color: Color.fromARGB(255, 0, 120, 74),
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
                              'Temukan BMI Anda',
                              style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Color.fromARGB(255, 250, 250, 250)),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey),
                      Form(
                        key: _bmiKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _tinggiTextController,
                              focusNode: _focusTinggi,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                label: Text(
                                  'Tinggi (cm)',
                                  style: GoogleFonts.rubik(
                                    color: Color.fromARGB(255, 21, 21, 21),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _beratTextController,
                              focusNode: _focusBerat,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                label: Text(
                                  'Berat (kg)',
                                  style: GoogleFonts.rubik(
                                    color: Color.fromARGB(255, 21, 21, 21),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = 'Laki-laki';
                                    });
                                  },
                                  child: Text(
                                    'Laki-laki',
                                    style: GoogleFonts.crimsonPro(
                                      color: Color.fromARGB(255, 21, 21, 21),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: selectedGender == 'Laki-laki'
                                        ? Colors.blue
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = 'Perempuan';
                                    });
                                  },
                                  child: Text(
                                    'Perempuan',
                                    style: GoogleFonts.crimsonPro(
                                      color: Color.fromARGB(255, 21, 21, 21),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: selectedGender == 'Perempuan'
                                        ? Colors.pink
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            _isProcessing
                                ? const CircularProgressIndicator()
                                : Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            _focusTinggi.unfocus();
                                            _focusBerat.unfocus();

                                            double _tinggi = double.parse(
                                                _tinggiTextController.text);
                                            double _berat = double.parse(
                                                _beratTextController.text);

                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BMICalculatorResultPage(
                                                        tinggi: _tinggi,
                                                        berat: _berat),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Color.fromARGB(
                                                255, 0, 106, 194),
                                            onPrimary: Colors.white,
                                            side: BorderSide(
                                                color: Colors.white, width: 2),
                                            minimumSize: Size(237, 58),
                                          ),
                                          child: Text(
                                            'Hitung BMI',
                                            style: GoogleFonts.crimsonPro(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Body Mass Index (BMI) adalah salah satu cara untuk  mengukur ukuran tubuh. BMI dapat dihitung dengan menggunakan kalkulator BMI dan mengelompokkan  orang sebagai kurus, normal, atau kelebihan berat badan berdasarkan tinggi dan berat badan mereka',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.rubik(),
                ),
              ),
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
                      Text('Underweight :'),
                      Text('Normal :'),
                      Text('Overweight :'),
                      Text('Obese :'),
                    ],
                  ),
                  SizedBox(width: 36.0),
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
      ),
    );
  }
}
