import 'package:flutter/material.dart';
import '../controllers/day_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_card.dart';

// Halaman pemeriksaan nama hari berdasarkan nomor
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

  // Menjalankan cek hari dari nomor input
  void _checkDay() {
    if (_formKey.currentState!.validate()) {
      final int angka = int.parse(_numberController.text);
      setState(() {
        _result = _controller.cekHari(angka);
      });
    }
  }

  // Mengisi nomor preset hari
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
        title: const Text('Cek Nama Hari'),
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
                'Masukkan nomor urut hari (1 = Senin, 2 = Selasa, dst.) untuk melihat nama harinya.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20.0),

              // Input nomor hari
              CustomTextField(
                controller: _numberController,
                label: 'Nomor Hari (Contoh: 1, 2, ..., 7)',
                hint: 'Masukkan angka (1 - 7)',
                icon: Icons.pin,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor hari tidak boleh kosong';
                  }
                  final int? val = int.tryParse(value);
                  if (val == null || val <= 0) {
                    return 'Masukkan bilangan bulat positif yang valid';
                  }
                  return null;
                },
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

              // Kartu hasil pemeriksaan
              if (_result != null)
                ResultCard(
                  title: 'Hasil Pemeriksaan Hari',
                  icon: Icons.calendar_today,
                  accentColor: Colors.purple,
                  items: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nomor Input: ${_result!.nomor}',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              _result!.namaHari,
                              style: const TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 4.0,
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
                        CircleAvatar(
                          radius: 32.0,
                          backgroundColor: Colors.purple.withValues(alpha: 0.12),
                          child: Text(
                            '${_result!.nomor}',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
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
