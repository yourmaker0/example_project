import 'package:flutter/material.dart';

class DependenciesInitializer<T extends Object> extends StatefulWidget {
  final Widget loadingIndicatorScreen;

  final Future<void> Function(BuildContext) initializer;

  final Widget child;

  const DependenciesInitializer({
    Key? key,
    required this.loadingIndicatorScreen,
    required this.initializer,
    required this.child,
  }) : super(key: key);

  @override
  _DependenciesInitializerState<T> createState() =>
      _DependenciesInitializerState<T>();
}

class _DependenciesInitializerState<T extends Object>
    extends State<DependenciesInitializer<T>> {
  late final Future _future;

  @override
  void initState() {
    _future = widget.initializer(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.child;
        } else {
          return widget.loadingIndicatorScreen;
        }
      },
    );
  }
}
