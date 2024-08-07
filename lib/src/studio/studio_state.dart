import 'package:collection/collection.dart';
import 'package:fluit/src/studio/animations.dart';
import 'package:fluit/src/util/extensions/list_extension.dart';
import 'package:flutter/animation.dart';

abstract class ChildCollection<T> {
  T get(String id);

  ChildCollection<T> remove(String id);

  ChildCollection<T> upsert(T newChild, String id);
}

class AnimationTimeLine {
  AnimationTimeLine({
    required this.type,
    required this.animationFrames,
    // required this.curve,
    required this.id,
  });

  final List<AnimationFrame> animationFrames;

  // final Curve curve;
  final String id;
  final AnimationType type;

  AnimationTimeLine copyWithFrame({required AnimationFrame keyFrame}) {
    final newFrames = List<AnimationFrame>.from(animationFrames)
        .replacedOrAdded(keyFrame, (frame) => frame.id == keyFrame.id);

    return copyWith(
      animationFrames: newFrames,
    );
  }

  AnimationTimeLine copyWith({
    List<AnimationFrame>? animationFrames,
    Curve? curve,
    String? id,
    AnimationType? type,
  }) {
    animationFrames?.sort((a, b) => a.position.compareTo(b.position));
    return AnimationTimeLine(
      animationFrames: animationFrames ?? this.animationFrames,
      // curve: curve ?? this.curve,
      type: type ?? this.type,
      id: id ?? this.id,
    );
  }

  AnimationTimeLine removeKeyFrame(String keyFrameId) {
    final newFrames = List<AnimationFrame>.from(animationFrames)
        .removedWhere((frame) => frame.id == keyFrameId);

    return copyWith(
      animationFrames: newFrames,
    );
  }

  AnimationFrame getFrameById(String frameId) {
    return animationFrames.firstWhere((element) => element.id == frameId);
  }
}

class AnimationElement {
  AnimationElement({
    required this.animations,
    required this.id,
    this.placeholderChildInfo,
  });

  final List<AnimationTimeLine> animations;
  final String? placeholderChildInfo;
  final String id;

  AnimationElement copyWith({
    List<AnimationTimeLine>? animations,
    String? placeholderChildInfo,
    String? id,
  }) {
    return AnimationElement(
      animations: animations ?? this.animations,
      placeholderChildInfo: placeholderChildInfo ?? this.placeholderChildInfo,
      id: id ?? this.id,
    );
  }

  AnimationElement copyWithTimeline({required AnimationTimeLine timeline}) {
    final timeLines = List<AnimationTimeLine>.from(animations)
        .replacedOrAdded(timeline, (element) => element.id == timeline.id);
    return copyWith(
      animations: timeLines,
    );
  }

  AnimationTimeLine getAnimationTimelineById(
    String timeLineId,
  ) {
    return animations.firstWhere((element) => element.id == timeLineId);
  }

  AnimationFrame getFrameById(String timelineId, String frameId) {
    return getAnimationTimelineById(timelineId).getFrameById(frameId);
  }

  AnimationElement copyWithKeyFrame({
    required String timeLineId,
    required AnimationFrame keyFrame,
  }) {
    final timeline = getAnimationTimelineById(timeLineId);
    final newTimeline = timeline.copyWithFrame(keyFrame: keyFrame);

    return copyWith(
      animations: animations.replacedOrAdded(
        newTimeline,
        (element) => element.id == timeLineId,
      ),
    );
  }

  AnimationElement removeTimeline(String timeLineId) {
    return copyWith(
      animations:
          animations.removedWhere((element) => element.id == timeLineId),
    );
  }
}

class FluitAnimationState {
  FluitAnimationState({required this.elements});

  final List<AnimationElement> elements;

  FluitAnimationState copyWith({List<AnimationElement>? elements}) {
    return FluitAnimationState(elements: elements ?? this.elements);
  }

  FluitAnimationState copyWithElement({required AnimationElement element}) {
    final elements = List<AnimationElement>.from(this.elements)
        .replacedOrAdded(element, (e) => e.id == element.id);

    return copyWith(
      elements: elements,
    );
  }

  FluitAnimationState copyWithTimeline({
    required String elementId,
    required AnimationTimeLine timeline,
  }) {
    final element = getAnimationElementById(elementId);
    final newElement = element.copyWithTimeline(timeline: timeline);
    return copyWith(
      elements: elements.replacedOrAdded(newElement, (e) => e.id == elementId),
    );
  }

  FluitAnimationState copyWithKeyFrame({
    required String elementId,
    required String timeLineId,
    required AnimationFrame keyFrame,
  }) {
    final timeline = getAnimationTimelineById(elementId, timeLineId);
    final newTimeline = timeline?.copyWithFrame(keyFrame: keyFrame);
    if (newTimeline == null) return this;
    return copyWithTimeline(
      elementId: elementId,
      timeline: newTimeline,
    );
  }

  AnimationElement getAnimationElementById(String elementId) {
    return elements.firstWhere((element) => element.id == elementId);
  }

  AnimationTimeLine? getAnimationTimelineById(
    String elementId,
    String timeLineId,
  ) {
    final element = getAnimationElementById(elementId);
    return element.animations
        .firstWhereOrNull((element) => element.id == timeLineId);
  }

  AnimationFrame? getKeyFrameById(
    String elementId,
    String timeLineId,
    String keyFrameId,
  ) {
    final timeLine = getAnimationTimelineById(elementId, timeLineId);
    return timeLine?.animationFrames
        .firstWhereOrNull((element) => element.id == keyFrameId);
  }

  FluitAnimationState removeKeyFrame(
    String elementId,
    String timeLineId,
    String keyFrameId,
  ) {
    final timeline = getAnimationTimelineById(elementId, timeLineId)
        ?.removeKeyFrame(keyFrameId);

    if (timeline == null) return this;
    return copyWithTimeline(
      elementId: elementId,
      timeline: timeline,
    );
  }

  FluitAnimationState removeTimeline(String elementId, String timeLineId) {
    final newElement =
        getAnimationElementById(elementId).removeTimeline(timeLineId);

    return copyWithElement(element: newElement);
  }

  FluitAnimationState removeElement(String elementId) {
    return copyWith(
      elements: elements.removedWhere((element) => element.id == elementId),
    );
  }
}
