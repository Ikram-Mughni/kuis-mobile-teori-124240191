// Model data zona waktu dan hasil konversi
class TimeZoneModel {
  final String label;
  final String timeZoneName;
  final DateTime dateTime;
  final String formattedTime;

  TimeZoneModel({
    required this.label,
    required this.timeZoneName,
    required this.dateTime,
    required this.formattedTime,
  });

  // Factory konversi dari data JSON
  factory TimeZoneModel.fromJson(Map<String, dynamic> json) {
    final String dtStr = json['datetime'] ?? DateTime.now().toIso8601String();
    final DateTime parsedDate = DateTime.tryParse(dtStr) ?? DateTime.now();
    return TimeZoneModel(
      label: json['label'] ?? '',
      timeZoneName: json['timezone'] ?? '',
      dateTime: parsedDate,
      formattedTime: json['formatted_time'] ?? '',
    );
  }
}
