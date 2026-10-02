import 'package:decimal/decimal.dart';
import '../helpers/number_helper.dart';

// Data hasil perhitungan segitiga murni Decimal tanpa double
class SegitigaResult {
  final String luas;
  final String keliling;
  final String deskripsi;

  SegitigaResult({
    required this.luas,
    required this.keliling,
    required this.deskripsi,
  });
}

// Controller logika bisnis perhitungan segitiga murni Decimal tanpa double
class SegitigaController {
  // Perhitungan segitiga sama kaki murni Decimal
  SegitigaResult hitungSamaKaki({
    required String alasStr,
    required String sisiSamaStr,
    required String tinggiStr,
  }) {
    final Decimal alas = Decimal.parse(alasStr.replaceAll(',', '.'));
    final Decimal sisiSama = Decimal.parse(sisiSamaStr.replaceAll(',', '.'));
    final Decimal tinggi = Decimal.parse(tinggiStr.replaceAll(',', '.'));

    // Perhitungan luas murni Decimal
    final Decimal luasDecimal = ((alas * tinggi) / Decimal.fromInt(2))
        .toDecimal(scaleOnInfinitePrecision: 4);

    // Perhitungan keliling murni Decimal
    final Decimal kelilingDecimal = alas + (Decimal.fromInt(2) * sisiSama);

    return SegitigaResult(
      luas: NumberHelper.formatNumber(luasDecimal.toString()),
      keliling: NumberHelper.formatNumber(kelilingDecimal.toString()),
      deskripsi: "Segitiga Sama Kaki",
    );
  }

  // Perhitungan segitiga sama sisi murni Decimal
  SegitigaResult hitungSamaSisi({
    required String sisiStr,
  }) {
    final Decimal sisi = Decimal.parse(sisiStr.replaceAll(',', '.'));

    // Perhitungan keliling murni Decimal
    final Decimal kelilingDecimal = Decimal.fromInt(3) * sisi;

    // Perhitungan akar 3 presisi tinggi Decimal
    final Decimal sqrt3 = NumberHelper.decimalSqrt(Decimal.fromInt(3), scale: 6);
    final Decimal luasDecimal = ((sqrt3 * (sisi * sisi)) / Decimal.fromInt(4))
        .toDecimal(scaleOnInfinitePrecision: 4);

    return SegitigaResult(
      luas: NumberHelper.formatNumber(luasDecimal.toString()),
      keliling: NumberHelper.formatNumber(kelilingDecimal.toString()),
      deskripsi: "Segitiga Sama Sisi",
    );
  }

  // Perhitungan segitiga siku-siku murni Decimal
  SegitigaResult hitungSikuSiku({
    required String alasStr,
    required String tinggiStr,
  }) {
    final Decimal alas = Decimal.parse(alasStr.replaceAll(',', '.'));
    final Decimal tinggi = Decimal.parse(tinggiStr.replaceAll(',', '.'));

    // Perhitungan luas murni Decimal
    final Decimal luasDecimal = ((alas * tinggi) / Decimal.fromInt(2))
        .toDecimal(scaleOnInfinitePrecision: 4);

    // Perhitungan sisi miring hypotenusa murni Decimal
    final Decimal inner = (alas * alas) + (tinggi * tinggi);
    final Decimal sisiMiring = NumberHelper.decimalSqrt(inner, scale: 4);

    // Perhitungan keliling murni Decimal
    final Decimal kelilingDecimal = alas + tinggi + sisiMiring;

    return SegitigaResult(
      luas: NumberHelper.formatNumber(luasDecimal.toString()),
      keliling: NumberHelper.formatNumber(kelilingDecimal.toString()),
      deskripsi: "Segitiga Siku-siku (Hypotenusa: ${NumberHelper.formatNumber(sisiMiring.toString())})",
    );
  }
}
