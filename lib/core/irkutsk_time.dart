import 'package:intl/intl.dart';

class IrkutskTime {
  const IrkutskTime._();

  static DateTime local(DateTime instant) =>
      instant.toUtc().add(const Duration(hours: 8));

  static String format(DateTime instant, {bool seconds = false}) =>
      DateFormat(seconds ? 'dd.MM.yyyy HH:mm:ss' : 'dd.MM.yyyy HH:mm')
          .format(local(instant));

  static String duration(int seconds) =>
      Duration(seconds: seconds).toString().split('.').first.padLeft(8, '0');
}
