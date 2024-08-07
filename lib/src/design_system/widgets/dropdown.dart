import 'package:flutter/material.dart';

class BrutDropDown<T> extends StatelessWidget {
  const BrutDropDown({
    required this.onChanged,
    required this.selectedElement,
    required this.itemBuilder,
    required this.items,
    this.selectedBuilder,
    this.hint,
    super.key,
  });

  final T? selectedElement;
  final List<T> items;
  final Widget? hint;
  final Widget Function(BuildContext context, T value) itemBuilder;
  final Widget Function(BuildContext context, T value)? selectedBuilder;
  final void Function(T value) onChanged;

  @override
  Widget build(
    BuildContext context,
  ) {
    return DropdownButton<T>(
      value: selectedElement,
      onChanged: (value) {
        onChanged(value as T);
      },
      underline: Container(),
      hint: hint,
      selectedItemBuilder: selectedBuilder != null
          ? (context) => items.map((e) => selectedBuilder!(context, e)).toList()
          : null,
      items: [
        for (final element in items)
          DropdownMenuItem(
            value: element,
            child: itemBuilder(context, element),
          ),
      ],
    );
  }
}
