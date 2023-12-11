import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/pages/tdee_calculator_result_page.dart';

class TDEECalculatorInputPage extends StatefulWidget {
  const TDEECalculatorInputPage({super.key});

  @override
  State<TDEECalculatorInputPage> createState() =>
      _TDEECalculatorInputPageState();
}

class _TDEECalculatorInputPageState extends State<TDEECalculatorInputPage> {
  final _tdeeKey = GlobalKey<FormState>();
  final _umurTextController = TextEditingController();
  final _tinggiTextController = TextEditingController();
  final _beratTextController = TextEditingController();
  final _bodyfatTextController = TextEditingController();

  String _aktivitas = 'Sedentary (office job)';

  final _focusUmur = FocusNode();
  final _focusTinggi = FocusNode();
  final _focusBerat = FocusNode();
  final _focusBodyFat = FocusNode();

  String _gender = '';

  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusUmur.unfocus();
        _focusTinggi.unfocus();
        _focusBerat.unfocus();
        _focusBodyFat.unfocus();
      },
      child: Scaffold(
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
                  'Gunakan kalkulator TDEE untuk mengetahui Total Daily Energy Expenditure Anda, suatu ukuran yang menyatakan berapa banyak kalori yang Anda bakar atau butuhkan setiap hari.',
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
                              'Temukan TDEE Anda',
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
                        key: _tdeeKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _umurTextController,
                              focusNode: _focusUmur,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                label: Text(
                                  'Umur (tahun)',
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
                            SizedBox(height: 16.0),
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
                            // Dropdown
                            Text(
                              'Aktivitas',
                              style: GoogleFonts.rubik(
                                color: Color.fromARGB(255, 250, 250, 250),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: DropdownButton(
                                focusColor: Colors.white,
                                padding:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                value: _aktivitas,
                                items: [
                                  DropdownMenuItem(
                                    value: 'Sedentary (office job)',
                                    child: Text(
                                      'Sedentary (office job)',
                                      style: GoogleFonts.rubik(
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Light Exercise',
                                    child: Text(
                                      'Light Exercise (1-2 days/week)',
                                      style: GoogleFonts.rubik(
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Moderate Exercise',
                                    child: Text(
                                      'Moderate Exercise (3-5 days/week)',
                                      style: GoogleFonts.rubik(
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Heavy Exercise (6-7 days/week)',
                                    child: Text(
                                      'Heavy Exercise',
                                      style: GoogleFonts.rubik(
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Athlete',
                                    child: Text(
                                      'Athlete (2x per day)',
                                      style: GoogleFonts.rubik(
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _aktivitas = value.toString();
                                  });
                                },
                                hint: Text('Pilih Aktivitas TDEE'),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _bodyfatTextController,
                              focusNode: _focusBodyFat,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                label: Text(
                                  'Body Fat % (Optional)',
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
                                      _gender = 'Laki-laki';
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
                                    primary: _gender == 'Laki-laki'
                                        ? Colors.blue
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _gender = 'Perempuan';
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
                                    primary: _gender == 'Perempuan'
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
                                            _focusUmur.unfocus();
                                            _focusTinggi.unfocus();
                                            _focusBerat.unfocus();
                                            _focusBodyFat.unfocus();

                                            int _umur = int.parse(
                                                _umurTextController.text);
                                            double _tinggi = double.parse(
                                                _tinggiTextController.text);
                                            double _berat = double.parse(
                                                _beratTextController.text);
                                            double _bodyfat = double.parse(
                                                _bodyfatTextController.text);

                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TDEECalculatorResultPage(
                                                        umur: _umur,
                                                        tinggi: _tinggi,
                                                        berat: _berat,
                                                        aktivitas: _aktivitas,
                                                        bodyfat: _bodyfat,
                                                        gender: _gender),
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
                                            'Hitung TDEE',
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Total Daily Energy Expenditure (TDEE) Anda adalah perkiraan berapa banyak kalori yang Anda bakar setiap hari ketika latihan diperhitungkan. Ini dihitung dengan pertama-tama menentukan Basal Metabolic Rate Anda, kemudian mengalikan nilai tersebut dengan faktor aktivitas.',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.rubik(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    children: [
                      Image.network(
                        'https://tdeecalculator.net/assets/images/tdee-pie-chart.png',
                        width: 200.0,
                        height: 200.0,
                      ),
                    ],
                  ),
                  SizedBox(width: 16.0),
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
