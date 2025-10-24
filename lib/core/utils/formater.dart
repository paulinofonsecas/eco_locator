import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatNumber(num number, {String locale = 'pt_BR'}) {
    final formatter = NumberFormat.decimalPattern(locale);
    return formatter.format(number);
  }

  static String formatCurrency(num number,
      {String symbol = 'AOA', String locale = 'pt_BR'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: symbol);
    return formatter.format(number);
  }

  static String formatDecimal(num number,
      {int decimalDigits = 0, String locale = 'pt_BR'}) {
    final formatter = NumberFormat.simpleCurrency();
    return formatter.format(number);
  }
}
