import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';
import 'selectable_chip.dart';

// Rând orizontal cu chip-uri de filtrare: favorite + specialități
class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (a, b) =>
          a.specialty != b.specialty ||
          a.favoritesOnly != b.favoritesOnly ||
          a.doctors != b.doctors,
      builder: (context, state) {
        const chipPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 9);
        return SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SelectableChip(
                label: 'All',
                selected: state.specialty == null && !state.favoritesOnly,
                padding: chipPadding,
                onTap: () {
                  if (state.favoritesOnly) cubit.toggleFavoritesOnly();
                  if (state.specialty != null) cubit.filterBySpecialty(null);
                },
              ),
              const SizedBox(width: 8),
              SelectableChip(
                label: 'Favorites (${state.favoritesCount})',
                icon: Icons.favorite,
                selected: state.favoritesOnly,
                padding: chipPadding,
                onTap: cubit.toggleFavoritesOnly,
              ),
              for (final specialty in state.specialties) ...[
                const SizedBox(width: 8),
                SelectableChip(
                  label: specialty,
                  selected: state.specialty == specialty,
                  padding: chipPadding,
                  onTap: () => cubit.filterBySpecialty(specialty),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
