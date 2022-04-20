import 'package:example_project/styles/color_palette.dart';
import 'package:example_project/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Main text field widget inspired by ui kit
class MainTextField extends StatelessWidget {
  final TextEditingController? controller;

  final String? hintText;

  final FocusNode? focusNode;

  final int? maxLines;

  final Function(String)? onChanged;

  final VoidCallback? onEditingComplete;

  final String? Function(String)? validate;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool obscureText;

  const MainTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.focusNode,
    this.maxLines,
    this.onChanged,
    this.validate,
    this.onEditingComplete,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      onEditingComplete: onEditingComplete,
      validator: (value) => validate?.call(value ?? ''),
      maxLines: maxLines,
      controller: controller,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      obscureText: obscureText,
      style: ProjectTextStyles.ui_14Regular.copyWith(
        color: ColorPalette.black,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        hintText: hintText,
        hintStyle: ProjectTextStyles.ui_14Regular.copyWith(
          color: ColorPalette.lightGray,
          height: 1.0,
        ),
        border: _buildBorder(),
        focusedBorder: _buildBorder(),
        errorBorder: _buildBorder(),
        enabledBorder: _buildBorder(),
        disabledBorder: _buildBorder(),
        focusedErrorBorder: _buildBorder(),
      ),
    );
  }

  OutlineInputBorder _buildBorder(
      {Color color = ColorPalette.borderLightGray}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}
