import 'package:containers/base/constants/app_constants.dart';
import 'package:containers/screens/login/auth_service.dart';
import 'package:containers/screens/login/viewmodels/auth_viewmodel.dart';
import 'package:containers/screens/login/views/form_view.dart';
import 'package:containers/screens/login/widgets/auth_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/connectivity_util.dart';
import '../../utils/mixins/toast_mixin.dart';
import '../core_widgets/bottom_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> with ToastMixin {
  final _formKey = GlobalKey<FormState>();
  late ConnectivityUtil connectivity;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

    initToast(context);

    connectivity = ConnectivityUtil()..init();
    connectivity.connectivity$.listen((isConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _isConnected = isConnected);
        if (!isConnected) _showConnectivityMessage();
      });
    });
  }

  void _showConnectivityMessage() {
    showToast(
      child: BottomWidget(title: "No Internet Connection!", iconColor: AppColors.error, iconData: MdiIcons.alert),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AuthViewModel>(
        create: (_) => AuthViewModel(service: AuthService()),
        child: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) => _buildScreen(context, viewModel),
        ),
      ),
    );
  }

  Widget _buildScreen(BuildContext context, AuthViewModel viewModel) => Stack(
        children: [
          IgnorePointer(
            ignoring: viewModel.isLoading,
            child: Container(
              decoration: AppDecorations.gradientBox,
              padding: const EdgeInsets.all(AppSpacing.spacingLarge),
              child: Column(
                children: [
                  Expanded(flex: 2, child: Image.asset("assets/images/logo.png")),
                  Expanded(flex: 3, child: FormView(formKey: _formKey)),
                  AuthButtonWidget(formKey: _formKey, isConnected: _isConnected),
                  const SizedBox(height: AppSpacing.spacingSmall),
                  InkWell(
                    onTap: () => viewModel.changeAuthType(),
                    child: Text(viewModel.isLogin ? "Create Account" : "Login", style: AppFontUtils.filledInputLabel),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: viewModel.isLoading,
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        ],
      );

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }
}
