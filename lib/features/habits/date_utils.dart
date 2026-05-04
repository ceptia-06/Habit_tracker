import 'package:intl/intl.dart';

class DateUtils {
  static String todayUTC() {
    final now = DateTime.now().toUtc();
    return _formatDate(now);
  }

  static String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  static String formatReadable(String date) {
    final parsed = DateTime.parse(date).toUtc();
    return DateFormat.yMMMMd('fr_FR').format(parsed);
  }
}
