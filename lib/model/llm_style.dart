import 'package:flutter/material.dart';

class LlmMessageStyle {
  const LlmMessageStyle({
    this.assistantIcon,
    this.userIcon,
    this.inputPadding,
    this.sendIcon,
    this.userTextStyle,
    this.assistantTextStyle,
    this.inputTextStyle,
    this.systemTextStyle,
    this.systemColor,
    this.inputBoxColor,
    required this.userColor,
    required this.assistantColor,
  });

  final Color userColor;
  final TextStyle? userTextStyle;
  final TextStyle? assistantTextStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? systemTextStyle;
  final Color assistantColor;
  final Color? systemColor;
  final Color? inputBoxColor;
  final Widget? sendIcon;
  final EdgeInsets? inputPadding;
  final Widget? assistantIcon;
  final Widget? userIcon;
}
