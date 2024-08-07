import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/studio/features/controls/play_controls_wrapper.dart';
import 'package:fluit/src/studio/features/examples/animation_subjects.dart';
import 'package:fluit/src/studio/studio_screen.dart';
import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

Future<void> initFluit() async {
  WidgetsFlutterBinding.ensureInitialized();
}

class FluitStudio extends StatefulWidget {
  const FluitStudio({
    super.key,
    this.subjects,
  });

  /// A map of example widgets that can be used as subjects for animations.
  final Map<String, Widget Function(BuildContext)>? subjects;

  @override
  State<FluitStudio> createState() => _FluitStudioState();
}

class _FluitStudioState extends State<FluitStudio> {
  @override
  void initState() {
    super.initState();
    BeaconObserver.instance = LoggingObserver();
    subjectBuildersBeacon.value = widget.subjects ?? premadeExamples;
  }

  @override
  Widget build(BuildContext context) {
    return const LiteRefScope(
      child: FluitStudioApp(),
    );
  }
}

class FluitStudioApp extends StatelessWidget {
  const FluitStudioApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getThemeData(),
      home: const AnimationControlsWrapper(
        child: StudioScreen(),
      ),
    );
  }
}
