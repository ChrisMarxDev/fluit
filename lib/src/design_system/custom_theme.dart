import 'package:flutter/material.dart';

const Color kWhite = Color(0xFFFFFFFF);
const Color kBlack = Color(0xFF000000);
const Color kGrey1 = Color(0xFF1f1f1f);
const Color kGrey1_5 = Color(0xFF2f2f2f);
const Color kGrey2 = Color(0xFF4c4c4c);
const Color kGrey3 = Color(0xFF888888);
const Color kGrey4 = Color(0xFFbbbbbb);
const Color kGrey5 = Color(0xFFe1e1e1);

const kGreen = Color(0xFF00C853);
const kRed = Color(0xFFD50000);
const kYellow = Color(0xFFFFD600);
const kBlue = Color(0xFF2962FF);
const startColor = Color(0xFF00BFA5);
const endColor = Color(0xFFF50057);
const intermediateColor = Color(0xffFFBE0B);

final kColors = [
  const Color(0xffFFBE0B), // Primary Yellow
  const Color(0xffFF9800), // Dark Orange
  const Color(0xffFF5722), // Deep Orange
  const Color(0xffFF6347), // Tomato
  const Color(0xffFF69B4), // Hot Pink
  const Color(0xffFF1493), // Deep Pink
  const Color(0xffDDA0DD), // Plum
  const Color(0xffBA55D3), // Medium Orchid
  const Color(0xff87CEFA), // Light Sky Blue
  const Color(0xff48D1CC), // Medium Turquoise
  const Color(0xff00FA9A), // Light Green
  const Color(0xff7FFF00), // Chartreuse
];
const kSecondaryColor = Color(0xffFB773C);
const kPrimaryColor = Color(0xff180161);
const kTertiaryColor = Color(0xffEB3678);
const kAlternateSecondaryColor = Color(0xff4F1787);

ThemeData getThemeData({
  bool isDarkMode = false,
  Color? primaryColor,
  Color? secondaryColor,
  // Color? surfaceColor,
}) {
  const primary = kPrimaryColor;
  const secondary = kSecondaryColor;
  // final offWhite = primary.blend(kWhite, 0.9);
  final bg = isDarkMode ? kGrey1 : kWhite;

  const onPrimary = kWhite;

  // const fontFamily = 'Roboto';
  return ThemeData(
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: kGrey3),
    ),
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      onSecondary: kBlack,
      surface: isDarkMode ? kGrey1 : kWhite,
      // surface: offWhite,
    ),
    cardTheme: CardTheme(
      color: bg,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: kCardShape,
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: primary.blend(kWhite, 0.6),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primary);
        }
        return const IconThemeData(color: kGrey3);
      }),
    ),
    navigationRailTheme: NavigationRailThemeData(
      indicatorColor: primary.blend(kWhite, 0.6),
      selectedIconTheme: const IconThemeData(color: primary),
      elevation: 0,
      groupAlignment: 0,
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(kRoundShape),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return kWhite;
          }
          return onPrimary;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return kGrey3;
          }
          return primary;
        }),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: kCardShape,
      backgroundColor: bg,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(primary),
        shape: WidgetStateProperty.all<OutlinedBorder>(kRoundShape),
        side: WidgetStateProperty.all<BorderSide>(
          const BorderSide(
            color: primary,
          ),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primary,
      selectionColor: primary.blend(kWhite, 0.6),
      selectionHandleColor: primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: kGrey4,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: kGrey4,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: primary,
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      mouseCursor: WidgetStateMouseCursor.clickable,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return kGrey4;
        }
        return primary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary.blend(kWhite, 0.8);
        }
        return kWhite;
      }),
      trackOutlineWidth: WidgetStateProperty.all(2),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        return primary;
      }),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      space: 1,
    ),
    dataTableTheme: DataTableThemeData(
      dataTextStyle: const TextStyle(),
      headingTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: kGrey4,
        ),
      ),
    ),
    textTheme: const TextTheme(),
    // textTheme: GoogleFonts.bricolageGrotesqueTextTheme(
    //   const TextTheme(
    //     titleSmall: TextStyle(
    //       fontSize: 16,
    //       fontWeight: FontWeight.bold,
    //     ),
    //     labelSmall: TextStyle(
    //       fontSize: 10,
    //       color: kGrey4,
    //     ),
    //   ),
    // ),
    // primaryTextTheme: GoogleFonts.bricolageGrotesqueTextTheme(),
  );
}

BoxShadow brutShadow(double size, [Color color = kBlack]) {
  return BoxShadow(
    color: color,
    offset: Offset(size, size),
  );
}

const kCardBorder = Border.fromBorderSide(BorderSide());

const kBaseBrutShadow = BoxShadow(
  offset: Offset(5, 5),
);

const kSmallBrutShadow = BoxShadow(
  offset: Offset(2, 2),
);

const kDurationQuick = Duration(milliseconds: 240);
const kDurationVeryQuick = Duration(milliseconds: 160);
const kDurationBase = Duration(milliseconds: 350);
const kDurationDebugSloooow = Duration(seconds: 3);

extension ThemeExtension on BuildContext {
  // used for site wide headlines
  TextStyle get h1 => textTheme.headlineMedium!;

  TextStyle get h2 => textTheme.headlineSmall!;

  // used for specifice block titles
  TextStyle get t1 => textTheme.titleMedium!;

  TextStyle get t2 => textTheme.titleSmall!;

  TextStyle get canvas => t2.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  // paragraph
  TextStyle get p1 => textTheme.bodyMedium!;

  //  paragraph small
  TextStyle get p2 => textTheme.bodySmall!;

  TextStyle get caption => textTheme.labelMedium!;

  TextStyle get captionWeak => textTheme.labelSmall!;

  bool isDarkMode() {
    return Theme.of(this).brightness == Brightness.dark;
  }

  // helper method for weaker text
  Color get weakTextColor {
    return isDarkMode() ? kGrey2 : kGrey4;
  }

  Color get disabledColor {
    return isDarkMode() ? kGrey2 : kGrey4;
  }

  Color get weakestTextColor {
    return isDarkMode() ? kGrey1_5 : kGrey5;
  }

  Color get strongTextColor {
    return isDarkMode() ? kWhite : kGrey2;
  }

  Color get primary {
    return Theme.of(this).colorScheme.primary;
  }

  Color get transparent {
    return Theme.of(this).colorScheme.primary.withOpacity(0);
  }

  ThemeData get theme {
    return Theme.of(this);
  }

  Color get secondary {
    return Theme.of(this).colorScheme.secondary;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  ColorScheme get colorScheme {
    return Theme.of(this).colorScheme;
  }

  Color get onPrimary {
    return colorScheme.onPrimary;
  }

  Color get onSecondary {
    return colorScheme.onSecondary;
  }

  Color get textColor {
    return textTheme.bodyLarge!.color!;
  }

  Color get background {
    return colorScheme.surface;
  }

  Color get onBackground {
    return colorScheme.onSurface;
  }

  Color get notificationCardBackground {
    return isDarkMode() ? HexColor('#1F1F1F') : kGrey3;
  }

  Color get surface {
    return colorScheme.surface;
  }

  Color get cardColor => theme.cardTheme.color!;

  double get screenHeight =>
      MediaQuery.sizeOf(this).height + MediaQuery.viewInsetsOf(this).vertical;

  Duration get shortDuration => const Duration(milliseconds: 240);

  Duration get baseDuration => const Duration(milliseconds: 350);

  Duration get longDuration => const Duration(milliseconds: 600);

  Curve get baseCurve => Curves.easeIn;

  double get baseSpacing => kBaseSpacing;

  Color get success => kGreen;

  Color get error => kRed;
}

const kBaseSpacing = 16.0;

const kSideSpacing = 16.0;
const paddingSides = EdgeInsets.symmetric(horizontal: 32);
const bottomButtonSpace = 42.0;

const kRadiusCircular = Radius.circular(4);
const kBorderRadius = BorderRadius.all(kRadiusCircular);
const kSmallRadiusCircular = Radius.circular(4);
const kBorderradiusSmall = BorderRadius.all(kSmallRadiusCircular);
const kRoundShape = RoundedRectangleBorder();
const kCardShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)));

const kBorderSide = BorderSide();
const kBorder = Border.fromBorderSide(kBorderSide);

class HexColor extends Color {
  HexColor(String? hexColor) : super(_getColorFromHex(hexColor ?? '#000000'));

  static int _getColorFromHex(String input) {
    var hexColor = input.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

extension ColorExtension on Color {
  Color get invertColor {
    return (computeLuminance() > 0.5) ? Colors.black : Colors.white;
  }

  Color blend(Color other, [double amount = 0.5]) {
    return Color.lerp(this, other, amount)!;
  }
}
