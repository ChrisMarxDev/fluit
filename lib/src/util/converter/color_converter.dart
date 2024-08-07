import 'dart:ui';

Color colorFromHex(String hex) {
  var hexResult = hex.toUpperCase().replaceAll('#', '');
  if (hexResult.length == 6) {
    hexResult = 'FF$hexResult';
  }
  return Color(int.parse(hexResult, radix: 16));
}

String colorToHex(Color color) {
  return color.value.toRadixString(16).substring(2).toUpperCase();
}
