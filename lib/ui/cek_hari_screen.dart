import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/day_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_card.dart';

// Halaman pemeriksaan nama hari QA rentang 1-7
class CekHariScreen extends StatefulWidget {
  const CekHariScreen({super.key});

  @override
  State<CekHariScreen> createState() => _CekHariScreenState();
}

class _CekHariScreenState extends State<CekHariScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final DayController _controller = DayController();

  DayResult? _result;

  // Validator input QA (Hanya boleh rentang 1 sampai 7)
  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor hari tidak boleh kosong';
    }
    final int? val = int.tryParse(value.trim());
    if (val == null || val < 1 || val > 7) {
      return 'Hanya boleh input angka 1-7';
    }
    return null;
  }

  // Menjalankan cek hari dari nomor input 1-7
  void _checkDay() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _result = _controller.cekHari(_numberController.text.trim());
      });
    }
  }

  // Mengisi nomor preset hari (1-7)
  void _setPreset(int nomor) {
    _numberController.text = nomor.toString();
    _checkDay();
  }

  // Mereset form dan hasil
  void _reset() {
    _numberController.clear();
    setState(() {
      _result = null;
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Nama Hari QA'),
        backgroundColor: Colors.purple,
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
                'Pemeriksa Nama Hari',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Masukkan nomor hari dari 1 (Senin) sampai 7 (Minggu).',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20.0),

              // Input nomor hari dengan QA Rentang 1-7 dan Limit 1 Digit
              CustomTextField(
                controller: _numberController,
                label: 'Nomor Hari (1 - 7)',
                hint: 'Masukkan angka 1-7',
                icon: Icons.pin,
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                validator: _validateInput,
              ),

              const SizedBox(height: 8.0),

              // Quick Preset Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (index) {
                    final int dayNum = index + 1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        label: Text('Hari $dayNum'),
                        backgroundColor: Colors.purple.withValues(alpha: 0.08),
                        labelStyle: const TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                        onPressed: () => _setPreset(dayNum),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20.0),

              // Tombol periksa dan reset
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Periksa Hari',
                      icon: Icons.search,
                      backgroundColor: Colors.purple,
                      onPressed: _checkDay,
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

              // Kartu hasil pemeriksaan responsif tanpa overflow
              if (_result != null)
                ResultCard(
                  title: 'Hasil Pemeriksaan Hari',
                  icon: Icons.calendar_today,
                  accentColor: Colors.purple,
                  items: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nomor Input:',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _result!.nomor,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _result!.namaHari,
                              style: const TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                _result!.jenisHari,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      _result!.deskripsi,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
