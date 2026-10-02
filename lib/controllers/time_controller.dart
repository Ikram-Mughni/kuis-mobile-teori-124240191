import 'package:intl/intl.dart';
import '../helpers/api.dart';
import '../helpers/api_url.dart';
import '../models/time_zone_model.dart';

// Controller logika bisnis konversi zona waktu
class TimeController {
  final Api _api = Api();

  // Konversi waktu input ke zona WIB, Malaysia, dan Kanada
  List<TimeZoneModel> konversiWaktu(DateTime baseTime) {
    // Konversi ke UTC
    final DateTime utcTime = baseTime.toUtc();

    // Waktu Indonesia Barat (UTC+7)
    final DateTime wibDate = utcTime.add(const Duration(hours: 7));

    // Waktu Malaysia (UTC+8)
    final DateTime malaysiaDate = utcTime.add(const Duration(hours: 8));

    // Waktu Kanada / Toronto EDT (UTC-4)
    final DateTime kanadaDate = utcTime.subtract(const Duration(hours: 4));

    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');

    return [
      TimeZoneModel(
        label: "Indonesia (WIB)",
        timeZoneName: "Asia/Jakarta (UTC+7)",
        dateTime: wibDate,
        formattedTime: "${timeFormat.format(wibDate)} | ${dateFormat.format(wibDate)}",
      ),
      TimeZoneModel(
        label: "Malaysia (MYT)",
        timeZoneName: "Asia/Kuala_Lumpur (UTC+8)",
        dateTime: malaysiaDate,
        formattedTime: "${timeFormat.format(malaysiaDate)} | ${dateFormat.format(malaysiaDate)}",
      ),
      TimeZoneModel(
        label: "Kanada (EDT)",
        timeZoneName: "America/Toronto (UTC-4)",
        dateTime: kanadaDate,
        formattedTime: "${timeFormat.format(kanadaDate)} | ${dateFormat.format(kanadaDate)}",
      ),
    ];
  }

  // Mengambil waktu dari API publik
  Future<String?> fetchWibApiTime() async {
    try {
      final response = await _api.get(ApiUrl.worldTimeWib);
      if (response != null && response['datetime'] != null) {
        return response['datetime'].toString();
      }
    } catch (_) {
      // Fallback jika API gagal
    }
    return null;
  }
}
