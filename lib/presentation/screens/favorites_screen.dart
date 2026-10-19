import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';
import '../widgets/doctor_tile.dart';
import '../widgets/state_views.dart';
import 'home_screen.dart';

// Ecranul cu doctorii adăugați la favorite
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final favorites = state.doctors.where((d) => d.isFavorite).toList();
          if (favorites.isEmpty) {
            return const EmptyView(
              title: 'No favorites yet',
              message: 'Tap the heart next to a doctor to add them here.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: favorites.length,
            itemBuilder: (context, i) => DoctorTile(
              doctor: favorites[i],
              onTap: () => openDoctorDetails(context, favorites[i]),
              onFavoriteToggle: () =>
                  context.read<HomeCubit>().toggleFavorite(favorites[i].id),
            ),
          );
        },
      ),
    );
  }
}
