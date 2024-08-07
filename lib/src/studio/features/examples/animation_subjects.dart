import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

final subjectBuildersBeacon = Beacon.lazyWritable<Map<String, WidgetBuilder>>();

final premadeExamples = {
  'Flutter Logo': (context) => const FlutterLogo(),
  'Container Example': (context) => const ContainerExample(),
  'Text Example': (context) => const Text('Hello Fluit'),
};

class ContainerExample extends StatelessWidget {
  const ContainerExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.blue,
    );
  }
}
