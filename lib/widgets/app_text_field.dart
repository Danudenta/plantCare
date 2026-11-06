import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// TextField bergaris dengan pesan error di bawah field.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.helperText,
    this.focusNode,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
