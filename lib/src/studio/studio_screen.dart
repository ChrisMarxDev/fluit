import 'package:fluit/src/studio/features/controls/controls_widget.dart';
import 'package:fluit/src/studio/features/details/details_widget.dart';
import 'package:fluit/src/studio/features/scene/scene_widget.dart';
import 'package:fluit/src/studio/features/timeline/timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

import 'package:fluit/src/studio/features/code/code_view.dart';

final counterBeacon = Beacon.writable<int>(0);

class StudioScreen extends StatelessWidget {
  const StudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () => counterBeacon.value++,
            child: Text(counterBeacon.watch(context).toString()),
          ),
          const AnimationControlPanelWrapper(),
          Container(
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: CodeView(),
                ),
                Container(
                  height: 400,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: const SceneWidget(),
                ),
                Expanded(
                  child: Container(
                    height: 400,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: const DetailsWidget(),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: Timeline()),
        ],
      ),
    );
  }
}
