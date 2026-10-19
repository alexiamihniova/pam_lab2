import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/medical_repository.dart';
import 'home_state.dart';

// Cubit-ul ecranului principal: încărcare, căutare, filtrare, sortare, favorite
class HomeCubit extends Cubit<HomeState> {
  final MedicalRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> loadData({bool forceRefresh = false}) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final data = await _repository.loadData(forceRefresh: forceRefresh);
      final next = state.copyWith(
        data: data.home,
        doctors: data.home.nearbyDoctors,
      );
      emit(next.copyWith(status: _statusFor(next)));
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void search(String query) => _update(state.copyWith(query: query));

  void filterBySpecialty(String? specialty) {
    // Apăsarea pe chip-ul deja selectat scoate filtrul
    final next = specialty == state.specialty ? null : specialty;
    _update(state.copyWith(specialty: () => next));
  }

  void toggleFavoritesOnly() =>
      _update(state.copyWith(favoritesOnly: !state.favoritesOnly));

  void sortBy(DoctorSort sort) => _update(state.copyWith(sort: sort));

  void toggleFavorite(String doctorId) {
    final doctors = state.doctors
        .map(
          (d) => d.id == doctorId ? d.copyWith(isFavorite: !d.isFavorite) : d,
        )
        .toList();
    _update(state.copyWith(doctors: doctors));
  }

  void clearFilters() {
    _update(
      state.copyWith(
        query: '',
        specialty: () => null,
        favoritesOnly: false,
        sort: DoctorSort.none,
      ),
    );
  }

  // Recalculează starea Success/Empty după orice modificare a listei
  void _update(HomeState next) {
    if (state.status == HomeStatus.loading ||
        state.status == HomeStatus.error) {
      emit(next);
      return;
    }
    emit(next.copyWith(status: _statusFor(next)));
  }

  HomeStatus _statusFor(HomeState s) =>
      s.visibleDoctors.isEmpty ? HomeStatus.empty : HomeStatus.success;
}
