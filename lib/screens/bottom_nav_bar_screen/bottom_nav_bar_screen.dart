import 'package:example_project/generated/l10n.dart';
import 'package:example_project/screens/characters_screen/characters_screen.dart';
import 'package:example_project/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/bottom_nav_bar_cubit.dart';

class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({Key? key}) : super(key: key);

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBarCubit(),
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          if (state is BottomNavBarInitial) {
            return Scaffold(
              body: IndexedStack(
                index: state.index,
                children: [
                  Navigator(
                    key: navigatorKeys[0],
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (BuildContext context) =>
                          const CharactersScreen(),
                    ),
                  ),
                  Navigator(
                    key: navigatorKeys[1],
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (BuildContext context) => const ProfileScreen(),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  context.read<BottomNavBarCubit>().changeCurrentPage(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.list,
                      ),
                      label: S.of(context).characters),
                  BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.people,
                      ),
                      label: S.of(context).profile),
                ],
                currentIndex: state.index,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
