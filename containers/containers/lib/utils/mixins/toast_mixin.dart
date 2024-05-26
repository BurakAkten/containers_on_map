import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../base/constants/app_constants.dart';

mixin ToastMixin {
  late FToast fToast;

  initToast(BuildContext context) {
    fToast = FToast()..init(context);
  }

  showToast({required Widget child, int seconds = 3, bool isDismissable = false}) {
    fToast.showToast(
        child: child,
        toastDuration: Duration(seconds: seconds),
        isDismissable: isDismissable,
        gravity: ToastGravity.BOTTOM,
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: AppSpacing.spacingXLarge * 4,
            left: AppSpacing.spacingSmall,
            right: AppSpacing.spacingSmall,
            child: child,
          );
        });
  }
}
