import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';
import 'selectable_chip.dart';

// Deschide bottom sheet-ul cu sortare și filtre, legat la HomeCubit existent
Future<void> showFilterSheet(BuildContext context) {
  final cubit = context.read<HomeCubit>();
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) =>
        BlocProvider.value(value: cubit, child: const FilterSheet()),
  );
}

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sort & Filter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: state.hasActiveFilters
                          ? cubit.clearFilters
                          : null,
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sort by',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final sort in DoctorSort.values)
                      SelectableChip(
                        label: sort.label,
                        selected: state.sort == sort,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        onTap: () => cubit.sortBy(sort),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Specialty',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final specialty in state.specialties)
                      SelectableChip(
                        label: specialty,
                        selected: state.specialty == specialty,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        onTap: () => cubit.filterBySpecialty(specialty),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: AppColors.primary,
                  title: const Text('Show only favorites'),
                  value: state.favoritesOnly,
                  onChanged: (_) => cubit.toggleFavoritesOnly(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
