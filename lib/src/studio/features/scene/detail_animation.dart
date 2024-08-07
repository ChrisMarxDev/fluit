import 'package:flutter/material.dart';

import '../../animations.dart';

class AnimationWidgetSwitch extends StatelessWidget {
  const AnimationWidgetSwitch({
    required this.frame,
    required this.nextFrame,
    required this.child,
    required this.controller,
    required this.curve,
    super.key,
  });

  final AnimationFrame frame;
  final AnimationFrame nextFrame;
  final Widget child;
  final AnimationController controller;
  final Curve curve;

  Animation<T> animate<T, FrameType extends AnimationFrame>(
    AnimationController controller,
    Curve curve,
    FrameType frame,
    FrameType nextFrame,
    T Function(FrameType) getValue,
  ) {
    print('create animation for $frame & $nextFrame');
    return Tween<T>(
      begin: getValue(frame),
      end: getValue(nextFrame),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(frame.position, nextFrame.position, curve: curve),
      ),
    );
  }

  Animation<T> animateTween<T, FrameType extends AnimationFrame>(
    Tween<T> tween,
    AnimationController controller,
    Curve curve,
  ) {
    return tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(frame.position, nextFrame.position, curve: curve),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFrame = frame;
    switch (currentFrame) {
      case (final FadeTransitionFrame frame):
        return FadeTransition(
          opacity: animate(
            controller,
            curve,
            frame,
            nextFrame as FadeTransitionFrame,
            (frame) => frame.value,
          ),
          child: child,
        );
      case (final ScaleTransitionFrame frame):
        final next = nextFrame as ScaleTransitionFrame;
        return ScaleTransition(
          alignment: next.alignment,
          scale: animate(
            controller,
            curve,
            frame,
            next,
            (frame) => frame.value,
          ),
          child: child,
        );
      case (final RotationTransitionFrame frame):
        final next = nextFrame as RotationTransitionFrame;

        return RotationTransition(
          alignment: next.alignment,
          turns: animate(
            controller,
            curve,
            frame,
            next,
            (frame) => frame.value,
          ),
          child: child,
        );
      case (final SlideTransitionFrame frame):
        return SlideTransition(
          position: animate(
            controller,
            curve,
            frame,
            nextFrame as SlideTransitionFrame,
            (frame) => frame.value,
          ),
          child: child,
        );
      case (final PositionTransitionFrame frame):
        return PositionedTransition(
          rect: animateTween(
              RelativeRectTween(
                begin: frame.relativeRect,
                end: (nextFrame as PositionTransitionFrame).relativeRect,
              ),
              controller,
              curve),
          // rect: animate<RelativeRect, PositionTransitionFrame>(
          //   controller,
          //   curve,
          //   frame,
          //   nextFrame as PositionTransitionFrame,
          //   (frame) => frame.relativeRect,
          // ),
          child: child,
        );

      case (final SizeTransitionFrame frame):
        return SizeTransition(
          axis: frame.axis,
          axisAlignment: frame.axisAlignment,
          sizeFactor: animate(
            controller,
            curve,
            frame,
            nextFrame as SizeTransitionFrame,
            (frame) => frame.sizeFactor,
          ),
          fixedCrossAxisSizeFactor: frame.axisAlignment,
          child: child,
        );

      case (final SizeTransitionFrame frame):

        // return MatrixTransition(
        //
        //   animation: 0.1,
        //   onTransform: (double animationValue) {  },
        //   child: child,
        // );
    }
    return child;
  }
}
