import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountSelector<T extends num> extends StatefulWidget {
  const CountSelector({
    super.key,
    this.value = 0,
    this.onChanged,
    this.displayFunction,
    this.min = 0,
    this.max = 999999,
    this.step = 1,
    this.style,
  });

  final double value;
  final void Function(double value)? onChanged;
  final String Function(double value)? displayFunction;
  final double min;
  final double max;

  /// The step to increment or decrement by.
  final double step;
  final TextStyle? style;

  @override
  State<CountSelector> createState() => _CountSelectorState();
}

class _CountSelectorState extends State<CountSelector> {
  late double value;
  late TextEditingController controller;
  late String Function(double value) displayFunction;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    displayFunction =
        widget.displayFunction ?? (value) => value.toStringAsFixed(2);
    value = widget.value;
    controller = TextEditingController(text: displayFunction(value));
    focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant CountSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        widget.value != double.tryParse(controller.text)) {
      setState(() {
        displayFunction =
            widget.displayFunction ?? (value) => value.toStringAsFixed(2);
        value = widget.value;
        controller.text = displayFunction(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepSize = widget.step;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              if (widget.value - stepSize >= widget.min) {
                widget.onChanged?.call(widget.value - stepSize);
              } else {
                widget.onChanged?.call(widget.min);
              }
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 8),
          Container(
            height: 52,
            width: 72,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.primary),
            ),
            child: TextField(
              key: Key('counter_$value'),
              focusNode: focusNode,
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                // allow digits and decimal point
                FilteringTextInputFormatter.allow(RegExp(r'-?[0-9]*\.?[0-9]*')),
              ],
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (value) {
                // widget.onChanged?.call(double.tryParse(value) ?? 0);
              },
              onSubmitted: (value) {
                widget.onChanged?.call(double.tryParse(value) ?? 0);
              },
              onTapOutside: (details) {
                widget.onChanged?.call(widget.value);
              },
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.top,
              // displayFunction(widget.value),
              style: widget.style ?? context.t2,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              if (widget.value + stepSize <= widget.max) {
                widget.onChanged?.call(widget.value + stepSize);
              } else {
                widget.onChanged?.call(widget.max);
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
