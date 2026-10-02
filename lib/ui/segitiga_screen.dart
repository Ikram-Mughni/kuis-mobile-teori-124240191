import 'package:flutter/material.dart';
import '../controllers/segitiga_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_card.dart';

// Enum jenis segitiga
enum JenisSegitiga { samaKaki, samaSisi, sikuSiku }

// Halaman perhitungan luas dan keliling segitiga
class SegitigaScreen extends StatefulWidget {
  const SegitigaScreen({super.key});

  @override
  State<SegitigaScreen> createState() => _SegitigaScreenState();
}

class _SegitigaScreenState extends State<SegitigaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SegitigaController _controller = SegitigaController();

  JenisSegitiga _selectedJenis = JenisSegitiga.samaKaki;

  final TextEditingController _alasController = TextEditingController();
  final TextEditingController _tinggiController = TextEditingController();
  final TextEditingController _sisiSamaController = TextEditingController();
  final TextEditingController _sisiSamaSisiController = TextEditingController();

  SegitigaResult? _result;

  // Menjalankan kalkulasi luas dan keliling segitiga
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      SegitigaResult res;

      switch (_selectedJenis) {
        case JenisSegitiga.samaKaki:
          res = _controller.hitungSamaKaki(
            alas: double.parse(_alasController.text),
            sisiSama: double.parse(_sisiSamaController.text),
            tinggi: double.parse(_tinggiController.text),
          );
          break;
        case JenisSegitiga.samaSisi:
          res = _controller.hitungSamaSisi(
            sisi: double.parse(_sisiSamaSisiController.text),
          );
          break;
        case JenisSegitiga.sikuSiku:
          res = _controller.hitungSikuSiku(
            alas: double.parse(_alasController.text),
            tinggi: double.parse(_tinggiController.text),
          );
          break;
      }

      setState(() {
        _result = res;
      });
    }
  }

  // Mereset nilai input
  void _reset() {
    _alasController.clear();
    _tinggiController.clear();
    _sisiSamaController.clear();
    _sisiSamaSisiController.clear();
    setState(() {
      _result = null;
    });
  }

  @override
  void dispose() {
    _alasController.dispose();
    _tinggiController.dispose();
    _sisiSamaController.dispose();
    _sisiSamaSisiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Segitiga'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Jenis Segitiga',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 12.0),

              // Segmented Button Pemilihan Jenis Segitiga
              SegmentedButton<JenisSegitiga>(
                segments: const [
                  ButtonSegment(
                    value: JenisSegitiga.samaKaki,
                    label: Text('Sama Kaki'),
                    icon: Icon(Icons.details),
                  ),
                  ButtonSegment(
                    value: JenisSegitiga.samaSisi,
                    label: Text('Sama Sisi'),
                    icon: Icon(Icons.change_history),
                  ),
                  ButtonSegment(
                    value: JenisSegitiga.sikuSiku,
                    label: Text('Siku-Siku'),
                    icon: Icon(Icons.architecture),
                  ),
                ],
                selected: {_selectedJenis},
                onSelectionChanged: (Set<JenisSegitiga> selection) {
                  setState(() {
                    _selectedJenis = selection.first;
                    _result = null;
                  });
                },
              ),

              const SizedBox(height: 24.0),

              // Input Sesuai Jenis Segitiga
              if (_selectedJenis == JenisSegitiga.samaSisi) ...[
                CustomTextField(
                  controller: _sisiSamaSisiController,
                  label: 'Panjang Sisi (cm)',
                  hint: 'Masukkan panjang sisi',
                  icon: Icons.straighten,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                ),
              ] else if (_selectedJenis == JenisSegitiga.samaKaki) ...[
                CustomTextField(
                  controller: _alasController,
                  label: 'Panjang Alas (cm)',
                  hint: 'Masukkan panjang alas',
                  icon: Icons.square_foot,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                ),
                CustomTextField(
                  controller: _sisiSamaController,
                  label: 'Panjang Sisi Sama Kaki (cm)',
                  hint: 'Masukkan panjang sisi sama kaki',
                  icon: Icons.straighten,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                ),
                CustomTextField(
                  controller: _tinggiController,
                  label: 'Tinggi Segitiga (cm)',
                  hint: 'Masukkan tinggi segitiga',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                ),
              ] else if (_selectedJenis == JenisSegitiga.sikuSiku) ...[
                CustomTextField(
                  controller: _alasController,
                  label: 'Panjang Alas (cm)',
                  hint: 'Masukkan panjang alas',
                  icon: Icons.square_foot,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                ),
                CustomTextField(
                  controller: _tinggiController,
                  label: 'Tinggi Segitiga (cm)',
                  hint: 'Masukkan tinggi segitiga',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                ),
              ],

              const SizedBox(height: 12.0),

              // Tombol Hitung & Reset
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Hitung Luas & Keliling',
                      icon: Icons.calculate,
                      backgroundColor: Colors.teal,
                      onPressed: _calculate,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: _reset,
                    child: const Icon(Icons.refresh),
                  ),
                ],
              ),

              const SizedBox(height: 24.0),

              // Hasil perhitungan
              if (_result != null)
                ResultCard(
                  title: 'Hasil ${_result!.deskripsi}',
                  icon: Icons.interests,
                  accentColor: Colors.teal,
                  items: [
                    _buildResultRow(
                      'Luas Segitiga',
                      '${_result!.luas.toStringAsFixed(2)} cm²',
                      isHighlight: true,
                    ),
                    const SizedBox(height: 8.0),
                    _buildResultRow(
                      'Keliling Segitiga',
                      '${_result!.keliling.toStringAsFixed(2)} cm',
                      isHighlight: true,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Validator input angka
  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Input tidak boleh kosong';
    }
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Masukkan angka positif yang valid';
    }
    return null;
  }

  // Baris item hasil
  Widget _buildResultRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHighlight ? 16.0 : 14.0,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? Colors.teal : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 16.0 : 14.0,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.teal : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
