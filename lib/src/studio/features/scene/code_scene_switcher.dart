import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

final currentMode = Beacon.writable<SceneMode>(SceneMode.code);

enum SceneMode {
  code,
  preview;

  IconData get icon {
    switch (this) {
      case SceneMode.code:
        return Icons.code;
      case SceneMode.preview:
        return Icons.image;
    }
  }
}

class CodeSceneSwitcher extends StatelessWidget {
  const CodeSceneSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedButton<SceneMode>(
          segments: SceneMode.values
              .map(
                (e) => ButtonSegment(
                  value: e,
                  icon: Icon(e.icon),
                  label: Text(e.name),
                ),
              )
              .toList(),
          selected: {currentMode.watch(context)},
          onSelectionChanged: (value) {
            currentMode.set(value.first);
          },
        ),
      ],
    );
  }
}
