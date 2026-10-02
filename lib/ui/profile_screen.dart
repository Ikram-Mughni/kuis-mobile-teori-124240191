import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import '../models/user_model.dart';

// Halaman profil data diri pengguna
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = ProfileController();
  late Future<UserModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _controller.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<UserModel>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data profil: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header profil dengan foto
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 30.0, top: 10.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 54.0,
                          backgroundColor: Colors.indigo.shade100,
                          child: ClipOval(
                            child: user.fotoUrl.startsWith('http')
                                ? Image.network(
                                    user.fotoUrl,
                                    width: 108.0,
                                    height: 108.0,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 60.0,
                                        color: Colors.indigo,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    user.fotoUrl,
                                    width: 108.0,
                                    height: 108.0,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 60.0,
                                        color: Colors.indigo,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        user.nama,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'NIM: ${user.nim}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),

                // Detail informasi diri (Statis, tanpa textfield)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Pribadi',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 12.0),

                      _buildInfoCard(
                        icon: Icons.badge_outlined,
                        title: 'Nama Lengkap',
                        value: user.nama,
                      ),
                      _buildInfoCard(
                        icon: Icons.numbers_outlined,
                        title: 'NIM',
                        value: user.nim,
                      ),
                      _buildInfoCard(
                        icon: Icons.cake_outlined,
                        title: 'Tempat & Tanggal Lahir',
                        value: user.tempatTanggalLahir,
                      ),
                      _buildInfoCard(
                        icon: Icons.sports_esports_outlined,
                        title: 'Hobi',
                        value: user.hobi,
                      ),

                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget helper kartu info profil
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo.withValues(alpha: 0.1),
              child: Icon(icon, color: Colors.indigo),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
