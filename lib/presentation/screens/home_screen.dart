import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../data/models/appointment_details.dart';
import '../../data/models/doctor.dart';
import '../../data/models/home_data.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';
import '../widgets/app_avatar.dart';
import '../widgets/appointment_card.dart';
import '../widgets/doctor_tile.dart';
import '../widgets/filter_bar.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/health_service_item.dart';
import '../widgets/section_header.dart';
import '../widgets/search_field.dart';
import '../widgets/state_views.dart';
import 'appointment_details_screen.dart';
import 'favorites_screen.dart';

// =========================================================================
// ECRAN 1: HOMESCREEN
// =========================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case HomeStatus.initial:
              case HomeStatus.loading:
                return const LoadingView(message: 'Loading your data...');
              case HomeStatus.error:
                return ErrorView(
                  message: state.errorMessage ?? 'Unknown error',
                  onRetry: () =>
                      context.read<HomeCubit>().loadData(forceRefresh: true),
                );
              case HomeStatus.success:
              case HomeStatus.empty:
                return _HomeContent(state: state);
            }
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeState state;
  const _HomeContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final data = state.data!;
    final doctors = state.visibleDoctors;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => cubit.loadData(forceRefresh: true),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            sliver: SliverList.list(
              children: [
                _Header(
                  user: data.user,
                  hasUnread: data.hasUnreadNotifications,
                  favoritesCount: state.favoritesCount,
                ),
                const SizedBox(height: 20),
                SearchField(
                  hint: data.searchHint,
                  initialValue: state.query,
                  filtersActive: state.hasActiveFilters,
                  onChanged: cubit.search,
                  onFilterTap: () => showFilterSheet(context),
                ),
                const SizedBox(height: 20),
                AppointmentCard(
                  appointment: data.appointment,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentDetailsScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Health Services'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final service in data.healthServices)
                      HealthServiceItem(service: service),
                  ],
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Nearby Doctor',
                  actionLabel: state.hasActiveFilters ? 'Clear filters' : '',
                  onAction: state.hasActiveFilters ? cubit.clearFilters : null,
                ),
                const SizedBox(height: 12),
                const FilterBar(),
                const SizedBox(height: 8),
              ],
            ),
          ),
          // Stare: Empty pentru lista de doctori
          if (state.status == HomeStatus.empty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyView(
                title: state.doctors.isEmpty
                    ? 'No doctors available'
                    : 'No doctors found',
                message: state.doctors.isEmpty
                    ? 'There are no doctors near you yet.'
                    : 'Try changing your search or filters.',
                actionLabel: state.doctors.isEmpty ? null : 'Clear filters',
                onAction: state.doctors.isEmpty ? null : cubit.clearFilters,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList.builder(
                itemCount: doctors.length,
                itemBuilder: (context, i) => DoctorTile(
                  doctor: doctors[i],
                  onTap: () => openDoctorDetails(context, doctors[i]),
                  onFavoriteToggle: () => cubit.toggleFavorite(doctors[i].id),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Navigare către pagina de detalii a unui doctor
void openDoctorDetails(BuildContext context, Doctor doctor) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AppointmentDetailsScreen(
        doctorId: doctor.id,
        doctor: DetailsDoctor(
          name: doctor.name,
          clinic: doctor.specialty,
          avatarUrl: doctor.avatarUrl,
        ),
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  final AppUser user;
  final bool hasUnread;
  final int favoritesCount;

  const _Header({
    required this.user,
    required this.hasUnread,
    required this.favoritesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatar(url: user.avatarUrl, name: user.name),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.greeting,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.subtitle,
                style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        _HeaderButton(
          icon: Icons.favorite_border,
          badge: favoritesCount > 0 ? '$favoritesCount' : null,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritesScreen()),
          ),
        ),
        const SizedBox(width: 8),
        _HeaderButton(
          icon: Icons.notifications_none,
          dot: hasUnread,
          onTap: () {},
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool dot;
  final String? badge;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
    this.dot = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Badge(
          isLabelVisible: dot || badge != null,
          smallSize: 9,
          label: badge != null ? Text(badge!) : null,
          backgroundColor: badge != null ? AppColors.primary : Colors.red,
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}
