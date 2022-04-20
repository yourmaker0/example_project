import 'package:intl/intl.dart';

class Formatters {
  static String mainTime(DateTime dateTime) {
    return DateFormat("hh:mm a").format(dateTime.toLocal());
  }

  // static MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
  //   mask: '+1 ### ### ####',
  //   filter: {
  //     "#": RegExp(r'[0-9]'),
  //   },
  // );

  static String nullableComa(List<String?> nullableStrings) {
    nullableStrings.removeWhere((element) => element == null);
    return nullableStrings.join(', ');
  }
}
