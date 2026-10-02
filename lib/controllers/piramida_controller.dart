import 'package:decimal/decimal.dart';
import '../helpers/number_helper.dart';

// Data hasil perhitungan piramida murni Decimal tanpa double
class PiramidaResult {
  final String volume;
  final String kelilingAlas;
  final String totalRusuk;
  final String luasPermukaan;

  PiramidaResult({
    required this.volume,
    required this.kelilingAlas,
    required this.totalRusuk,
    required this.luasPermukaan,
  });
}

// Controller logika bisnis perhitungan piramida murni Decimal tanpa double
class PiramidaController {
  // Perhitungan volume dan keliling piramida murni Decimal
  PiramidaResult hitungPiramida({
    required String sisiAlasStr,
    required String tinggiStr,
  }) {
    final Decimal s = Decimal.parse(sisiAlasStr.replaceAll(',', '.'));
    final Decimal t = Decimal.parse(tinggiStr.replaceAll(',', '.'));

    // Luas alas presisi tinggi Decimal
    final Decimal luasAlas = s * s;

    // Perhitungan volume tanpa double
    final Decimal volumeDecimal = ((luasAlas * t) / Decimal.fromInt(3))
        .toDecimal(scaleOnInfinitePrecision: 4);

    // Perhitungan keliling alas tanpa double
    final Decimal kelilingAlasDecimal = Decimal.fromInt(4) * s;

    // Perhitungan tinggi miring selimut tanpa double
    final Decimal sHalf = (s / Decimal.fromInt(2)).toDecimal(scaleOnInfinitePrecision: 6);
    final Decimal inner = (sHalf * sHalf) + (t * t);
    final Decimal tinggiMiring = NumberHelper.decimalSqrt(inner, scale: 4);

    // Perhitungan total panjang rusuk tanpa double
    final Decimal totalRusukDecimal = (Decimal.fromInt(4) * s) + (Decimal.fromInt(4) * tinggiMiring);

    // Perhitungan luas permukaan tanpa double
    final Decimal luasPermukaanDecimal = luasAlas + (Decimal.fromInt(2) * s * tinggiMiring);

    return PiramidaResult(
      volume: NumberHelper.formatNumber(volumeDecimal.toString()),
      kelilingAlas: NumberHelper.formatNumber(kelilingAlasDecimal.toString()),
      totalRusuk: NumberHelper.formatNumber(totalRusukDecimal.toString()),
      luasPermukaan: NumberHelper.formatNumber(luasPermukaanDecimal.toString()),
    );
  }
}
