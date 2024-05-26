import 'package:containers/screens/operation/viewmodels/containers_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../base/constants/app_constants.dart';
import '../../core_widgets/button_widget.dart';

class ContainerInformationWidget extends StatelessWidget {
  const ContainerInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ContainersViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Container ${viewModel.selectedContainer!.id!}", style: AppFontUtils.h3),
        const SizedBox(height: AppSpacing.spacingXxSmall),
        Text("Next Collection", style: AppFontUtils.h4),
        Text(viewModel.selectedContainer!.nextCollectionDate!, style: AppFontUtils.t1),
        const SizedBox(height: AppSpacing.spacingXxSmall),
        Text("Fullness Rate", style: AppFontUtils.h4),
        Text("%${viewModel.selectedContainer!.fullnessRate!}", style: AppFontUtils.t1),
        Row(
          children: [
            Expanded(
              child: ButtonWidget(
                text: "NAVIGATE",
                onPressed: () async => await viewModel.navigateToSelected(),
              ),
            ),
            const SizedBox(width: AppSpacing.spacingMedium),
            Expanded(
              child: ButtonWidget(
                text: "RELOCATE",
                onPressed: () async => await viewModel.relocateSelected(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
