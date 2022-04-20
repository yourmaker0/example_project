import 'package:example_project/core/error_handler/error_handler.dart';
import 'package:example_project/data/network/models/response/dto_characters_response.dart';
import 'package:example_project/data/repositories/global_repository.dart';
import 'package:example_project/generated/l10n.dart';
import 'package:example_project/styles/color_palette.dart';
import 'package:example_project/styles/text_styles.dart';
import 'package:example_project/widgets/loading_indicator/loading_indicator.dart';
import 'package:example_project/widgets/pagingation_wrapper/pagination_wrapper.dart';
import 'package:example_project/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/characters_bloc.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharactersBloc(context.read<GlobalRepository>())
        ..add(InitialCharactersEvent()),
      child: BlocConsumer<CharactersBloc, CharactersState>(
        listener: (context, state) {
          if (state is ErrorCharactersState) {
            showCustomSnackbar(
                context, context.read<ErrorHandler>().handleError(state));
          }
        },
        buildWhen: (p, c) =>
            (c is DataCharactersState || c is LoadingCharactersState),
        builder: (context, state) {
          if (state is LoadingCharactersState) {
            return const LoadingIndicator();
          }
          if (state is DataCharactersState) {
            return Scaffold(
              body: SafeArea(
                child: PaginationWrapper<CharactersBloc, CharactersState,
                    LoadingNextPageCharactersState>(
                  loadNextPageEvent: () => context
                      .read<CharactersBloc>()
                      .add(LoadNextPageCharactersEvent()),
                  child: ListView.builder(
                    itemCount: state.characters.length,
                    itemBuilder: (context, index) {
                      return _BuildCharacter(
                          character: state.characters.elementAt(index));
                    },
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _BuildCharacter extends StatelessWidget {
  const _BuildCharacter({Key? key, required this.character}) : super(key: key);
  final DTOCharacter character;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: ColorPalette.white,
            foregroundImage: Image.network(character.image).image,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).name}: ${character.name}',
                  style: ProjectTextStyles.ui_16Medium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${S.of(context).location}: ${character.location}",
                  style: ProjectTextStyles.ui_16Regular,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
