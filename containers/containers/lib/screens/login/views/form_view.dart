import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../base/constants/app_constants.dart';
import '../../core_widgets/text_field_widget.dart';
import '../viewmodels/login_viewmodel.dart';

class FormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const FormView({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<LoginViewModel>(context);
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text("Please enter your user name and password.", style: AppFontUtils.t2),
            const SizedBox(height: AppSpacing.spacingLarge),
            TextFieldWidget(
              controller: viewModel.usernameController,
              labelText: "Username",
              keyboardType: TextInputType.text,
              onChanged: (text) => viewModel.userName = text,
              suffixIcon: viewModel.userName.isNotEmpty ? _buildUsernameSuffixIcon(viewModel) : null,
              validator: (value) => viewModel.isUserValidated ? null : "",
            ),
            const SizedBox(height: AppSpacing.spacingLarge),
            TextFieldWidget(
              labelText: "Password",
              controller: viewModel.passwordController,
              onChanged: (text) => viewModel.password = text,
              obscureText: viewModel.isPasswordVisible,
              suffixIcon: viewModel.password.isNotEmpty
                  ? _buildEyeIcon(value: viewModel.isPasswordVisible, onChange: viewModel.changePasswordVisibility)
                  : null,
            ),
            const SizedBox(height: AppSpacing.spacingLarge),
          ],
        ),
      ),
    );
  }

  InkWell _buildUsernameSuffixIcon(LoginViewModel viewModel) => InkWell(
        onTap: () {
          if (viewModel.isUserValidated) {
            viewModel.usernameController.text = "";
            viewModel.userName = "";
          }
        },
        child: Icon(
          viewModel.isUserValidated ? MdiIcons.closeCircle : MdiIcons.alert,
          color: viewModel.isUserValidated ? AppColors.shadowColor : AppColors.error,
          size: AppIconSize.small,
        ),
      );

  Widget _buildEyeIcon({bool? value, Function()? onChange}) => InkWell(
        onTap: onChange,
        child: Icon(
          MdiIcons.eye,
          size: AppIconSize.small,
          color: !value! ? AppColors.yellow : AppColors.shadowColor,
        ),
      );
}
