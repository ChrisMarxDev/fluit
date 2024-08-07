import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/design_system/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import '../../curves.dart';

class CurveDropdown extends StatelessWidget {
  const CurveDropdown({
    required this.onChanged,
    required this.selectedElement,
    super.key,
  });

  final void Function(Curve value) onChanged;
  final Curve? selectedElement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text('Curve', style: context.t2),
        BrutDropDown(
          items: curves.keys.toList(),
          itemBuilder: (context, value) {
            if (curves[value] == null) return Text(value.toString());
            return Text(curves[value]!);
          },
          onChanged: onChanged,
          selectedElement: selectedElement,
        ),
      ],
    );
  }
}
