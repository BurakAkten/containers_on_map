import 'package:containers/utils/mixins/toast_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../base/constants/app_constants.dart';
import '../../core_widgets/bottom_widget.dart';
import '../../core_widgets/button_widget.dart';
import '../viewmodels/containers_viewmodel.dart';

class ContainerRelocateWidget extends StatefulWidget {
  const ContainerRelocateWidget({super.key});

  @override
  State<ContainerRelocateWidget> createState() => _ContainerRelocateWidgetState();
}

class _ContainerRelocateWidgetState extends State<ContainerRelocateWidget> with ToastMixin {
  @override
  void initState() {
    super.initState();
    initToast(context);
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ContainersViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Please select a location from the map for your bin to be relocated. You can select a location by tapping on the map.",
          style: AppFontUtils.t1,
        ),
        const SizedBox(height: AppSpacing.spacingMedium),
        ButtonWidget(
          text: "Save",
          onPressed: () async {
            await viewModel.changeSelectedContainerLocation();
            showToast(child: const BottomWidget.withChild(child: Text("Your bin has been relocated successfully!")));
          },
        ),
      ],
    );
  }
}
