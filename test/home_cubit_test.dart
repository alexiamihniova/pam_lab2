import 'package:flutter_test/flutter_test.dart';
import 'package:pam_lab2/logic/home/home_cubit.dart';
import 'package:pam_lab2/logic/home/home_state.dart';

import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HomeCubit cubit;

  setUp(() async {
    cubit = HomeCubit(testRepository());
    await cubit.loadData();
  });

  tearDown(() => cubit.close());

  test('loads data from lab v2.json -> Success', () {
    expect(cubit.state.status, HomeStatus.success);
    expect(cubit.state.data!.user.name, 'Jonathan');
    expect(cubit.state.doctors.length, 2);
    expect(cubit.state.data!.healthServices.length, 4);
  });

  test('search filters by name and goes Empty when nothing matches', () {
    cubit.search('sonja');
    expect(cubit.state.visibleDoctors.single.id, 'doctor-002');
    cubit.search('xyz');
    expect(cubit.state.status, HomeStatus.empty);
    cubit.clearFilters();
    expect(cubit.state.status, HomeStatus.success);
  });

  test('filter by specialty and toggle off', () {
    cubit.filterBySpecialty('Dental Specialist');
    expect(cubit.state.visibleDoctors.single.name, 'Dr. Sonja Litel');
    cubit.filterBySpecialty('Dental Specialist');
    expect(cubit.state.visibleDoctors.length, 2);
  });

  test('sort by name and distance', () {
    cubit.sortBy(DoctorSort.nameDesc);
    expect(cubit.state.visibleDoctors.first.id, 'doctor-002');
    cubit.sortBy(DoctorSort.distance);
    expect(cubit.state.visibleDoctors.first.distanceInMeters, 500);
  });

  test('favorites toggle and favorites-only filter', () {
    cubit.toggleFavoritesOnly();
    expect(cubit.state.status, HomeStatus.empty);
    cubit.toggleFavorite('doctor-001');
    expect(cubit.state.status, HomeStatus.success);
    expect(cubit.state.visibleDoctors.single.id, 'doctor-001');
    expect(cubit.state.favoritesCount, 1);
  });

  test('invalid JSON -> Error', () async {
    final bad = HomeCubit(testRepository(content: '{not json'));
    await bad.loadData();
    expect(bad.state.status, HomeStatus.error);
    await bad.close();
  });
}
