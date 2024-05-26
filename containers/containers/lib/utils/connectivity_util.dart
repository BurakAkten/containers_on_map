import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtil {
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  Stream<bool> get connectivity$ => _connectivityController.stream;

  late StreamSubscription<List<ConnectivityResult>> subscription;

  Future<void> init() async {
    subscription = Connectivity().onConnectivityChanged.listen((result) => _checkConnectivity(result));
  }

  bool _checkConnectivity(List<ConnectivityResult> result) {
    if (result.length == 1 && result.contains(ConnectivityResult.none)) {
      _connectivityController.add(false);
      return false;
    } else if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
      _connectivityController.add(true);
      return true;
    }
    return false;
  }

  dispose() {
    subscription.cancel();
  }
}
