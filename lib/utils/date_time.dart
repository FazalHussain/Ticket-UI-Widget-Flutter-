import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  /// Convert DateTime to formatted string
  /// Example format: 'Tue, 28 Aug'
  String toFormattedString({String format = 'EEE, dd MMM'}) {
    return DateFormat(format).format(this);
  }

  /// Convert DateTime to a custom time string
  /// Example: 'HH:mm'
  String toTimeString({String format = 'HH:mm'}) {
    return DateFormat(format).format(this);
  }
}

/// String extension to parse back to DateTime
extension StringToDateTime on String {
  /// Parse a formatted string to DateTime
  /// Requires the same format used when formatting
  DateTime toDateTime({String format = 'EEE, dd MMM'}) {
    return DateFormat(format).parse(this);
  }

  /// Parse time only string (e.g., 'HH:mm') into today's DateTime
  DateTime toTimeDateTime({String format = 'HH:mm'}) {
    final now = DateTime.now();
    final time = DateFormat(format).parse(this);
    return DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
  }
}