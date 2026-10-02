import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import 'piramida_screen.dart';
import 'segitiga_screen.dart';
import 'konversi_waktu_screen.dart';
import 'cek_hari_screen.dart';

// Halaman utama / dashboard menu aplikasi
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Utama'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Selamat Datang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withValues(alpha: 0.3),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Selamat Datang! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Pilih menu di bawah ini untuk memulai perhitungan geometris atau konversi.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            const Text(
              'Menu Fitur Utama',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16.0),

            // Grid 4 Menu Utama
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                MenuCard(
                  title: 'Menu Piramida',
                  subtitle: 'Volume & Keliling',
                  icon: Icons.change_history,
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PiramidaScreen(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  title: 'Menu Segitiga',
                  subtitle: 'Luas & Keliling',
                  icon: Icons.interests,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SegitigaScreen(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  title: 'Konversi Waktu',
                  subtitle: 'WIB, MYT, & EDT',
                  icon: Icons.access_time_filled,
                  color: Colors.amber.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KonversiWaktuScreen(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  title: 'Cek Hari',
                  subtitle: 'Senin - Minggu',
                  icon: Icons.calendar_today,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CekHariScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
