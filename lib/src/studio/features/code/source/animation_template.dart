import 'package:flutter/material.dart';

final duration = 3000;
//
// final beginPosA = 0.2;
// final endPosA = 0.8;
// final beginValueA = 0.0;
// final endValueA = 1.0;
// final curveA = Curves.easeInOut;
//
// final beginPosB = 0.3;
// final endPosB = 0.7;
// final beginValueB = 1.0;
// final endValueB = 0.0;
// final curveB = Curves.easeInOut;

// {
// "users": [{
// "name": "Hans"
// }, {
// "name": "Fritz"
// }, {
// "name": "Geraldine"
// }]
// }
//
// {{#users}}
// {{name}}
// {{/users}}

class TestAnimation extends StatefulWidget {
  const TestAnimation({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<TestAnimation> createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  // // animations
  // late final Animation<double> rotation;
  // late final Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );

    // rotation = Tween(
    //   begin: beginValueA,
    //   end: endValueA,
    // ).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: Interval(beginPosA, endPosB, curve: curveA),
    //   ),
    // );
    // scale = Tween(
    //   begin: beginValueB,
    //   end: endValueB,
    // ).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: Interval(endPosA, endPosB, curve: curveB),
    //   ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return RotationTransition(
    //   turns: rotation,
    //   child: ScaleTransition(
    //     scale: scale,
    //     child: widget.child,
    //   ),
    // );

    return widget.child;
  }
}
