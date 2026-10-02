import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

// Utilitas kalkulasi presisi tinggi dan format angka tanpa double
class NumberHelper {
  // Format angka Indonesia dengan pemisah ribuan titik
  static String formatNumber(String rawNumberStr) {
    if (rawNumberStr.isEmpty) return '0';

    final parts = rawNumberStr.split('.');
    String intPart = parts[0];
    String? decPart = parts.length > 1 ? parts[1] : null;

    bool isNegative = intPart.startsWith('-');
    if (isNegative) {
      intPart = intPart.substring(1);
    }

    final String formattedInt = intPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    final String sign = isNegative ? '-' : '';
    if (decPart != null && decPart.isNotEmpty) {
      return '$sign$formattedInt,$decPart';
    }
    return '$sign$formattedInt';
  }

  // Akar kuadrat Decimal murni presisi tinggi tanpa double
  static Decimal decimalSqrt(Decimal x, {int scale = 4}) {
    if (x < Decimal.zero) throw ArgumentError('Angka negatif');
    if (x == Decimal.zero) return Decimal.zero;

    Decimal guess = (x / Decimal.fromInt(2)).toDecimal(scaleOnInfinitePrecision: scale + 6);
    if (guess <= Decimal.zero) guess = Decimal.one;

    final Decimal two = Decimal.fromInt(2);
    for (int i = 0; i < 30; i++) {
      final Rational ratNext = (guess + (x / guess).toDecimal(scaleOnInfinitePrecision: scale + 6)) / two;
      final Decimal nextGuess = ratNext.toDecimal(scaleOnInfinitePrecision: scale + 6);
      if ((nextGuess - guess).abs() < Decimal.parse('0.00001')) {
        guess = nextGuess;
        break;
      }
      guess = nextGuess;
    }
    return guess;
  }
}
