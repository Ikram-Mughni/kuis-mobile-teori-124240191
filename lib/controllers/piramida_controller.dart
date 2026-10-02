import 'dart:math';

// Struktur data hasil perhitungan piramida
class PiramidaResult {
  final double volume;
  final double kelilingAlas;
  final double totalRusuk;
  final double luasPermukaan;

  PiramidaResult({
    required this.volume,
    required this.kelilingAlas,
    required this.totalRusuk,
    required this.luasPermukaan,
  });
}

// Controller logika bisnis perhitungan piramida
class PiramidaController {
  // Menhitung volume dan keliling piramida alas persegi
  PiramidaResult hitungPiramida({
    required double sisiAlas,
    required double tinggi,
  }) {
    // Menghitung volume piramida
    final double volume = (1.0 / 3.0) * pow(sisiAlas, 2) * tinggi;

    // Menghitung keliling alas
    final double kelilingAlas = 4 * sisiAlas;

    // Menghitung tinggi miring selimut
    final double tinggiMiring = sqrt(pow(sisiAlas / 2.0, 2) + pow(tinggi, 2));

    // Menghitung total keliling rusuk
    final double totalRusuk = (4 * sisiAlas) + (4 * tinggiMiring);

    // Menghitung luas permukaan
    final double luasPermukaan = pow(sisiAlas, 2) + (2 * sisiAlas * tinggiMiring);

    return PiramidaResult(
      volume: volume,
      kelilingAlas: kelilingAlas,
      totalRusuk: totalRusuk,
      luasPermukaan: luasPermukaan,
    );
  }
}
