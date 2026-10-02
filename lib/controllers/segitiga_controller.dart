import 'dart:math';

// Data hasil perhitungan segitiga
class SegitigaResult {
  final double luas;
  final double keliling;
  final String deskripsi;

  SegitigaResult({
    required this.luas,
    required this.keliling,
    required this.deskripsi,
  });
}

// Controller logika bisnis perhitungan segitiga
class SegitigaController {
  // Menghitung luas dan keliling segitiga sama kaki
  SegitigaResult hitungSamaKaki({
    required double alas,
    required double sisiSama,
    required double tinggi,
  }) {
    final double luas = 0.5 * alas * tinggi;
    final double keliling = alas + (2 * sisiSama);
    return SegitigaResult(
      luas: luas,
      keliling: keliling,
      deskripsi: "Segitiga Sama Kaki",
    );
  }

  // Menghitung luas dan keliling segitiga sama sisi
  SegitigaResult hitungSamaSisi({
    required double sisi,
  }) {
    final double luas = (sqrt(3) / 4) * pow(sisi, 2);
    final double keliling = 3 * sisi;
    return SegitigaResult(
      luas: luas,
      keliling: keliling,
      deskripsi: "Segitiga Sama Sisi",
    );
  }

  // Menghitung luas dan keliling segitiga siku-siku
  SegitigaResult hitungSikuSiku({
    required double alas,
    required double tinggi,
  }) {
    final double sisiMiring = sqrt(pow(alas, 2) + pow(tinggi, 2));
    final double luas = 0.5 * alas * tinggi;
    final double keliling = alas + tinggi + sisiMiring;
    return SegitigaResult(
      luas: luas,
      keliling: keliling,
      deskripsi: "Segitiga Siku-siku (Sisi Miring: ${sisiMiring.toStringAsFixed(2)})",
    );
  }
}
