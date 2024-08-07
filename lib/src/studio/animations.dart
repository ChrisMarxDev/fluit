import 'package:fluit/src/studio/features/code/code_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

enum AnimationType {
  fade,
  scale,
  rotation,
  size,
  position;
  // slide;

  AnimationFrame createFrame(double position) {
    final id = const Uuid().v4();
    switch (this) {
      case AnimationType.fade:
        return FadeTransitionFrame(id: id, position: position);
      case AnimationType.scale:
        return ScaleTransitionFrame(id: id, position: position);
      case AnimationType.rotation:
        return RotationTransitionFrame(id: id, position: position);
      case AnimationType.position:
        return PositionTransitionFrame(id: id, position: position);
      case AnimationType.size:
        return SizeTransitionFrame(id: id, position: position);
      // case AnimationType.slide:
      //   return SlideTransitionFrame(id: id, position: position);
    }
  }
}

abstract class AnimationFrame {
  const AnimationFrame({
    required this.id,
    this.position = 0,
    this.curve = Curves.easeInOut,
  }) : assert(
          position >= 0 && position <= 1,
          'position must be between 0 and 1',
        );
  final String id;
  final double position;
  final Curve curve;

  AnimationFrame copyWith({
    double? position,
    Curve? curve,
  });

  // eg scale1
  String get name;

  // eg ScaleTransition
  String get animationType;

  // eg double
  String get tweenType;

  // eg 0.5
  String get valueString;

  // eg 'scale' or opacity
  String get animationParameter;

  // eg
  // alignment: Alignment.center
  // turns: 1.0
  List<String> get additionalParameters => [];

  @override
  String toString() {
    return '$runtimeType {id: $id, position: $position}';
  }
}

class FadeTransitionFrame extends AnimationFrame {
  FadeTransitionFrame({
    required super.id,
    super.position = 0,
    this.value = 0,
    super.curve,
  });

  double value;

  @override
  FadeTransitionFrame copyWith(
      {double? position, double? relativeRect, Curve? curve}) {
    return FadeTransitionFrame(
      id: id,
      position: position ?? this.position,
      value: relativeRect ?? this.value,
      curve: curve ?? this.curve,
    );
  }

  @override
  String name = 'fade';
  @override
  String animationType = 'FadeTransition';
  @override
  String tweenType = 'double';

  @override
  String get animationParameter => 'opacity';

  @override
  String get valueString => value.toString();
}

class ScaleTransitionFrame extends AnimationFrame {
  ScaleTransitionFrame({
    required super.id,
    super.position = 0,
    this.value = 1,
    this.alignment = Alignment.center,
    super.curve,
  });

  double value;
  Alignment alignment;

  @override
  ScaleTransitionFrame copyWith({
    double? position,
    double? relativeRect,
    Alignment? alignment,
    Curve? curve,
  }) {
    return ScaleTransitionFrame(
      id: id,
      position: position ?? this.position,
      value: relativeRect ?? this.value,
      alignment: alignment ?? this.alignment,
      curve: curve ?? this.curve,
    );
  }

  @override
  String name = 'scale';
  @override
  String animationType = 'ScaleTransition';
  @override
  String tweenType = 'double';

  @override
  String get valueString => value.toString();

  @override
  String get animationParameter => 'scale';

  @override
  List<String> get additionalParameters => [
        alignment.toCode(),
      ];
}

class RotationTransitionFrame extends AnimationFrame {
  RotationTransitionFrame({
    required super.id,
    super.position = 0,
    this.value = 0,
    this.alignment = Alignment.center,
    super.curve,
  });

  double value;
  Alignment alignment;

  @override
  RotationTransitionFrame copyWith({
    double? position,
    double? relativeRect,
    Alignment? alignment,
    Curve? curve,
  }) {
    return RotationTransitionFrame(
      id: id,
      position: position ?? this.position,
      value: relativeRect ?? this.value,
      alignment: alignment ?? this.alignment,
      curve: curve ?? this.curve,
    );
  }

  @override
  String name = 'rotation';
  @override
  String animationType = 'RotationTransition';
  @override
  String tweenType = 'double';

  @override
  String get animationParameter => 'turns';

  @override
  String get valueString => value.toString();

  @override
  List<String> get additionalParameters => [
        alignment.toCode(),
      ];
}

class PositionTransitionFrame extends AnimationFrame {
  PositionTransitionFrame({
    required super.id,
    super.position = 0,
    this.relativeRect = RelativeRect.fill,
    super.curve,
  });

  RelativeRect relativeRect;

  @override
  PositionTransitionFrame copyWith({
    double? position,
    RelativeRect? relativeRect,
    Curve? curve,
  }) {
    return PositionTransitionFrame(
      id: id,
      position: position ?? this.position,
      relativeRect: relativeRect ?? this.relativeRect,
      curve: curve ?? this.curve,
    );
  }

  @override
  String name = 'position';
  @override
  String animationType = 'PositionTransition';
  @override
  String tweenType = 'RelativeRect';

  @override
  String get valueString =>
      'const RelativeRect.fromLTRB(${relativeRect.left}, ${relativeRect.top}, ${relativeRect.right}, ${relativeRect.bottom})';

  @override
  String get animationParameter => 'rect';
}

class SlideTransitionFrame extends AnimationFrame {
  SlideTransitionFrame({
    required super.id,
    super.position = 0,
    this.value = Offset.zero,
    super.curve,
  });

  Offset value;

  @override
  SlideTransitionFrame copyWith(
      {double? position, Offset? relativeRect, Curve? curve}) {
    return SlideTransitionFrame(
      id: id,
      position: position ?? this.position,
      value: relativeRect ?? this.value,
      curve: curve ?? this.curve,
    );
  }

  @override
  String name = 'slide';
  @override
  String animationType = 'SlideTransition';
  @override
  String tweenType = 'Offset';

  @override
  String get valueString => 'Offset(${value.dx}, ${value.dy})';

  @override
  String get animationParameter => 'offset';
}

class SizeTransitionFrame extends AnimationFrame {
  SizeTransitionFrame({
    required super.id,
    super.position = 0,
    this.sizeFactor = 1,
    this.axisAlignment = 1.0,
    this.axis = Axis.vertical,
    super.curve,
  });

  final double sizeFactor;
  final double axisAlignment;
  final Axis axis;

  @override
  SizeTransitionFrame copyWith({
    double? position,
    double? sizeFactor,
    double? axisAlignment,
    Axis? axis,
    Curve? curve,
  }) {
    return SizeTransitionFrame(
      id: id,
      position: position ?? this.position,
      sizeFactor: sizeFactor ?? this.sizeFactor,
      axisAlignment: axisAlignment ?? this.axisAlignment,
      curve: curve ?? this.curve,
      axis: axis ?? this.axis,
    );
  }

  @override
  String name = 'size';
  @override
  String animationType = 'SizeTransition';
  @override
  String tweenType = 'double';

  @override
  String get valueString => sizeFactor.toString();

  @override
  String get animationParameter => 'mainAxisSizeFactor';

  @override
  List<String> get additionalParameters => [
        axis.toCode(),
        axisAlignment.toCode(),
      ];
}

// AlignTransition

// Matrix4Transition

// DecoratedBoxTransition