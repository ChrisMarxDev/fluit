import 'package:flutter/material.dart';

extension AlignmentCodeExtension on Alignment {
  String toCode([String? varName]) {
    final finalVarName = varName ?? 'alignment';
    return '$finalVarName : Alignment($x, $y)';
  }
}

extension AxisCodeExtension on Axis {
  String toCode([String? varName]) {
    final finalVarName = varName ?? 'axis';
    return '$finalVarName : Axis.$name';
  }
}

extension DoubleCodeExtension on num {
  String toCode([String? varName]) {
    final finalVarName = varName ?? 'value';
    return '$finalVarName : $this';
  }
}
