import 'package:containers/screens/login/viewmodels/login_viewmodel.dart';
import 'package:containers/utils/mixins/toast_mixin.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../base/constants/app_constants.dart';
import '../../../utils/navigation_util.dart';
import '../../core_widgets/bottom_widget.dart';
import '../../core_widgets/button_widget.dart';

class LoginButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isConnected;
  const LoginButtonWidget({super.key, required this.formKey, required this.isConnected});

  @override
  State<LoginButtonWidget> createState() => _LoginButtonWidgetState();
}

class _LoginButtonWidgetState extends State<LoginButtonWidget> with ToastMixin {
  @override
  void initState() {
    super.initState();
    initToast(context);
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<LoginViewModel>(context);
    return ButtonWidget(
      isEnabled: viewModel.isButtonEnabled,
      text: "LOGIN",
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        if (!widget.isConnected) {
          _showConnectivityMessage();
          return;
        }
        var result = await viewModel.login();
        widget.formKey.currentState!.validate();
        if (result.isSuccess && context.mounted) {
          NavigationUtil.navigateToOperationScreen(context);
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
