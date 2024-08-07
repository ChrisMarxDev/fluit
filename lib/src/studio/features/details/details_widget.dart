import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/design_system/widgets/count_selector.dart';
import 'package:fluit/src/studio/animations.dart';
import 'package:fluit/src/studio/features/details/widgets/alignment_dropdown.dart';
import 'package:fluit/src/studio/features/details/widgets/curve_dropdown.dart';
import 'package:fluit/src/studio/studio_logic.dart';
import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final frame =
        studioStateController.select(context, (c) => c.selectedKeyFrame);

    if (frame == null) {
      return Container();
    }

    return SpecificDetailsWidget(
      frame: frame,
    );
  }
}

class SpecificDetailsWidget extends StatelessWidget {
  const SpecificDetailsWidget({
    required this.frame,
    super.key,
  });

  final AnimationFrame frame;

  @override
  Widget build(BuildContext context) {
    final path =
        studioStateController.select(context, (c) => c.selectedKeyFrameId)!;
    switch (frame) {
      case (final FadeTransitionFrame frame):
        return FadeDetailsWidget(
          path: path,
          frame: frame,
        );
      case (final ScaleTransitionFrame frame):
        return ScaleDetailsWidget(
          path: path,
          frame: frame,
        );
      case (final RotationTransitionFrame frame):
        return RotationDetailsWidget(
          frame: frame,
          path: path,
        );
      case (final PositionTransitionFrame frame):
        return PositionDetailsWidget(
          frame: frame,
          path: path,
        );
      case (final SlideTransitionFrame frame):
        return SlideDetailsWidget(
          frame: frame,
          path: path,
        );
      case (final SizeTransitionFrame frame):
        return SizeDetailsWidget(
          frame: frame,
          path: path,
        );
    }
    return const SizedBox();
  }
}

class BaseDetailsWidget extends StatelessWidget {
  const BaseDetailsWidget({
    required this.child,
    required this.frame,
    required this.path,
    super.key,
  });

  final Widget child;
  final AnimationFrame frame;
  final SelectionPath path;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Details', style: context.t1),
                IconButton(
                  onPressed: () {
                    studioStateController.of(context).deleteKeyFrame(path);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Position', style: context.t2),
            CountSelector(
              value: frame.position,
              max: 1,
              step: 0.05,
              onChanged: (value) {
                final keyFrame = frame.copyWith(position: value);
                studioStateController
                    .of(context)
                    .setKeyFrame(path.elementId, path.timelineId!, keyFrame);
              },
            ),
            const SizedBox(height: 8),
            CurveDropdown(
              selectedElement: frame.curve,
              onChanged: (value) {
                final keyFrame = frame.copyWith(curve: value);
                studioStateController
                    .of(context)
                    .setKeyFrame(path.elementId, path.timelineId!, keyFrame);
              },
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class FadeDetailsWidget extends StatelessWidget {
  const FadeDetailsWidget({
    required this.frame,
    required this.path,
    super.key,
  });

  final FadeTransitionFrame frame;
  final SelectionPath path;

  @override
  Widget build(BuildContext context) {
    return BaseDetailsWidget(
      frame: frame,
      path: path,
      child: Column(
        children: [
          Text('Fade', style: context.t2),
          CountSelector(
            value: frame.value,
            max: 1,
            step: 0.05,
            onChanged: (value) {
              final keyFrame = frame.copyWith(relativeRect: value);
              studioStateController.of(context).setKeyFrameByPath(
                    path,
                    keyFrame,
                  );
            },
          ),
        ],
      ),
    );
  }
}

class ScaleDetailsWidget extends StatelessWidget {
  const ScaleDetailsWidget({
    required this.frame,
    required this.path,
    super.key,
  });

  final ScaleTransitionFrame frame;
  final SelectionPath path;

  @override
  Widget build(BuildContext context) {
    return BaseDetailsWidget(
      path: path,
      frame: frame,
      child: Column(
        children: [
          Text('Scale', style: context.t2),
          CountSelector(
            value: frame.value,
            max: 1,
            step: 0.05,
            onChanged: (value) {
              final keyFrame = frame.copyWith(relativeRect: value);
              studioStateController.of(context).setKeyFrameByPath(
                    path,
                    keyFrame,
                  );
            },
          ),
          AlignmentDropdown(
              onChanged: (value) {
                final keyFrame = frame.copyWith(alignment: value);
                studioStateController.of(context).setKeyFrameByPath(
                      path,
                      keyFrame,
                    );
              },
              selectedElement: frame.alignment),
        ],
      ),
    );
  }
}

class RotationDetailsWidget extends StatelessWidget {
  const RotationDetailsWidget({
    required this.frame,
    required this.path,
    super.key,
  });

  final RotationTransitionFrame frame;
  final SelectionPath path;

  @override
  Widget build(BuildContext context) {
    return BaseDetailsWidget(
      path: path,
      frame: frame,
      child: Column(
        children: [
          Text('Rotation', style: context.t2),
          CountSelector(
            value: frame.value,
            max: 20,
            min: -20,
            step: 0.1,
            onChanged: (value) {
              final keyFrame = frame.copyWith(relativeRect: value);
              studioStateController.of(context).setKeyFrameByPath(
                    path,
                    keyFrame,
                  );
            },
          ),
          AlignmentDropdown(
            onChanged: (value) {
              final keyFrame = frame.copyWith(alignment: value);
              studioStateController.of(context).setKeyFrameByPath(
                    path,
                    keyFrame,
                  );
            },
            selectedElement: frame.alignment,
          ),
        ],
      ),
    );
  }
}

class PositionDetailsWidget extends StatelessWidget {
  const PositionDetailsWidget({
    required this.frame,
    required this.path,
    super.key,
  });

  final PositionTransitionFrame frame;
  final SelectionPath path;

  @override
  Widget build(BuildContext context) {
    return BaseDetailsWidget(
      path: path,
      frame: frame,
      child: Column(
        children: [
          Text('Position', style: context.t2),
          // CountSelector(
          //   value: frame.value.dx,
          //   max: 1,
          //   step: 0.05,
          //   onChanged: (value) {
          //     final keyFrame =
          //         frame.copyWith(value: Offset(value, frame.value.dy));
          //     studioStateController.of(context).setKeyFrame(
          //           path.elementId,
          //           path.timelineId!,
          //           keyFrame,
          //         );
          //   },
          // ),
          // CountSelector(
          //   value: frame.value.dy,
          //   max: 1,
          //   step: 0.05,
          //   onChanged: (value) {
          //     final keyFrame =
          //         frame.copyWith(value: Offset(frame.value.dx, value));
          //     studioStateController.of(context).setKeyFrame(
          //           path.elementId,
          //           path.timelineId!,
          //           keyFrame,
          //         );
          //   },
          // ),
        ],
      ),
    );
  }
}

class SlideDetailsWidget extends StatelessWidget {
  const SlideDetailsWidget({
    required this.frame,
    required this.path,
    super.key,
  });

  final SlideTransitionFrame frame;
  final SelectionPath path;

  @override
  Widget build(BuildContext context) {
    return BaseDetailsWidget(
      path: path,
      frame: frame,
      child: Column(
        children: [
          Text('Slide', style: context.t2),
          CountSelector(
            value: frame.value.dx,
            max: 1,
            min: -1,
            step: 0.05,
            onChanged: (value) {
              final keyFrame =
                  frame.copyWith(relativeRect: Offset(value, frame.value.dy));
              studioStateController.of(context).setKeyFrame(
                    path.elementId,
                    path.timelineId!,
                    keyFrame,
                  );
            },
          ),
          CountSelector(
            value: frame.value.dy,
            max: 1,
            min: -1,
            step: 0.05,
            onChanged: (value) {
              final keyFrame =
                  frame.copyWith(relativeRect: Offset(frame.value.dx, value));
              studioStateController.of(context).setKeyFrame(
                    path.elementId,
                    path.timelineId!,
                    keyFrame,
                  );
            },
          ),
        ],
      ),
    );
  }
}

class SizeDetailsWidget extends StatelessWidget {
  const SizeDetailsWidget({
    required this.frame,
    required this.path,
    super.key,
  });

  final SizeTransitionFrame frame;
  final SelectionPath path;

  @override
  Widget build(BuildContext context) {
    return BaseDetailsWidget(
      path: path,
      frame: frame,
      child: Column(
        children: [
          Text('Size', style: context.t2),
          CountSelector(
            value: frame.sizeFactor,
            max: 1,
            step: 0.05,
            onChanged: (value) {
              final keyFrame = frame.copyWith(sizeFactor: value);
              studioStateController.of(context).setKeyFrameByPath(
                    path,
                    keyFrame,
                  );
            },
          ),
          const SizedBox(height: 8),
          CountSelector(
            value: frame.axisAlignment,
            max: 1,
            step: 0.05,
            onChanged: (value) {
              final keyFrame = frame.copyWith(axisAlignment: value);
              studioStateController.of(context).setKeyFrameByPath(
                    path,
                    keyFrame,
                  );
            },
          ),
          const SizedBox(height: 8),
          AxisDropdown(
              onChanged: (value) {
                final keyFrame = frame.copyWith(axis: value);
                studioStateController.of(context).setKeyFrameByPath(
                      path,
                      keyFrame,
                    );
              },
              selectedElement: frame.axis),
        ],
      ),
    );
  }
}
