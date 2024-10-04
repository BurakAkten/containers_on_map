import 'package:containers/base/constants/app_constants.dart';
import 'package:containers/screens/core_widgets/bottom_widget.dart';
import 'package:containers/screens/operation/viewmodels/containers_viewmodel.dart';
import 'package:containers/screens/operation/widgets/container_information_widget.dart';
import 'package:containers/screens/operation/widgets/container_relocate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContainersScreen extends StatelessWidget {
  const ContainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseView<ContainersViewModel>(
      vmBuilder: (_) => ContainersViewModel(),
      builder: _buildScreen,
    ));
  }

  Widget _buildScreen(BuildContext context, ContainersViewModel viewModel) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(target: viewModel.initialPosition, zoom: viewModel.defaultZoomLevel),
              onMapCreated: (GoogleMapController controller) async {
                if (!viewModel.controller.isCompleted) {
                  viewModel.controller.complete(controller);
                }
              },
              markers: viewModel.routeMarkers,
              onTap: (LatLng covariant) {
                viewModel.onMapTap(covariant);
              },
              onCameraIdle: () async => await viewModel.onCameraPositionChange(),
              onCameraMove: (_) async => await viewModel.onCameraPositionChange(),
            ),
            if (viewModel.selectedContainer != null || viewModel.isRelocating)
              Positioned(
                bottom: AppSpacing.spacingXLarge,
                left: AppSpacing.spacingSmall,
                right: AppSpacing.spacingSmall,
                child: BottomWidget.withChild(
                  child: viewModel.isRelocating ? const ContainerRelocateWidget() : const ContainerInformationWidget(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
