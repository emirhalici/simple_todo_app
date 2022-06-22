import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkConnection {
  on,
  off,
}

abstract class INetworkChangeManager {
  Future<NetworkConnection> checkNetworkInitially();
  void handleNetworkChange(void Function(NetworkConnection result) onChange);
  void dispose();
}

class NetworkChangeManager extends INetworkChangeManager {
  late final Connectivity _connectivity;
  late final StreamSubscription<ConnectivityResult>? _subscription;

  NetworkChangeManager() {
    _connectivity = Connectivity();
  }

  @override
  Future<NetworkConnection> checkNetworkInitially() async {
    final connResult = await Connectivity().checkConnectivity();
    if (connResult == ConnectivityResult.none) return NetworkConnection.off;
    return NetworkConnection.on;
  }

  @override
  void handleNetworkChange(void Function(NetworkConnection result) onChange) {
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      onChange.call(event == ConnectivityResult.none ? NetworkConnection.off : NetworkConnection.on);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
  }
}
