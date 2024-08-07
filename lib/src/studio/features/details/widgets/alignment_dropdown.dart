import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/design_system/widgets/dropdown.dart';
import 'package:flutter/material.dart';

class AlignmentDropdown extends StatelessWidget {
  const AlignmentDropdown({
    required this.onChanged,
    required this.selectedElement,
    super.key,
  });

  final void Function(Alignment value) onChanged;
  final Alignment? selectedElement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text('Alignment', style: context.t2),
        BrutDropDown(
          items: const [
            Alignment.topLeft,
            Alignment.topCenter,
            Alignment.topRight,
            Alignment.centerLeft,
            Alignment.center,
            Alignment.centerRight,
            Alignment.bottomLeft,
            Alignment.bottomCenter,
            Alignment.bottomRight,
          ],
          itemBuilder: (context, value) {
            return Text(value.toString());
          },
          onChanged: onChanged,
          selectedElement: selectedElement,
        ),
      ],
    );
  }
}

class AxisDropdown extends StatelessWidget {
  const AxisDropdown({
    required this.onChanged,
    required this.selectedElement,
    super.key,
  });

  final void Function(Axis value) onChanged;
  final Axis? selectedElement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Axis', style: context.t2),
        BrutDropDown(
          items: const [
            Axis.horizontal,
            Axis.vertical,
          ],
          itemBuilder: (context, value) {
            return Text(value.toString());
          },
          onChanged: onChanged,
          selectedElement: selectedElement,
        ),
      ],
    );
  }
}
