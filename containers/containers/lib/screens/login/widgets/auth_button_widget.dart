import 'package:containers/screens/login/viewmodels/auth_viewmodel.dart';
import 'package:containers/utils/mixins/toast_mixin.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../base/constants/app_constants.dart';
import '../../../utils/navigation_util.dart';
import '../../core_widgets/bottom_widget.dart';
import '../../core_widgets/button_widget.dart';

class AuthButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isConnected;
  const AuthButtonWidget({super.key, required this.formKey, required this.isConnected});

  @override
  State<AuthButtonWidget> createState() => _AuthButtonWidgetState();
}

class _AuthButtonWidgetState extends State<AuthButtonWidget> with ToastMixin {
  @override
  void initState() {
    super.initState();
    initToast(context);
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AuthViewModel>(context);
    return ButtonWidget(
      isEnabled: viewModel.isButtonEnabled,
      text: viewModel.isLogin ? "LOGIN" : "SIGN UP",
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        if (!widget.isConnected) {
          _showConnectivityMessage();
          return;
        }
        var result = await viewModel.auth();
        widget.formKey.currentState!.validate();
        if (result.isSuccess && context.mounted) {
          viewModel.isLogin ? NavigationUtil.navigateToOperationScreen(context) : NavigationUtil.navigateToLoginScreen(context);
        } else {
          showToast(
            child: BottomWidget(title: result.errorMessage ?? "Error", iconColor: AppColors.error, iconData: MdiIcons.alert),
          );
        }
      },
    );
  }

  void _showConnectivityMessage() {
    showToast(
      child: BottomWidget(title: "No Internet Connection!", iconColor: AppColors.error, iconData: MdiIcons.alert),
    );
  }
}
