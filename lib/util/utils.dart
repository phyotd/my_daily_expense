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
