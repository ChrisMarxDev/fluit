// ignore_for_file: prefer_const_constructors

import 'package:fluit/src/studio/animations.dart';
import 'package:fluit/src/studio/studio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final frame1 = ScaleTransitionFrame(id: 'frame1', value: 0);
  final timeline1 = AnimationTimeLine(
    type: AnimationType.scale,
    id: 'timeline1',
    animationFrames: [
      frame1,
      ScaleTransitionFrame(id: 'frame2', position: 0.5),
    ],
  );
  final element1 = AnimationElement(
    id: 'element1',
    animations: [
      timeline1,
      AnimationTimeLine(
        type: AnimationType.fade,
        id: 'timeline2',
        animationFrames: [
          FadeTransitionFrame(id: 'frame1', value: 0.5),
          FadeTransitionFrame(id: 'frame2', position: 0.25, value: 3),
        ],
      ),
    ],
  );
  final state = FluitAnimationState(
    elements: [
      element1,
      AnimationElement(
        id: 'element2',
        animations: [
          AnimationTimeLine(
            type: AnimationType.position,
            id: 'timeline1',
            animationFrames: [
              PositionTransitionFrame(
                  id: 'frame1',
                  relativeRect: RelativeRect.fromLTRB(0, 0, 0, 0)),
              PositionTransitionFrame(id: 'frame2', position: 0.5),
            ],
          ),
        ],
      ),
    ],
  );

  final newFrame = ScaleTransitionFrame(id: 'frameNew1', value: 0);
  final newTimeline = AnimationTimeLine(
    type: AnimationType.scale,
    id: 'timelineNew1',
    animationFrames: [
      newFrame,
      ScaleTransitionFrame(id: 'frameNew2', position: 0.5),
      ScaleTransitionFrame(id: 'frameNew3', position: 0.8, value: 0.5),
    ],
  );
  final newElement = AnimationElement(
    id: 'elementNew1',
    animations: [
      newTimeline,
      AnimationTimeLine(
        type: AnimationType.fade,
        id: 'timelineNew2',
        animationFrames: [
          FadeTransitionFrame(id: 'frameNew1', value: 0.5),
          FadeTransitionFrame(id: 'frameNew2', position: 0.25, value: 3),
        ],
      ),
      AnimationTimeLine(
        type: AnimationType.rotation,
        id: 'timelineNew3',
        animationFrames: [
          RotationTransitionFrame(id: 'frameNew1', value: 0),
          RotationTransitionFrame(id: 'frameNew2', position: 0.5),
          RotationTransitionFrame(id: 'frameNew3', position: 0.8, value: 0.5),
        ],
      ),
    ],
  );
  group('StudioState', () {
    test('Getters work', () {
      final element = state.getAnimationElementById('element1');
      final timeline = state.getAnimationTimelineById('element1', 'timeline1');
      final frame = state.getKeyFrameById('element1', 'timeline1', 'frame1');

      expect(element, element1);
      expect(timeline, timeline1);
      expect(frame, frame1);

      expect('', isNotNull);
    });

    test('Upsert functions work', () {
      var newState = state.copyWithElement(element: newElement);

      final element = newState.getAnimationElementById('elementNew1');
      expect(element, newElement);

      newState = newState.copyWithTimeline(
        elementId: 'element1',
        timeline: newTimeline,
      );

      final timeline =
          newState.getAnimationTimelineById('element1', 'timelineNew1');
      expect(timeline, newTimeline);
      newState = newState.copyWithKeyFrame(
        elementId: 'element1',
        timeLineId: 'timeline1',
        keyFrame: newFrame,
      );
      final frame =
          newState.getKeyFrameById('element1', 'timeline1', 'frameNew1');

      expect(frame, newFrame);
    });

    test('Remove functions work', () {
      var newState = state.removeKeyFrame('element1', 'timeline1', 'frame1');
      final timeline =
          newState.getAnimationTimelineById('element1', 'timeline1');
      expect(timeline?.animationFrames.length, 1);

      newState = state.removeTimeline('element1', 'timeline1');
      final element = newState.getAnimationElementById('element1');
      expect(element.animations.length, 1);

      newState = state.removeElement('element1');
      expect(newState.elements.length, 1);
    });
  });

  group('AnimationElement', () {
    test('Getters work', () {
      final timeline = element1.getAnimationTimelineById('timeline1');
      final frame = element1.getFrameById('timeline1', 'frame1');

      expect(timeline, timeline1);
      expect(frame, frame1);
    });
    test('Upsert functions work', () {
      final newElement = element1.copyWithTimeline(timeline: newTimeline);

      final timeline = newElement.getAnimationTimelineById('timelineNew1');
      final frame = newElement.getFrameById('timelineNew1', 'frameNew1');

      expect(timeline, newTimeline);
      expect(frame, newFrame);
    });

    test('Remove functions work', () {
      final newElement = element1.removeTimeline('timeline1');
      expect(newElement.animations.length, 1);
    });
  });
}
