// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardListenerFlow extends StatefulWidget {
  const KeyboardListenerFlow({
    super.key,
    this.onEnterPressed,
    this.onAnyKeyPressed,
    required this.child,
  });

  final VoidCallback? onEnterPressed;
  final VoidCallback? onAnyKeyPressed;
  final Widget child;

  @override
  State<KeyboardListenerFlow> createState() => _KeyboardListenerFlowState();
}

class _KeyboardListenerFlowState extends State<KeyboardListenerFlow> {
  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_keyboardCallback);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_keyboardCallback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _keyboardCallback(RawKeyEvent keyEvent) {
    if (keyEvent is! RawKeyDownEvent) return;
    if (widget.onAnyKeyPressed != null) {
      widget.onAnyKeyPressed!();
    }
    ;

    if (keyEvent.data.logicalKey == LogicalKeyboardKey.enter) {
      if (widget.onEnterPressed != null) {
        widget.onEnterPressed!();
      }
    }
  }
}
