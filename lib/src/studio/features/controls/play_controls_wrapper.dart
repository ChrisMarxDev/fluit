import 'package:fluit/src/studio/features/controls/controls_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:state_beacon/state_beacon.dart';

import '../../../design_system/widgets/count_selector.dart';

class AnimationControlsWrapper extends StatefulWidget {
  const AnimationControlsWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AnimationControlsWrapper> createState() =>
      _AnimationControlsWrapperState();
}

class _AnimationControlsWrapperState extends State<AnimationControlsWrapper>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    controller
      ..addListener(() {
        if (controller.isCompleted) {
          print('completed');

          if (!loop.value) return;
          if (backAndForth.value) {
            controller.reverse();
          } else {
            controller.reset();
            controller.forward(from: 0);
          }
        } else if (controller.isDismissed) {
          print('dismissed');
          controller.forward();
        }
      })
      ..forward();

    Beacon.effect(() {
      final newDuration = timelineDurationInSeconds.value;
      print('new duration: $newDuration');
      controller.duration = Duration(milliseconds: newDuration);
      controller.forward(from: 0);

      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimationControls(
      controller: controller,
      child: widget.child,
    );
  }
}

class AnimationControls extends InheritedWidget {
  const AnimationControls({
    required super.child,
    required this.controller,
    super.key,
  });

  final AnimationController controller;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return child != (oldWidget as AnimationControls).child;
  }

  static AnimationControls of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AnimationControls>()!;
  }
}
