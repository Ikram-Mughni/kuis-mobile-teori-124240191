// Model hasil penentuan nama hari
class DayResult {
  final int nomor;
  final String namaHari;
  final String jenisHari;
  final String deskripsi;

  DayResult({
    required this.nomor,
    required this.namaHari,
    required this.jenisHari,
    required this.deskripsi,
  });
}

// Controller logika bisnis pemeriksaan hari
class DayController {
  // Daftar nama hari (1 = Senin ... 7 = Minggu)
  final List<String> _daftarHari = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  // Mendapatkan data hari berdasarkan nomor input
  DayResult cekHari(int angka) {
    if (angka < 1) {
      throw ArgumentError("Nomor hari harus lebih besar dari 0");
    }

    // Menghitung indeks siklus hari
    final int index = (angka - 1) % 7;
    final String namaHari = _daftarHari[index];

    // Menentukan status hari kerja atau akhir pekan
    final bool isWeekend = (index == 5 || index == 6);
    final String jenisHari = isWeekend ? "Akhir Pekan (Weekend)" : "Hari Kerja (Weekday)";
    final String deskripsi = isWeekend
        ? "Waktunya bersantai dan memulihkan energi."
        : "Tetap produktif dan jalani hari dengan penuh semangat.";

    return DayResult(
      nomor: angka,
      namaHari: namaHari,
      jenisHari: jenisHari,
      deskripsi: deskripsi,
    );
  }
}
