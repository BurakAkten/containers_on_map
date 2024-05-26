import 'package:containers/base/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor = AppColors.green,
    this.textStyle,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    var bgColor =
        !isEnabled ? backgroundColor.withOpacity(0.1) : backgroundColor;
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: InkWell(
        onTap: isEnabled ? onPressed : () {},
        borderRadius: BorderRadius.circular(AppRadius.small),
        child: Container(
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.small)),
          height: height,
          width: width,
          alignment: Alignment.center,
          padding:
              const EdgeInsets.symmetric(vertical: AppSpacing.spacingXSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text!, style: textStyle ?? AppFontUtils.buttonText),
            ],
          ),
        ),
      ),
    );
  }
}
