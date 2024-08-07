import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/design_system/widgets/dropdown.dart';
import 'package:fluit/src/studio/features/examples/animation_subjects.dart';
import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

class SubjectDropdown extends StatelessWidget {
  const SubjectDropdown({
    required this.onChanged,
    required this.selectedElement,
    super.key,
  });

  final void Function(String value) onChanged;
  final String? selectedElement;

  @override
  Widget build(BuildContext context) {
    final examples = subjectBuildersBeacon.watch(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subject', style: context.t2),
        BrutDropDown(
          items: examples.keys.toList(),
          itemBuilder: (context, value) {
            if (examples[value] == null) return Text(value);
            return Row(
              children: [
                Text(examples[value]!.toString()),
                const SizedBox(width: 8),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: examples[value]!(context),
                ),
              ],
            );
          },
          onChanged: onChanged,
          selectedElement: selectedElement,
        ),
      ],
    );
  }
}
