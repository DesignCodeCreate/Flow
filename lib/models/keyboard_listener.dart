// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardListenerFlow extends StatefulWidget {
  const KeyboardListenerFlow({
    super.key,
    required this.onEnterPressed,
    required this.child,
  });

  final VoidCallback onEnterPressed;
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

    if (keyEvent.data.logicalKey == LogicalKeyboardKey.enter) {
      widget.onEnterPressed();
    }
  }
}
