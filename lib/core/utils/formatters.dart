import 'package:intl/intl.dart';

/// Shared formatting helpers for currency and dates.
class Formatters {
  static final _currency = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
    decimalDigits: 2,
  );

  static String currency(double amount) => _currency.format(amount);

  static String date(DateTime date) =>
      DateFormat('MMM dd, yyyy').format(date);

  static String dateTime(DateTime date) =>
      DateFormat('MMM dd, yyyy  hh:mm a').format(date);

  static String invoicePeriod(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);
}

