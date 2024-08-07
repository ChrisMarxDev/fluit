import 'package:dart_style/dart_style.dart';
import 'package:mustache_template/mustache_template.dart';

import '../../studio_state.dart';
import 'animation_generation_data.dart';

class CodeGenerator {
  CodeGenerator();

  String recursiveGenerateNestedAnimations(
      List<AnimationGenerationFrameData> animations) {
    if (animations.isEmpty) {
      return 'widget.child';
    } else {
      final animation = animations.first;
      return '''
      ${animation.animationType}(
        ${animation.animationType == 'Fade' ? 'opacity' : 'scale'}: ${animation.name},
        ${animation.additionalParameters.join(', \n')},
        child: ${recursiveGenerateNestedAnimations(animations.skip(1).toList())},
      )
      ''';
    }
  }

  String timeLineTweenGen(AnimationTimeLine timeline) {
    //     scaleComposite = TweenSequence<double>(
    //       <TweenSequenceItem<double>>[
    //         TweenSequenceItem<double>(
    //           tween: Tween<double>(begin: beginValueA, end: endValueA)
    //               .chain(CurveTween(curve: curveA)),
    //           weight: 40.0,
    //         ),
    //         TweenSequenceItem<double>(
    //           tween: ConstantTween<double>(10.0),
    //           weight: 20.0,
    //         ),
    //         TweenSequenceItem<double>(
    //           tween: Tween<double>(begin: 10.0, end: 5.0)
    //               .chain(CurveTween(curve: Curves.ease)),
    //           weight: 40.0,
    //         ),
    //       ],
    return '''
    ${timeline.type.name}Transition(
      ${timeline.type.name}: ${timeline.animationFrames.first.name},
      ${timeline.type.name}: ${timeline.animationFrames.last.name},
      child: widget.child,
    )
    ''';
  }

  Future<String> generateCode(
      FluitAnimationState state, int durationInMs) async {
    final generationData = animationGenerationFrameDatafromState(state);

    final generationDataJson = generationData.map((e) => e.toJson()).toList();

    final rawInputData = {
      'animations': generationDataJson,
      'durationInMs': durationInMs
    };
    final source = '''
   import 'package:flutter/material.dart';

class TestAnimation extends StatefulWidget {
  const TestAnimation({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<TestAnimation> createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  // 1. Declare animation variables
  {{#animations}}
  late final Animation<{{tweenType}}> {{name}};
  {{/animations}}


  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: {{durationInMs}}),
    );

    // 2. Create animations
    {{#animations}}
     {{name}} = Tween(
      begin: {{beginValue}},
      end: {{endValue}},
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval({{beginPos}}, {{endPos}}, curve: {{curve}}),
      ),
    );
    {{/animations}}

  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3. Use animations and nest them
    return ${recursiveGenerateNestedAnimations(generationData)};
  }
}

	''';

    final template = Template(source, name: 'template-filename.html');

    final output = template.renderString(rawInputData);

    final formatter = DartFormatter();
    final formatted = formatter.format(output);
    return formatted;
  }
}
