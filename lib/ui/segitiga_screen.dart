import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import '../controllers/segitiga_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_card.dart';

// Enum jenis segitiga
enum JenisSegitiga { samaKaki, samaSisi, sikuSiku }

// Halaman perhitungan luas dan keliling segitiga QA
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

  // Validator input QA (Batas 12 digit angka sebelum desimal)
  String? _validateInput(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label tidak boleh kosong';
    }

    final cleaned = value.trim().replaceAll(',', '.');
    final parts = cleaned.split('.');
    final integerPart = parts[0].replaceAll(RegExp(r'\D'), '');

    if (integerPart.length > 12) {
      return 'Maksimal 12 digit angka sebelum koma/desimal';
    }

    try {
      final Decimal dec = Decimal.parse(cleaned);
      if (dec <= Decimal.zero) {
        return 'Masukkan angka positif yang valid';
      }
    } catch (_) {
      return 'Format angka tidak valid';
    }
    return null;
  }

  // Menjalankan kalkulasi luas dan keliling segitiga
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      SegitigaResult res;

      switch (_selectedJenis) {
        case JenisSegitiga.samaKaki:
          res = _controller.hitungSamaKaki(
            alasStr: _alasController.text.trim(),
            sisiSamaStr: _sisiSamaController.text.trim(),
            tinggiStr: _tinggiController.text.trim(),
          );
          break;
        case JenisSegitiga.samaSisi:
          res = _controller.hitungSamaSisi(
            sisiStr: _sisiSamaSisiController.text.trim(),
          );
          break;
        case JenisSegitiga.sikuSiku:
          res = _controller.hitungSikuSiku(
            alasStr: _alasController.text.trim(),
            tinggiStr: _tinggiController.text.trim(),
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
        title: const Text('Kalkulator Segitiga QA'),
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

              // Input Sesuai Jenis Segitiga dengan QA 12 Digit Sebelum Koma
              if (_selectedJenis == JenisSegitiga.samaSisi) ...[
                CustomTextField(
                  controller: _sisiSamaSisiController,
                  label: 'Panjang Sisi (cm)',
                  hint: 'Masukkan sisi (Maks 12 digit sebelum koma)',
                  icon: Icons.straighten,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                    Integer12DigitLimitingFormatter(maxIntegerDigits: 12),
                  ],
                  validator: (val) => _validateInput(val, 'Panjang sisi'),
                ),
              ] else if (_selectedJenis == JenisSegitiga.samaKaki) ...[
                CustomTextField(
                  controller: _alasController,
                  label: 'Panjang Alas (cm)',
                  hint: 'Masukkan alas (Maks 12 digit sebelum koma)',
                  icon: Icons.square_foot,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                    Integer12DigitLimitingFormatter(maxIntegerDigits: 12),
                  ],
                  validator: (val) => _validateInput(val, 'Panjang alas'),
                ),
                CustomTextField(
                  controller: _sisiSamaController,
                  label: 'Panjang Sisi Sama Kaki (cm)',
                  hint: 'Masukkan sisi sama kaki (Maks 12 digit sebelum koma)',
                  icon: Icons.straighten,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                    Integer12DigitLimitingFormatter(maxIntegerDigits: 12),
                  ],
                  validator: (val) => _validateInput(val, 'Sisi sama kaki'),
                ),
                CustomTextField(
                  controller: _tinggiController,
                  label: 'Tinggi Segitiga (cm)',
                  hint: 'Masukkan tinggi (Maks 12 digit sebelum koma)',
                  icon: Icons.height,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                    Integer12DigitLimitingFormatter(maxIntegerDigits: 12),
                  ],
                  validator: (val) => _validateInput(val, 'Tinggi segitiga'),
                ),
              ] else if (_selectedJenis == JenisSegitiga.sikuSiku) ...[
                CustomTextField(
                  controller: _alasController,
                  label: 'Panjang Alas (cm)',
                  hint: 'Masukkan alas (Maks 12 digit sebelum koma)',
                  icon: Icons.square_foot,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                    Integer12DigitLimitingFormatter(maxIntegerDigits: 12),
                  ],
                  validator: (val) => _validateInput(val, 'Panjang alas'),
                ),
                CustomTextField(
                  controller: _tinggiController,
                  label: 'Tinggi Segitiga (cm)',
                  hint: 'Masukkan tinggi (Maks 12 digit sebelum koma)',
                  icon: Icons.height,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                    Integer12DigitLimitingFormatter(maxIntegerDigits: 12),
                  ],
                  validator: (val) => _validateInput(val, 'Tinggi segitiga'),
                ),
              ],

              const SizedBox(height: 12.0),

              // Tombol Hitung & Reset
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Hitung Presisi Murni',
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

              // Hasil perhitungan responsif
              if (_result != null)
                ResultCard(
                  title: 'Hasil ${_result!.deskripsi}',
                  icon: Icons.interests,
                  accentColor: Colors.teal,
                  items: [
                    _buildResultRow(
                      'Luas Segitiga',
                      '${_result!.luas} cm²',
                      isHighlight: true,
                    ),
                    const SizedBox(height: 8.0),
                    _buildResultRow(
                      'Keliling Segitiga',
                      '${_result!.keliling} cm',
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

  // Widget helper baris hasil responsif tanpa overflow
  Widget _buildResultRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHighlight ? 14.0 : 13.0,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: isHighlight ? Colors.teal : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isHighlight
                  ? Colors.teal.withValues(alpha: 0.08)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: isHighlight
                    ? Colors.teal.withValues(alpha: 0.2)
                    : Colors.grey.shade300,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isHighlight ? 16.0 : 14.0,
                    fontWeight: FontWeight.bold,
                    color: isHighlight ? Colors.teal : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
