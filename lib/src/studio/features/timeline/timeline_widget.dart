import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/design_system/widgets/buttons.dart';
import 'package:fluit/src/design_system/widgets/line.dart';
import 'package:fluit/src/studio/animations.dart';
import 'package:fluit/src/studio/features/shortcuts/intents.dart';
import 'package:fluit/src/studio/features/timeline/new_timeline_dialog.dart';
import 'package:fluit/src/studio/features/timeline/playhead.dart';
import 'package:fluit/src/studio/studio_logic.dart';
import 'package:fluit/src/studio/studio_state.dart';
import 'package:fluit/src/util/extensions/context_extension.dart';
import 'package:fluit/src/util/extensions/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:state_beacon/state_beacon.dart';

const labelWidth = 120.0;

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    // rebuilds whenever the name changes
    // return Text(timelineDuration.watch(context).toString());
    final state = studioStateController.select(context, (c) => c.state);

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Double tap to add a new key frame & drag to reorder, select and press backspace to delete',
            style: context.captionWeak,
          ),
          Stack(
            children: [
              Column(
                children: [
                  for (final element in state.elements)
                    ElementTimelines(
                      element: element,
                    ),
                ],
              ),
              const Row(
                children: [
                  SizedBox(width: labelWidth),
                  Expanded(child: PlayheadWrapper()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ElementWrapper extends InheritedWidget {
  const ElementWrapper({
    required this.element,
    required super.child,
    super.key,
  });

  final AnimationElement element;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return element != (oldWidget as ElementWrapper).element;
  }

  static ElementWrapper of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ElementWrapper>()!;
  }

  static ElementWrapper? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ElementWrapper>();
  }
}

class TimelineWrapper extends InheritedWidget {
  const TimelineWrapper({
    required this.timeline,
    required super.child,
    super.key,
  });

  final AnimationTimeLine timeline;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return timeline != (oldWidget as TimelineWrapper).timeline;
  }

  static TimelineWrapper of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TimelineWrapper>()!;
  }

  static TimelineWrapper? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TimelineWrapper>();
  }
}

class ElementTimelines extends StatelessWidget {
  const ElementTimelines({required this.element, super.key});

  final AnimationElement element;

  @override
  Widget build(BuildContext context) {
    final animations = element.animations;
    return ElementWrapper(
      element: element,
      child: Column(
        children: [
          ReorderableListView(
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            // prototypeItem: const SizedBox(),
            proxyDecorator: (child, index, animation) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.primary,
                    width: 2,
                  ),
                ),
                child: child,
              );
            },
            shrinkWrap: true,
            onReorder: (oldIndex, newIndex) {
              studioStateController.of(context).reorderTimelines(
                    element.id,
                    oldIndex,
                    newIndex,
                  );
            },
            children: [
              for (var i = 0; i < animations.length; i++)
                Row(
                  key: Key(animations[i].id),
                  children: [
                    ReorderableDragStartListener(
                      index: i,
                      child: Icon(
                        Icons.drag_handle,
                        color: context.primary,
                      ),
                    ),
                    Expanded(
                      child: SingleTimelineWidget(
                        timeline: animations[i],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          AsyncElevatedButton(
            onPressed: () async {
              final newTimeline =
                  await NewTimelineDialog.show(context, element.id);
              if (newTimeline != null) {
                studioStateController
                    .of(context)
                    .addTimeline(element.id, newTimeline);
              }
            },
            child: Text(context.tr('add_timeline')),
          ),
        ],
      ),
    );
  }
}

class SingleTimelineWidget extends StatelessWidget {
  const SingleTimelineWidget({required this.timeline, super.key});

  final AnimationTimeLine timeline;

  @override
  Widget build(BuildContext context) {
    return TimelineWrapper(
      timeline: timeline,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            SizedBox(
              width: labelWidth,
              child: Row(
                children: [
                  Text(timeline.type.name),
                  IconButton(
                    onPressed: () {
                      studioStateController.of(context).deleteTimeline(
                            ElementWrapper.of(context).element.id,
                            timeline.id,
                          );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  print('constraints: $constraints');
                  return DragTarget<AnimationFrameDragData>(
                    onWillAcceptWithDetails: (details) {
                      final dragTimeline = details.data.timeline;
                      final isSameTimeline = dragTimeline.id == timeline.id;

                      return isSameTimeline;
                    },
                    onAcceptWithDetails: (details) {
                      final frame = details.data;
                      final controller = studioStateController.of(context);

                      print('offset: ${details.offset.dx}');
                      print('maxWidth: ${constraints.maxWidth}');
                      print('minWidth: ${constraints.minWidth}');

                      final offset = details.offset.dx + 32 / 2 - 120;
                      final relativeOffset = offset / constraints.maxWidth;

                      final newFrame = frame.keyFrame
                          .copyWith(position: relativeOffset.clamp(0, 1));
                      final element = ElementWrapper.of(context).element;
                      print('new position: $relativeOffset');
                      controller.setKeyFrame(element.id, timeline.id, newFrame);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onDoubleTapDown: (details) {
                                final position = details.localPosition.dx /
                                    constraints.maxWidth;
                                print(
                                  'tapped ${details.localPosition}, value: $position',
                                );
                                final newFrame =
                                    timeline.type.createFrame(position);

                                final element =
                                    ElementWrapper.of(context).element;

                                studioStateController.of(context).setKeyFrame(
                                      element.id,
                                      timeline.id,
                                      newFrame,
                                    );
                              },
                              child: Container(
                                color: context.background,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: HorizontalLine(
                                  color: context.secondary,
                                ),
                              ),
                            ),
                          ),
                          if (timeline.animationFrames.isEmpty)
                            const Text('No Keyframes'),
                          for (final keyFrame in timeline.animationFrames)
                            Align(
                              alignment: Alignment(
                                keyFrame.position.mapToSpace(
                                  NumberSpace(0, 1),
                                  NumberSpace(-1, 1),
                                ),
                                0,
                              ),
                              child: KeyFrameIndicator(
                                keyFrame: keyFrame,
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyFrameIndicator extends StatefulWidget {
  const KeyFrameIndicator({
    required this.keyFrame,
    super.key,
  });

  final AnimationFrame keyFrame;

  @override
  State<KeyFrameIndicator> createState() => _KeyFrameIndicatorState();
}

class AnimationFrameDragData {
  const AnimationFrameDragData({
    required this.keyFrame,
    required this.timeline,
  });

  final AnimationFrame keyFrame;
  final AnimationTimeLine timeline;
}

class _KeyFrameIndicatorState extends State<KeyFrameIndicator> {
  late final FocusNode focusNode;

  SelectionPath? get thisSelectionPath {
    final element = ElementWrapper.maybeOf(context)?.element;
    final timeline = TimelineWrapper.maybeOf(context)?.timeline;
    final keyFrameId = widget.keyFrame.id;
    if (element == null || timeline == null) {
      return null;
    }
    return SelectionPath(element.id, timeline.id, keyFrameId);
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          studioStateController.of(context).selectKeyFrame(thisSelectionPath);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected =
        studioStateController.select(context, (c) => c.selectedKeyFrameId) ==
            thisSelectionPath;

    return FocusableActionDetector(
      focusNode: focusNode,
      actions: {
        DeleteIntent: CallbackAction<DeleteIntent>(
          onInvoke: (intent) {
            focusNode.unfocus();
            final path = thisSelectionPath;
            if (path != null) {
              studioStateController.of(context).deleteKeyFrame(path);
            }
            return true;
          },
        ),
      },
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.backspace): const DeleteIntent(),
      },
      child: GestureDetector(
        onTap: () {
          focusNode.requestFocus();
          // print('tapped');
          //
          // studioStateController.of(context).selectKeyFrame(
          //       thisSelectionPath,
          //     );
        },
        child: Draggable(
          data: AnimationFrameDragData(
            keyFrame: widget.keyFrame,
            timeline: TimelineWrapper.of(context).timeline,
          ),
          childWhenDragging: const _Indicator(
            lowOpacity: true,
          ),
          feedback: const Material(
            color: Colors.transparent,
            child: _Indicator(
              lowOpacity: true,
            ),
          ),
          child: _Indicator(isHighlighted: isSelected),
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    this.lowOpacity = false,
    this.isHighlighted = false,
  });

  final bool lowOpacity;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.primary.withOpacity(lowOpacity ? 0.5 : 1),
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: isHighlighted ? context.secondary : Colors.transparent,
        ),
      ),
      child: Center(
        child: Icon(Icons.key, color: context.onPrimary),
      ),
    );
  }
}
