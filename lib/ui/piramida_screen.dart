import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import '../controllers/piramida_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_card.dart';

// Halaman perhitungan volume dan keliling piramida QA
class PiramidaScreen extends StatefulWidget {
  const PiramidaScreen({super.key});

  @override
  State<PiramidaScreen> createState() => _PiramidaScreenState();
}

class _PiramidaScreenState extends State<PiramidaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _alasController = TextEditingController();
  final TextEditingController _tinggiController = TextEditingController();
  final PiramidaController _controller = PiramidaController();

  PiramidaResult? _result;

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

  // Menjalankan kalkulasi volume dan keliling
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _result = _controller.hitungPiramida(
          sisiAlasStr: _alasController.text.trim(),
          tinggiStr: _tinggiController.text.trim(),
        );
      });
    }
  }

  // Mereset isi form dan hasil
  void _reset() {
    _alasController.clear();
    _tinggiController.clear();
    setState(() {
      _result = null;
    });
  }

  @override
  void dispose() {
    _alasController.dispose();
    _tinggiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Piramida QA'),
        backgroundColor: Colors.indigo,
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
                'Piramida Alas Persegi',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Kalkulasi presisi murni Decimal (Maksimal 12 digit sebelum koma).',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20.0),

              // Input panjang alas
              CustomTextField(
                controller: _alasController,
                label: 'Panjang Sisi Alas (cm)',
                hint: 'Masukkan sisi alas (Maks 12 digit sebelum koma)',
                icon: Icons.square_foot,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                  Integer12DigitLimitingFormatter(maxIntegerDigits: 12),
                ],
                validator: (val) => _validateInput(val, 'Sisi alas'),
              ),

              // Input tinggi piramida
              CustomTextField(
                controller: _tinggiController,
                label: 'Tinggi Piramida (cm)',
                hint: 'Masukkan tinggi (Maks 12 digit sebelum koma)',
                icon: Icons.height,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                  Integer12DigitLimitingFormatter(maxIntegerDigits: 12),
                ],
                validator: (val) => _validateInput(val, 'Tinggi piramida'),
              ),

              const SizedBox(height: 12.0),

              // Tombol hitung dan reset
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Hitung Presisi Murni',
                      icon: Icons.calculate,
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

              // Kartu hasil kalkulasi responsif
              if (_result != null)
                ResultCard(
                  title: 'Hasil Perhitungan Piramida',
                  icon: Icons.change_history,
                  items: [
                    _buildResultRow(
                      'Volume Piramida',
                      '${_result!.volume} cm³',
                      isHighlight: true,
                    ),
                    const SizedBox(height: 8.0),
                    _buildResultRow(
                      'Keliling Alas',
                      '${_result!.kelilingAlas} cm',
                    ),
                    const SizedBox(height: 8.0),
                    _buildResultRow(
                      'Total Panjang Rusuk',
                      '${_result!.totalRusuk} cm',
                    ),
                    const SizedBox(height: 8.0),
                    _buildResultRow(
                      'Luas Permukaan',
                      '${_result!.luasPermukaan} cm²',
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
              color: isHighlight ? Colors.indigo : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isHighlight
                  ? Colors.indigo.withValues(alpha: 0.08)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: isHighlight
                    ? Colors.indigo.withValues(alpha: 0.2)
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
                    color: isHighlight ? Colors.indigo : Colors.black87,
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
