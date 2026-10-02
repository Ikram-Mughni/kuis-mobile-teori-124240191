import 'dart:async';
import 'package:flutter/material.dart';
import '../controllers/time_controller.dart';
import '../models/time_zone_model.dart';
import '../widgets/result_card.dart';

// Halaman konversi zona waktu
class KonversiWaktuScreen extends StatefulWidget {
  const KonversiWaktuScreen({super.key});

  @override
  State<KonversiWaktuScreen> createState() => _KonversiWaktuScreenState();
}

class _KonversiWaktuScreenState extends State<KonversiWaktuScreen> {
  final TimeController _controller = TimeController();

  DateTime _selectedTime = DateTime.now();
  List<TimeZoneModel> _convertedTimes = [];
  Timer? _timer;
  bool _isLive = true;

  @override
  void initState() {
    super.initState();
    _updateConvertedTimes();
    _startLiveTimer();
  }

  // Memulai timer pembaruan waktu otomatis
  void _startLiveTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isLive) {
        setState(() {
          _selectedTime = DateTime.now();
          _updateConvertedTimes();
        });
      }
    });
  }

  // Memperbarui daftar waktu terkonversi
  void _updateConvertedTimes() {
    _convertedTimes = _controller.konversiWaktu(_selectedTime);
  }

  // Membuka pemilih waktu kustom
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );

    if (picked != null) {
      final now = DateTime.now();
      setState(() {
        _isLive = false;
        _selectedTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
        _updateConvertedTimes();
      });
    }
  }

  // Mengembalikan ke waktu live saat ini
  void _resetToLive() {
    setState(() {
      _isLive = true;
      _selectedTime = DateTime.now();
      _updateConvertedTimes();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Waktu'),
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Konversi Zona Waktu Internasional',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Menampilkan perbandingan waktu Indonesia (WIB), Malaysia (MYT), dan Kanada (EDT).',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20.0),

            // Mode kontrol waktu
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLive ? 'Mode: Waktu Nyata (Real-time)' : 'Mode: Waktu Kustom',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          _isLive
                              ? 'Waktu berjalan otomatis setiap detik'
                              : 'Waktu terkunci pada input pengguna',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.access_time, color: Colors.amber),
                          onPressed: () => _selectTime(context),
                          tooltip: 'Pilih Waktu',
                        ),
                        if (!_isLive)
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.green),
                            onPressed: _resetToLive,
                            tooltip: 'Reset ke Real-time',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Daftar kartu konversi waktu
            ..._convertedTimes.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ResultCard(
                    title: item.label,
                    icon: _getIconForZone(item.label),
                    accentColor: _getColorForZone(item.label),
                    items: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.timeZoneName,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                item.formattedTime,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.language,
                            size: 36.0,
                            color: _getColorForZone(item.label).withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // Icon helper sesuai zona
  IconData _getIconForZone(String label) {
    if (label.contains('WIB')) return Icons.flag;
    if (label.contains('Malaysia')) return Icons.location_city;
    return Icons.public;
  }

  // Color helper sesuai zona
  Color _getColorForZone(String label) {
    if (label.contains('WIB')) return Colors.red.shade700;
    if (label.contains('Malaysia')) return Colors.blue.shade700;
    return Colors.amber.shade900;
  }
}
