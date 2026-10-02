import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Formatter khusus pembatas 12 digit angka bulat sebelum desimal
class Integer12DigitLimitingFormatter extends TextInputFormatter {
  final int maxIntegerDigits;

  Integer12DigitLimitingFormatter({this.maxIntegerDigits = 12});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    // Memisahkan angka bulat sebelum tanda desimal titik atau koma
    final parts = text.split(RegExp(r'[.,]'));
    final integerDigits = parts[0].replaceAll(RegExp(r'\D'), '');

    if (integerDigits.length > maxIntegerDigits) {
      return oldValue;
    }
    return newValue;
  }
}

// Widget reusable input teks dan validasi form QA
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.indigo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.indigo.withValues(alpha: 0.03),
          counterText: maxLength != null ? "" : null,
        ),
      ),
    );
  }
}
