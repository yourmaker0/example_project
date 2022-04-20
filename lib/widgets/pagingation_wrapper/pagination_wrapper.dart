import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaginationWrapper<Bloc extends BlocBase<BlocState>, BlocState,
    LoadingState> extends StatelessWidget {
  final Widget child;
  final Function loadNextPageEvent;
  final EdgeInsetsGeometry progressIndicatorPadding;
  final ValueNotifier<bool> isBottomReached = ValueNotifier(false);

  PaginationWrapper({
    Key? key,
    required this.loadNextPageEvent,
    this.progressIndicatorPadding = EdgeInsets.zero,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            final current = scrollInfo.metrics.pixels;
            final max = scrollInfo.metrics.maxScrollExtent;
            isBottomReached.value = (current >= max - 100);

            if (context.read<Bloc>().state is! LoadingState &&
                current >= max - 600) {
              loadNextPageEvent.call();
            }

            return false;
          },
          child: child,
        ),
        BlocBuilder<Bloc, BlocState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return ValueListenableBuilder(
                  valueListenable: isBottomReached,
                  builder: (context, hasError, child) {
                    return isBottomReached.value
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: progressIndicatorPadding,
                              child: const SizedBox(
                                height: 50,
                                child: Center(
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  });
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
