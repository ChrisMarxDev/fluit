import 'package:fluit/src/studio/features/controls/play_controls_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:state_beacon/state_beacon.dart';

import '../../../design_system/widgets/count_selector.dart';

final timelineDurationInSeconds = Beacon.writable(5000);

final backAndForth = Beacon.writable(false);
final loop = Beacon.writable(true);

class AnimationControlPanelWrapper extends StatelessWidget {
  const AnimationControlPanelWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const TimeControls(),
        const Spacer(),
        AnimationControlPanel(
          controller: AnimationControls.of(context).controller,
        ),
        const Spacer(),
      ],
    );
  }
}

class AnimationControlPanel extends StatefulWidget {
  const AnimationControlPanel({
    required this.controller,
    super.key,
  });

  final AnimationController controller;

  @override
  State<AnimationControlPanel> createState() => _AnimationControlPanelState();
}

class _AnimationControlPanelState extends State<AnimationControlPanel> {
  bool get _isPlaying => widget.controller.isAnimating;

  void onControllerUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onControllerUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(onControllerUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (_isPlaying) {
                  widget.controller.stop();
                } else {
                  widget.controller.forward(from: 0);
                  // widget.controller.animateWith(SpringSimulation(
                  //     const SpringDescription(
                  //       mass: 1.0,
                  //       stiffness: 100.0,
                  //       damping: 2.0,
                  //     ),
                  //     0.0,
                  //     1.0,
                  //     1));
                  // velocity: 0.0,
                }
              },
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
            Column(
              children: [
                CupertinoSwitch(
                  value: backAndForth.watch(context),
                  onChanged: backAndForth.set,
                ),
                const Text('Back and forth'),
              ],
            ),
            Column(
              children: [
                CupertinoSwitch(
                  value: loop.watch(context),
                  onChanged: loop.set,
                ),
                const Text('Loop'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class TimeControls extends StatelessWidget {
  const TimeControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Duration in ms'),
        CountSelector(
          value: timelineDurationInSeconds.watch(context).toDouble(),
          onChanged: (value) => timelineDurationInSeconds.set(value.toInt()),
          displayFunction: (value) => '${value.toInt()}',
          max: 128 * 1000,
          step: 500,
        ),
      ],
    );
  }
}
