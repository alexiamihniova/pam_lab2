import 'package:equatable/equatable.dart';

import 'doctor.dart';

// Datele utilizatorului afișate în antetul ecranului principal
class AppUser extends Equatable {
  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  const AppUser({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String,
      greeting: json['greeting'] as String? ?? 'Hi, ${json['name']}',
      subtitle: json['subtitle'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [name, greeting, subtitle, avatarUrl];
}

// Doctorul din cardul de programare
class AppointmentDoctor extends Equatable {
  final String name;
  final String specialty;
  final String avatarUrl;

  const AppointmentDoctor({
    required this.name,
    required this.specialty,
    required this.avatarUrl,
  });

  factory AppointmentDoctor.fromJson(Map<String, dynamic> json) {
    return AppointmentDoctor(
      name: json['name'] as String,
      specialty: json['specialty'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [name, specialty, avatarUrl];
}

// Cardul "Appointment" de pe ecranul principal
class Appointment extends Equatable {
  final String title;
  final String date;
  final String time;
  final AppointmentDoctor doctor;

  const Appointment({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      title: json['title'] as String? ?? 'Appointment',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      doctor: AppointmentDoctor.fromJson(
        json['doctor'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  List<Object?> get props => [title, date, time, doctor];
}

// Un serviciu medical (Tooth, Eye, Lungs, Ear)
class HealthService extends Equatable {
  final String id;
  final String name;
  final String iconUrl;

  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory HealthService.fromJson(Map<String, dynamic> json) {
    return HealthService(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String? ?? '',
    );
  }

  // Iconițele sunt SVG pe server, deci folosim varianta PNG din assets
  String get localIconPath => 'assets/images/icon_$id.png';

  @override
  List<Object?> get props => [id, name, iconUrl];
}

// Toate datele ecranului principal ("homeScreen" din JSON)
class HomeData extends Equatable {
  final AppUser user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final Appointment appointment;
  final List<HealthService> healthServices;
  final List<Doctor> nearbyDoctors;

  const HomeData({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      hasUnreadNotifications:
          (json['notifications'] as Map<String, dynamic>?)?['hasUnread']
              as bool? ??
          false,
      searchHint:
          (json['search'] as Map<String, dynamic>?)?['hint'] as String? ??
          'Search something',
      appointment: Appointment.fromJson(
        json['appointment'] as Map<String, dynamic>,
      ),
      healthServices: (json['healthServices'] as List<dynamic>? ?? [])
          .map((e) => HealthService.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearbyDoctors: (json['nearbyDoctors'] as List<dynamic>? ?? [])
          .map((e) => Doctor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
    user,
    hasUnreadNotifications,
    searchHint,
    appointment,
    healthServices,
    nearbyDoctors,
  ];
}
