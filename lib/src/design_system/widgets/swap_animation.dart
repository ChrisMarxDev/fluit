import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:flutter/widgets.dart';


class SwapAnimationWrapper extends StatefulWidget {
  const SwapAnimationWrapper({
    required this.child,
    this.duration = kDurationBase,
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  State<SwapAnimationWrapper> createState() => _SwapAnimationWrapperState();
}

class _SwapAnimationWrapperState extends State<SwapAnimationWrapper> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      child: widget.child,
      transitionBuilder: (child, animation) {
        final slideUp = widget.child.key == child.key;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, slideUp ? -1 : 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}

class MoveScaleSwitcher extends StatefulWidget {
  const MoveScaleSwitcher({
    required this.child,
    this.duration = kDurationBase,
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  State<MoveScaleSwitcher> createState() => _MoveScaleSwitcherState();
}

class _MoveScaleSwitcherState extends State<MoveScaleSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      child: widget.child,
      transitionBuilder: (child, animation) {
        final slideUp = widget.child.key == child.key;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, slideUp ? -1 : 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
