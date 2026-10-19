import 'package:equatable/equatable.dart';

// Modelul unui doctor din lista "Nearby Doctor"
class Doctor extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String distance;
  final String avatarUrl;
  final bool isFavorite;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.avatarUrl,
    this.isFavorite = false,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      distance: json['distance'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  // Extrage distanța în metri din text (ex: "... - 500M from you" -> 500)
  int get distanceInMeters {
    final match = RegExp(r'(\d+)\s*M\b').firstMatch(distance);
    return match != null ? int.parse(match.group(1)!) : 1 << 30;
  }

  // Adresa fără partea cu distanța (ex: "3167 Durgan Shores")
  String get address => distance.split(' - ').first;

  Doctor copyWith({bool? isFavorite}) {
    return Doctor(
      id: id,
      name: name,
      specialty: specialty,
      distance: distance,
      avatarUrl: avatarUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    distance,
    avatarUrl,
    isFavorite,
  ];
}
