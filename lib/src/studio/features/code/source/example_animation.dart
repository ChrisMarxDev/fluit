import 'package:flutter/material.dart';

final duration = const Duration(milliseconds: 3000);

final beginPosA = 0.2;
final endPosA = 0.8;
final beginValueA = 0.0;
final endValueA = 1.0;
final curveA = Curves.easeInOut;

final beginPosB = 0.3;
final endPosB = 0.7;
final beginValueB = 1.0;
final endValueB = 0.0;
final curveB = Curves.easeInOut;

typedef AnimationBuilder = Widget Function(
  BuildContext context,
  Widget? child,
  double progress,
);

class TestAnimation extends StatefulWidget {
  const TestAnimation({
    super.key,
    this.child,
    this.builder,
    this.loop = false,
    this.autoPlay = false,
  });

  final Widget? child;
  final AnimationBuilder? builder;
  final bool loop;
  final bool autoPlay;

  @override
  State<TestAnimation> createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  // 1. Declare animation variables
  late final Animation<double> rotation;
  late final Animation<double> scale;
  late final Animation<double> scale2;
  late final Animation<double> scaleComposite;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    // 2. Create animations
    rotation = Tween(
      begin: beginValueA,
      end: endValueA,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(beginPosA, endPosB, curve: curveA),
      ),
    );
    scale = Tween(
      begin: beginValueB,
      end: endValueB,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endPosA, endPosB, curve: curveB),
      ),
    );
    scale2 = Tween(
      begin: beginValueB,
      end: endValueB,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endPosA, endPosB, curve: curveB),
      ),
    );

    scaleComposite = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: beginValueA, end: endValueA)
              .chain(CurveTween(curve: curveA)),
          weight: 40.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(10.0),
          weight: 20.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 10.0, end: 5.0)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
      ],
    ).animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3. Use animations and nest them
    return RotationTransition(
      turns: rotation,
      child: ScaleTransition(
        scale: scale,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return widget.builder?.call(context, child, controller.value) ??
                child ??
                const SizedBox();
          },
          child: widget.child,
        ),
      ),
    );
  }
}
