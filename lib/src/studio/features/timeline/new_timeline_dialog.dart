import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/design_system/widgets/base_dialog.dart';
import 'package:fluit/src/studio/animations.dart';
import 'package:fluit/src/studio/studio_logic.dart';
import 'package:fluit/src/studio/studio_state.dart';
import 'package:fluit/src/util/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

final animationTypeBeacon = Beacon.writable<AnimationType>(AnimationType.scale);
final animationCurveBeacon = Beacon.writable<Curve>(Curves.easeInOut);
final animationCurveFlipBeacon = Beacon.writable<bool>(false);

const curves = [
  Curves.linear,
  Curves.easeIn,
  Curves.easeOut,
  Curves.easeInOut,
  Curves.bounceIn,
  Curves.bounceOut,
  Curves.bounceInOut,
  Curves.decelerate,
  Curves.fastLinearToSlowEaseIn,
  Curves.fastOutSlowIn,
  Curves.linearToEaseOut,
  Curves.slowMiddle,
  Curves.slowMiddle,
];

class NewTimelineDialog extends StatelessWidget {
  const NewTimelineDialog({required this.elementId, super.key});

  static Future<AnimationTimeLine?> show(
      BuildContext context, String elementId) async {
    return showDialog<AnimationTimeLine?>(
      context: context,
      builder: (context) {
        return NewTimelineDialog(elementId: elementId);
      },
    );
  }

  final String elementId;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: context.tr('new_timeline'),
      bodyWidget: Column(
        children: [
          Row(
            children: [
              Text(context.tr('type')),
              Expanded(
                child: DropdownButton<AnimationType>(
                  value: animationTypeBeacon.watch(context),
                  onChanged: (value) {
                    if (value != null) {
                      animationTypeBeacon.set(value);
                    }
                  },
                  items: AnimationType.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      buttons: [
        ButtonData(
          text: context.tr('cancel'),
          onPressed: Navigator.pop,
          highlighted: false,
          color: context.primary,
        ),
        ButtonData(
          text: context.tr('create'),
          onPressed: (context) async {
            final flipped = animationCurveFlipBeacon.watch(context);
            final curve = flipped
                ? animationCurveBeacon.watch(context).flipped
                : animationCurveBeacon.watch(context);
            final newTimeline = AnimationTimeLine(
              type: animationTypeBeacon.watch(context),
              id: randomId,
              animationFrames: [],
            );

            Navigator.pop(
              context,
              newTimeline,
            );
          },
          color: context.primary,
        ),
      ],
    );
  }
}
