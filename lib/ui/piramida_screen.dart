import 'package:flutter/material.dart';
import '../controllers/piramida_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_card.dart';

// Halaman perhitungan volume dan keliling piramida
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

  // Menjalankan kalkulasi volume dan keliling
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final double alas = double.parse(_alasController.text);
      final double tinggi = double.parse(_tinggiController.text);

      setState(() {
        _result = _controller.hitungPiramida(
          sisiAlas: alas,
          tinggi: tinggi,
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
        title: const Text('Kalkulator Piramida'),
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
                'Hitung volume, keliling alas, total rusuk, dan luas permukaan piramida.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20.0),

              // Input panjang alas
              CustomTextField(
                controller: _alasController,
                label: 'Panjang Sisi Alas (cm)',
                hint: 'Masukkan panjang sisi alas',
                icon: Icons.square_foot,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sisi alas tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Masukkan angka positif yang valid';
                  }
                  return null;
                },
              ),

              // Input tinggi piramida
              CustomTextField(
                controller: _tinggiController,
                label: 'Tinggi Piramida (cm)',
                hint: 'Masukkan tinggi piramida',
                icon: Icons.height,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tinggi piramida tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Masukkan angka positif yang valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12.0),

              // Tombol hitung dan reset
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Hitung',
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

              // Kartu hasil kalkulasi
              if (_result != null)
                ResultCard(
                  title: 'Hasil Perhitungan Piramida',
                  icon: Icons.change_history,
                  items: [
                    _buildResultRow(
                      'Volume Piramida',
                      '${_result!.volume.toStringAsFixed(2)} cm³',
                      isHighlight: true,
                    ),
                    const SizedBox(height: 8.0),
                    _buildResultRow(
                      'Keliling Alas',
                      '${_result!.kelilingAlas.toStringAsFixed(2)} cm',
                    ),
                    const SizedBox(height: 8.0),
                    _buildResultRow(
                      'Total Panjang Rusuk',
                      '${_result!.totalRusuk.toStringAsFixed(2)} cm',
                    ),
                    const SizedBox(height: 8.0),
                    _buildResultRow(
                      'Luas Permukaan',
                      '${_result!.luasPermukaan.toStringAsFixed(2)} cm²',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk baris hasil
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
              color: isHighlight ? Colors.indigo : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 16.0 : 14.0,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.indigo : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
