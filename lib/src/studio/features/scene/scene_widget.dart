import 'package:fluit/src/studio/features/controls/play_controls_wrapper.dart';
import 'package:fluit/src/studio/studio_logic.dart';
import 'package:fluit/src/studio/studio_state.dart';
import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

import 'detail_animation.dart';

class SceneWidget extends StatelessWidget {
  const SceneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SceneAnimator();
  }
}

class SceneAnimator extends StatefulWidget {
  const SceneAnimator({super.key});

  @override
  State<SceneAnimator> createState() => _SceneAnimatorState();
}

class _SceneAnimatorState extends State<SceneAnimator>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final state = studioStateController.select(context, (c) => c.state);

    return Center(
      child: RecursiveAnimatedTimeline(
        elements: state.elements.first.animations,
        controller: AnimationControls.of(context).controller,
        child: Container(
          width: 100,
          height: 100,
          color: Colors.blue,
          child: const FlutterLogo(),
        ),
      ),
    );
  }
}

class RecursiveAnimatedTimeline extends StatelessWidget {
  const RecursiveAnimatedTimeline({
    required this.elements,
    required this.child,
    required this.controller,
    super.key,
  });

  final List<AnimationTimeLine> elements;
  final Widget child;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    if (elements.isEmpty) {
      return child;
    } else {
      final element = elements.first;
      return AnimatedTimeline(
        timeline: element,
        controller: controller,
        child: RecursiveAnimatedTimeline(
          elements: elements.skip(1).toList(),
          controller: controller,
          child: child,
        ),
      );
    }
  }
}

class AnimatedTimeline extends StatelessWidget {
  const AnimatedTimeline({
    required this.child,
    required this.timeline,
    required this.controller,
    super.key,
  });

  final Widget child;
  final AnimationTimeLine timeline;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return RecursiveAnimationWrapper(
      timeline: timeline,
      controller: controller,
      child: child,
    );
  }
}

class RecursiveAnimationWrapper extends StatelessWidget {
  const RecursiveAnimationWrapper({
    required this.child,
    required this.controller,
    required this.timeline,
    super.key,
  });

  final Widget child;
  final AnimationController controller;
  final AnimationTimeLine timeline;

  @override
  Widget build(BuildContext context) {
    final hasEnoughFrames = timeline.animationFrames.length > 1;
    if (!hasEnoughFrames) {
      return child;
    }
    final frame = timeline.animationFrames.first;
    final nextFrame = timeline.animationFrames[1];

    return AnimationWidgetSwitch(
      frame: frame,
      nextFrame: nextFrame,
      controller: controller,
      curve: nextFrame.curve,
      child: RecursiveAnimationWrapper(
        timeline: timeline.copyWith(
          animationFrames: timeline.animationFrames.skip(1).toList(),
        ),
        controller: controller,
        child: child,
      ),
    );
  }
}
