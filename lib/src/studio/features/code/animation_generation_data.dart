import 'package:fluit/src/studio/animations.dart';
import 'package:fluit/src/studio/features/curves.dart';
import 'package:fluit/src/studio/studio_state.dart';

class AnimationGenerationFrameData {
  AnimationGenerationFrameData({
    required this.name,
    required this.tweenType,
    required this.animationType,
    required this.curve,
    required this.beginPos,
    required this.endPos,
    required this.beginValue,
    required this.endValue,
    required this.additionalParameters,
    required this.animationParameter,
  });

  factory AnimationGenerationFrameData.fromFrames(
    AnimationFrame frame,
    AnimationFrame nextFrame, [
    int count = 0,
  ]) {
    final variableName = '${frame.name}$count';
    return AnimationGenerationFrameData(
      additionalParameters: nextFrame.additionalParameters,
      name: variableName,
      tweenType: frame.tweenType,
      animationType: frame.animationType,
      curve: curves[nextFrame.curve] ?? 'Curves.easeInOut',
      beginPos: frame.position,
      endPos: nextFrame.position,
      beginValue: frame.valueString,
      endValue: nextFrame.valueString,
      animationParameter: frame.animationParameter,
    );
  }

  final String name;
  final String tweenType;
  final String animationType;
  final String animationParameter;
  final String curve;
  final double beginPos;
  final double endPos;
  final String beginValue;
  final String endValue;
  final List<String> additionalParameters;

  Map<String, dynamic> toJson() => {
        'name': name,
        'tweenType': tweenType,
        'animationType': animationType,
        'curve': curve,
        'beginPos': beginPos,
        'endPos': endPos,
        'beginValue': beginValue,
        'endValue': endValue,
        'animationParameter': animationParameter,
        'additionalParameters': additionalParameters,
      };
}

List<AnimationGenerationFrameData> animationGenerationFrameDatafromState(
    FluitAnimationState state) {
  final variableCounts = <String, int>{};
  final list = <AnimationGenerationFrameData>[];
  if (state.elements.isEmpty) return list;

  for (final animation in state.elements.first.animations) {
    if (animation.animationFrames.isEmpty) continue;
    for (var i = 0; i < animation.animationFrames.length - 1; i++) {
      final frame = animation.animationFrames[i];
      final nextFrame = animation.animationFrames[i + 1];
      final name = frame.name;
      variableCounts.putIfAbsent(name, () => 0);
      variableCounts[name] = variableCounts[name]! + 1;
      final count = variableCounts[name]!;
      list.add(
        AnimationGenerationFrameData.fromFrames(frame, nextFrame, count),
      );
    }
  }
  return list;
}

// class AnimationGenerationTimeLineData {
//   final List<AnimationGenerationFrameData> frames;
//   final String name;
//   final String type;
//
//   AnimationGenerationTimeLineData({
//     required this.frames,
//     required this.name,
//     required this.type,
//   });
// }
