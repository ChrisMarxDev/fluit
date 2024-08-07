import 'package:fluit/src/util/platform_util.dart';
import 'package:flutter/services.dart';


bool isShiftPressed() {
  if (isMobile) {
    return false;
  }
  final shiftKeys = [
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  ];
  final isShiftPressed = HardwareKeyboard.instance.logicalKeysPressed
      .where(shiftKeys.contains)
      .isNotEmpty;

  return isShiftPressed;
}

bool isMetaPressed() {
  final metaKeys = [
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
  ];
  final isMetaPressed = HardwareKeyboard.instance.logicalKeysPressed
      .where(metaKeys.contains)
      .isNotEmpty;

  return isMetaPressed;
}
