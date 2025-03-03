import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:state_beacon/state_beacon.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import 'package:fluit/src/studio/studio_logic.dart';

final highlighterFutureBeacon = Beacon.future<Highlighter>(
  () async {
    try {
      // Initialize the highlighter.
      await Highlighter.initialize([
        'dart',
      ]);

// Load the default light theme and create a highlighter.
      final theme = await HighlighterTheme.loadLightTheme();
      final highlighter = Highlighter(
        language: 'dart',
        theme: theme,
      );

      return highlighter;
    } on Exception catch (e) {
      print('highlighter init error: $e');
      rethrow;
    }
  },
);

class CodeView extends StatelessWidget {
  const CodeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final highlighter = highlighterFutureBeacon;
    final code = studioStateController.select(context, (c) => c.derivedCode);
    if (highlighter.isData && code.isData) {
      return HighlightView(
        highlighter: highlighter.unwrapValue(),
        code: code.unwrap(),
      );
    } else if (code.isError) {
      return Center(child: Text((code as AsyncError).error.toString()));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class HighlightView extends StatelessWidget {
  const HighlightView({
    required this.highlighter,
    required this.code,
    super.key,
  });

  final Highlighter highlighter;
  final String code;

  @override
  Widget build(BuildContext context) {
    final highlightedCode = highlighter.highlight(code);
    return Column(
      children: [
        Row(
          children: [
            const Text('Code'),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                  ),
                );
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SelectableText.rich(highlightedCode),
          ),
        ),
      ],
    );
  }
}
