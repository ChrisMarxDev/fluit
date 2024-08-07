import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/studio/features/controls/play_controls_wrapper.dart';
import 'package:fluit/src/util/extensions/number_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayheadWrapper extends StatelessWidget {
  const PlayheadWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Playhead(
      controller: AnimationControls.of(context).controller,
    );
  }
}

class Playhead extends StatefulWidget {
  const Playhead({
    required this.controller, super.key,
  });

  final AnimationController controller;

  @override
  State<Playhead> createState() => _PlayheadState();
}

class _PlayheadState extends State<Playhead> {
  AnimationController get _controller => widget.controller;

  double get _progress => _controller.value;

  void onControllerUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position =
        _progress.mapToSpace(NumberSpace(0, 1), NumberSpace(-1, 1));
    return Align(
      alignment: Alignment(
        position,
        0,
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            width: 2,
            color: context.secondary,
          ),
        ],
      ),
    );
  }
}
