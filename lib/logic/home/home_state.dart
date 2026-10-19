import 'package:equatable/equatable.dart';

import '../../data/models/doctor.dart';
import '../../data/models/home_data.dart';

// Stările principale ale ecranului
enum HomeStatus { initial, loading, success, empty, error }

// Opțiunile de sortare pentru lista de doctori
enum DoctorSort {
  none('Default'),
  nameAsc('Name A-Z'),
  nameDesc('Name Z-A'),
  distance('Nearest first');

  final String label;
  const DoctorSort(this.label);
}

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeData? data;
  final List<Doctor> doctors;
  final String query;
  final String? specialty;
  final bool favoritesOnly;
  final DoctorSort sort;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.doctors = const [],
    this.query = '',
    this.specialty,
    this.favoritesOnly = false,
    this.sort = DoctorSort.none,
    this.errorMessage,
  });

  // Specialitățile distincte, folosite pentru chip-urile de filtrare
  List<String> get specialties =>
      doctors.map((d) => d.specialty).toSet().toList()..sort();

  int get favoritesCount => doctors.where((d) => d.isFavorite).length;

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      specialty != null ||
      favoritesOnly ||
      sort != DoctorSort.none;

  // Lista finală afișată: căutare -> filtrare -> sortare
  List<Doctor> get visibleDoctors {
    final q = query.trim().toLowerCase();
    final result = doctors.where((d) {
      final matchesQuery =
          q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.specialty.toLowerCase().contains(q) ||
          d.distance.toLowerCase().contains(q);
      final matchesSpecialty = specialty == null || d.specialty == specialty;
      final matchesFavorite = !favoritesOnly || d.isFavorite;
      return matchesQuery && matchesSpecialty && matchesFavorite;
    }).toList();

    switch (sort) {
      case DoctorSort.none:
        break;
      case DoctorSort.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
      case DoctorSort.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
      case DoctorSort.distance:
        result.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));
    }
    return result;
  }

  HomeState copyWith({
    HomeStatus? status,
    HomeData? data,
    List<Doctor>? doctors,
    String? query,
    String? Function()? specialty,
    bool? favoritesOnly,
    DoctorSort? sort,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      doctors: doctors ?? this.doctors,
      query: query ?? this.query,
      specialty: specialty != null ? specialty() : this.specialty,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      sort: sort ?? this.sort,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    data,
    doctors,
    query,
    specialty,
    favoritesOnly,
    sort,
    errorMessage,
  ];
}
