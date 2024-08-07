import 'package:flutter/material.dart';

typedef IsEnabledCheck<T extends Intent> = bool Function(T intent);

class CallbackEnabledAction<T extends Intent> extends Action<T> {
  /// A constructor for a [CallbackEnabledAction].
  ///
  /// The given callback is used as the implementation of [invoke].
  CallbackEnabledAction({required this.onInvoke, this.isEnabledCheck});

  final IsEnabledCheck<T>? isEnabledCheck;

  /// The callback to be called when invoked.
  ///
  /// This is effectively the implementation of [invoke].
  @protected
  final OnInvokeCallback<T> onInvoke;

  @override
  Object? invoke(T intent) => onInvoke(intent);

  @override
  bool isEnabled(T intent) => isEnabledCheck?.call(intent) ?? true;
}
