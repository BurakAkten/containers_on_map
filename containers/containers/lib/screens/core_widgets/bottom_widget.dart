import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../base/constants/app_constants.dart';

class BottomWidget extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  final Color? iconColor;
  final Widget? child;

  const BottomWidget({super.key, required this.title, required this.iconData, required this.iconColor}) : child = null;

  const BottomWidget.withChild({super.key, required this.child})
      : title = null,
        iconData = null,
        iconColor = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 336,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacingMedium,
        AppSpacing.spacingXLarge,
        AppSpacing.spacingLarge,
        AppSpacing.spacingXLarge,
      ),
      decoration: const BoxDecoration(
        color: AppColors.light,
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 4, spreadRadius: 2),
        ],
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
      ),
      child: child ??
          Row(
            children: [
              Icon(iconData, color: iconColor, size: AppIconSize.medium),
              const SizedBox(width: AppSpacing.spacingSmall),
              Expanded(
                child: AutoSizeText(
                  title!,
                  style: AppFontUtils.t1,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
    );
  }
}
