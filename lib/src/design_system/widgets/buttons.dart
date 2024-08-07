import 'package:fluit/src/design_system/custom_theme.dart';
import 'package:fluit/src/design_system/widgets/swap_animation.dart';
import 'package:flutter/material.dart';

class AsyncElevatedButton extends StatefulWidget {
  const AsyncElevatedButton({
    required this.child,
    super.key,
    this.onPressed,
    this.backgroundColor,
  });

  final Widget child;
  final Future<void> Function()? onPressed;
  final Color? backgroundColor;

  @override
  State<AsyncElevatedButton> createState() =>
      _AsyncElevatedButtonState();
}

class _AsyncElevatedButtonState extends State<AsyncElevatedButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed == null
          ? null
          : () {
        setState(() {
          isLoading = true;
        });
        Future.wait([
          widget.onPressed!(),
          Future<void>.delayed(
            widget.onPressed == null
                ? Duration.zero
                : const Duration(milliseconds: 500),
          ),
        ])
          ..then(
                (value) => setState(
                  () {
                isLoading = false;
              },
            ),
          )
          ..catchError((error) {
            setState(() {
              isLoading = false;
            });
            return <void>[];
          });
      },
      child: SwapAnimationWrapper(
        duration: kDurationQuick,
        child: isLoading
            ? Stack(
          children: [
            Opacity(opacity: 0, child: widget.child),
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(context.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        )
            : widget.child,
      ),
    );
  }
}