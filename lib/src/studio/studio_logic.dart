import 'dart:async';

import 'package:fluit/src/studio/animations.dart';
import 'package:fluit/src/studio/studio_state.dart';
import 'package:fluit/src/util/extensions/list_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:state_beacon/state_beacon.dart';
import 'package:uuid/uuid.dart';

import 'package:fluit/src/studio/features/code/code_generator.dart';

String get randomId {
  return const Uuid().v4();
}

final exampleState = FluitAnimationState(
  elements: [
    AnimationElement(
      id: randomId,
      animations: [
        AnimationTimeLine(
          type: AnimationType.rotation,
          id: randomId,
          animationFrames: [
            RotationTransitionFrame(id: randomId),
            RotationTransitionFrame(id: randomId, position: 0.5),
            RotationTransitionFrame(id: randomId, position: 0.8, value: 0.5),
          ],
        ),
      ],
    ),
  ],
);

final studioStateController = Ref.scoped((ctx) => StudioController());

@immutable
class SelectionPath {
  const SelectionPath(this.elementId, this.timelineId, this.keyFrameId);

  final String elementId;
  final String? timelineId;
  final String? keyFrameId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectionPath &&
        other.elementId == elementId &&
        other.timelineId == timelineId &&
        other.keyFrameId == keyFrameId;
  }

  @override
  int get hashCode {
    return elementId.hashCode ^ timelineId.hashCode ^ keyFrameId.hashCode;
  }
}

class StudioController extends BeaconController {
  late final state = B.writable(exampleState);

  late final selectedKeyFrameId = Beacon.writable<SelectionPath?>(null);

  late final selectedKeyFrame = Beacon.derived(
    () {
      final path = selectedKeyFrameId.value;
      if (path == null) {
        return null;
      }
      return state.value.getKeyFrameById(
        path.elementId,
        path.timelineId!,
        path.keyFrameId!,
      );
    },
  );

  late final derivedCode = Beacon.future<String>(
    () async {
      final animationsState = state.value;

      final code = CodeGenerator().generateCode(animationsState, 3000);
      print('code: $code');
      return code;
    },
  );

  void selectKeyFrame(SelectionPath? path) {
    selectedKeyFrameId.set(path);
  }

  void setKeyFrameByPath(SelectionPath path, AnimationFrame keyFrame) {
    setKeyFrame(path.elementId, path.timelineId!, keyFrame);
  }

  void setKeyFrame(
    String elementId,
    String timelineId,
    AnimationFrame keyFrame,
  ) {
    final value = state.value;
    final newValue = value.copyWithKeyFrame(
      elementId: elementId,
      timeLineId: timelineId,
      keyFrame: keyFrame,
    );
    state.set(newValue);
  }

  void deleteKeyFrame(SelectionPath thisSelectionPath) {
    selectedKeyFrameId.set(null);
    final timeline = state.value.getAnimationTimelineById(
      thisSelectionPath.elementId,
      thisSelectionPath.timelineId!,
    );
    if (timeline == null) return;
    final frames = List<AnimationFrame>.from(timeline.animationFrames);
    final newFrames = frames
        .where((element) => element.id != thisSelectionPath.keyFrameId)
        .toList();
    final newTimeline = timeline.copyWith(animationFrames: newFrames);

    final newValue = state.value.copyWithTimeline(
      elementId: thisSelectionPath.elementId,
      timeline: newTimeline,
    );
    state.set(newValue);
  }

  void addTimeline(String elementId, AnimationTimeLine timeline) {
    final value = state.value.copyWithTimeline(
      elementId: elementId,
      timeline: timeline,
    );

    state.set(value);
  }

  void deleteTimeline(String elementId, String timelineId) {
    state.set(state.value.removeTimeline(elementId, timelineId));
  }

  void reorderTimelines(String elementId, int oldIndex, int newIndex) {
    final element = state.value.getAnimationElementById(elementId);
    final timelines =
        List<AnimationTimeLine>.from(element.animations).reordered(
      oldIndex,
      newIndex,
    );
    final newElement = element.copyWith(animations: timelines);

    state.set(state.value.copyWithElement(element: newElement));
  }
}
