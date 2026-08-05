import 'dart:math';
import 'dart:ui';

import 'package:intl/intl.dart';

final dateFormatter = DateFormat('yyyy-MM-dd a');

Color getRandomPastelColor() {
  final random = Random();

  return Color.fromARGB(
    255,
    150 + random.nextInt(106),
    150 + random.nextInt(106),
    150 + random.nextInt(106),
  );
}

String formatAmount(num amount) {
  return NumberFormat('#,##0').format(amount);
}

String formatDateLabel(DateTime date) {
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final targetDate = DateTime(date.year, date.month, date.day);

  final difference = today.difference(targetDate).inDays;

  if (difference == 0) {
    return "Today";
  } else if (difference == 1) {
    return "Yesterday";
  } else {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
