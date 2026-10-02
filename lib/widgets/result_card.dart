import 'package:flutter/material.dart';

// Widget reusable untuk kartu hasil perhitungan
class ResultCard extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final IconData icon;
  final Color accentColor;

  const ResultCard({
    super.key,
    required this.title,
    required this.items,
    this.icon = Icons.assessment_outlined,
    this.accentColor = Colors.indigo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: accentColor.withValues(alpha: 0.1),
                  child: Icon(icon, color: accentColor),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24.0, thickness: 1.0),
            ...items,
          ],
        ),
      ),
    );
  }
}
