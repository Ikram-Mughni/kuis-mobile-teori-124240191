// Model data informasi profil pengguna
class UserModel {
  final String nama;
  final String nim;
  final String tempatTanggalLahir;
  final String hobi;
  final String fotoUrl;

  UserModel({
    required this.nama,
    required this.nim,
    required this.tempatTanggalLahir,
    required this.hobi,
    required this.fotoUrl,
  });

  // Factory untuk membuat instance UserModel dari Map/JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      tempatTanggalLahir: json['tempat_tanggal_lahir'] ?? '',
      hobi: json['hobi'] ?? '',
      fotoUrl: json['foto_url'] ?? '',
    );
  }

  // Mengubah objek ke format Map JSON
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nim': nim,
      'tempat_tanggal_lahir': tempatTanggalLahir,
      'hobi': hobi,
      'foto_url': fotoUrl,
    };
  }
}
