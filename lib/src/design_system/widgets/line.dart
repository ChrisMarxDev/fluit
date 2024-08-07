import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? context.primary,
      width: double.infinity,
      height: 2,
    );
  }
}
