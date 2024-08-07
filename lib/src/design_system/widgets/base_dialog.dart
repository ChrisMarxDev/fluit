import 'dart:async';

import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/design_system/widgets/buttons.dart';
import 'package:fluit/src/util/extensions/context_extension.dart';
import 'package:fluit/src/util/extensions/list_extension.dart';
import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    required this.title,
    required this.buttons,
    required this.bodyWidget,
    this.hasCloseButton = false,
    super.key,
  });

  final String title;
  final Widget bodyWidget;
  final List<ButtonData> buttons;
  final bool hasCloseButton;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<ButtonData> buttons,
    required Widget bodyWidget,
    bool dismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) {
        return BaseDialog(
          title: title,
          bodyWidget: bodyWidget,
          buttons: buttons,
          hasCloseButton: dismissible,
        );
      },
    );
  }

  static Future<bool> confirmation(
    BuildContext context, {
    required String title,
    required String message,
    Widget? optionalBody,
    bool dismissible = true,
  }) async {
    final isTrue = await showDialog<bool?>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) {
        return BaseDialog(
          title: title,
          bodyWidget: Column(
            children: [
              Text(message),
              if (optionalBody != null) optionalBody,
            ],
          ),
          buttons: [
            ButtonData(
              text: context.tr('confirm'),
              onPressed: (context) => Navigator.pop(context, true),
              color: context.primary,
            ),
            ButtonData(
              text: context.tr('cancel'),
              onPressed: (context) => Navigator.pop(context, false),
              highlighted: false,
              color: context.primary,
            ),
            ButtonData(
              text: context.tr('cancel'),
              onPressed: (context) => Navigator.pop(context, false),
              highlighted: false,
              color: context.primary,
            ),
          ],
        );
      },
    );
    return isTrue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: context.h2,
                      ),
                    ),
                    if (hasCloseButton)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            color: context.onBackground,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                bodyWidget,
                const SizedBox(height: 32),
                if (buttons.length == 1)
                  _generateButton(context, buttons.first, fill: true)
                else
                  _generateButtonList(buttons),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _generateButtonList(List<ButtonData> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var isVertical = false;

        const buttonSpacing = 12.0;
        final maxButtonWidth =
            (constraints.maxWidth - (buttons.length - 1) * buttonSpacing) /
                buttons.length;
        for (final button in data) {
          if (button.estimatedWidth > maxButtonWidth) {
            isVertical = true;
          }
        }

        if (!isVertical) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data
                .map(
                  (buttonData) => _generateButton(
                    context,
                    buttonData,
                    fill: isVertical,
                  ),
                )
                .toList()
                .separatedBy(
                  const SizedBox(width: buttonSpacing),
                ),
          );
        }
        return Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 16,
          spacing: 16,
          children: data
              .map(
                (buttonData) => _generateButton(
                  context,
                  buttonData,
                  fill: isVertical,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _generateButton(
    BuildContext context,
    ButtonData data, {
    bool fill = false,
  }) {
    const minWidth = 120.0;

    if (data.highlighted) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: fill ? double.infinity : minWidth,
          minHeight: 48,
        ),
        child: data.async
            ? AsyncElevatedButton(
                backgroundColor: data.color,
                onPressed: () async => data.onPressed?.call(context),
                child: Text(data.text),
              )
            : ElevatedButton(
                onPressed: () => data.onPressed?.call(context),
                child: Text(data.text),
              ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: fill ? double.infinity : minWidth,
          minHeight: 48,
        ),
        child: OutlinedButton(
          onPressed: () => data.onPressed?.call(context),
          child: Text(data.text),
        ),
      );
    }
  }
}

class ButtonData {
  ButtonData({
    required this.text,
    required this.onPressed,
    this.highlighted = true,
    this.async = false,
    this.color,
  });

  final String text;
  final bool async;
  final FutureOr<void> Function(BuildContext context)? onPressed;
  final bool highlighted;
  final Color? color;

  double get estimatedWidth => text.length * 18 * 1;
}
