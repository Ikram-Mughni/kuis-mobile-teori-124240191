import '../helpers/number_helper.dart';

// Model hasil penentuan nama hari dengan BigInt
class DayResult {
  final String nomor;
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

// Controller logika bisnis pemeriksaan hari BigInt tanpa double
class DayController {
  final List<String> _daftarHari = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  // Mendapatkan data hari dari angka BigInt
  DayResult cekHari(String inputStr) {
    // Parsing ke BigInt murni
    final BigInt angka = BigInt.parse(inputStr);

    if (angka <= BigInt.zero) {
      throw ArgumentError("Nomor hari harus lebih besar dari 0");
    }

    // Modulo siklus 7 hari dengan BigInt
    final BigInt indexBig = (angka - BigInt.one) % BigInt.from(7);
    final int index = indexBig.toInt();
    final String namaHari = _daftarHari[index];

    final bool isWeekend = (index == 5 || index == 6);
    final String jenisHari = isWeekend ? "Akhir Pekan (Weekend)" : "Hari Kerja (Weekday)";
    final String deskripsi = isWeekend
        ? "Waktunya bersantai dan memulihkan energi."
        : "Tetap produktif dan jalani hari dengan penuh semangat.";

    return DayResult(
      nomor: NumberHelper.formatNumber(angka.toString()),
      namaHari: namaHari,
      jenisHari: jenisHari,
      deskripsi: deskripsi,
    );
  }
}
