import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/pages/macronutrient_calculator_result_page.dart';
import 'package:nutrisee/utils/validator.dart';

class MacronutrientCalculatorInputPage extends StatefulWidget {
  const MacronutrientCalculatorInputPage({super.key});

  @override
  State<MacronutrientCalculatorInputPage> createState() =>
      _MacronutrientCalculatorInputPageState();
}

class _MacronutrientCalculatorInputPageState
    extends State<MacronutrientCalculatorInputPage> {
  final _macroKey = GlobalKey<FormState>();
  final _umurTextController = TextEditingController();
  final _tinggiTextController = TextEditingController();
  final _beratTextController = TextEditingController();

  final _focusUmur = FocusNode();
  final _focusTinggi = FocusNode();
  final _focusBerat = FocusNode();

  String _gender = 'Laki-laki';

  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusUmur.unfocus();
        _focusTinggi.unfocus();
        _focusBerat.unfocus();
      },
      child: Scaffold(
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
                  'Macronutrient Calculator ini mengubah input jumlah karbohidrat, protein, dan lemak yang Anda masukkan menjadi informasi yang lebih komprehensif, memberikan Anda jumlah kalori harian yang sesuai dengan kebutuhan nutrisi Anda. Dengan demikian, Anda dapat merencanakan pola makan yang seimbang dan mendukung tujuan kesehatan Anda.',
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
                              'Hitung Macronutrient Anda',
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
                        key: _macroKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _umurTextController,
                              focusNode: _focusUmur,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  Validator.validateNumber(number: value),
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
                              validator: (value) =>
                                  Validator.validateNumber(number: value),
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
                              validator: (value) =>
                                  Validator.validateNumber(number: value),
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

                                            int _umur = int.parse(
                                                _umurTextController.text);
                                            double _tinggi = double.parse(
                                                _tinggiTextController.text);
                                            double _berat = double.parse(
                                                _beratTextController.text);

                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MacronutrientCalculatorResultPage(
                                                        umur: _umur,
                                                        tinggi: _tinggi,
                                                        berat: _berat,
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
                                            'Hitung Macro',
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
                  'Jenis zat gizi makro yang perlu Anda hitung kebutuhannya yaitu karbohidrat, protein, dan lemak. Setiap zat gizi makro mempunyai persentase tertentu dari total kebutuhan kalori Anda. Berikut penjabarannya.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.rubik(),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                    '1. Kebutuhan protein adalah sebesar 10 – 15% dari kebutuhan kalori total. Setelah menemukan besarnya kalori untuk protein, ubahlah ke dalam gram. Protein sebanyak 1 gram setara dengan 4 kalori.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.rubik()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                    '2. Kebutuhan lemak adalah sebesar 10 – 25% dari kebutuhan kalori total. Lemak sebanyak 1 gram setara dengan 9 kalori.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.rubik()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                    '3. Kebutuhan karbohidrat adalah sebesar 60 – 75% dari kebutuhan kalori total. Karbohidrat sebanyak 1 gram setara dengan 4 kalori.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.rubik()),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
