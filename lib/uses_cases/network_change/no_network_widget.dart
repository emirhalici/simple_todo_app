import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_app/uses_cases/network_change/network_change_manager.dart';

class NoNetworkWidget extends StatefulWidget {
  const NoNetworkWidget({Key? key}) : super(key: key);

  @override
  State<NoNetworkWidget> createState() => _NoNetworkWidgetState();
}

class _NoNetworkWidgetState extends State<NoNetworkWidget> {
  late final INetworkChangeManager _networkChangeManager;

  NetworkConnection? _networkConnection;

  @override
  void initState() {
    super.initState();
    _networkChangeManager = NetworkChangeManager();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _networkChangeManager.handleNetworkChange((result) {
        _updateView(result);
      });
    });
  }

  void _updateView(NetworkConnection result) {
    setState(() {
      _networkConnection = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Container(
        height: 50.h,
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Center(
          child: Text(
            'No network detected.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ),
      secondChild: const SizedBox(),
      crossFadeState: _networkConnection == NetworkConnection.off ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
    );
  }
}
