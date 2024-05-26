import 'package:containers/base/constants/app_constants.dart';
import 'package:flutter/material.dart';

typedef OnChanged = void Function(String value);

class TextFieldWidget extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final OnChanged? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;

  const TextFieldWidget({
    super.key,
    this.labelText,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller ?? TextEditingController(),
      keyboardType: keyboardType ?? TextInputType.text,
      style: AppFontUtils.t1,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: AppColors.yellow)),
        border: const UnderlineInputBorder(borderSide: BorderSide(width: 1, color: AppColors.shadowColor)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: AppColors.error)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.shadowColor)),
        contentPadding: const EdgeInsets.only(bottom: 6.5, top: 1),
        labelText: labelText,
        floatingLabelStyle: AppFontUtils.filledInputLabel,
        labelStyle: AppFontUtils.inActiveInput,
        suffixIcon: suffixIcon,
        errorStyle: const TextStyle(height: 0),
      ),
      onChanged: (text) {
        if (onChanged != null) onChanged!(text);
      },
      textAlignVertical: TextAlignVertical.center,
      validator: validator,
    );
  }
}
