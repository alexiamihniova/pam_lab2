import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/appointment_details.dart';
import '../models/home_data.dart';

// Rezultatul complet al parsării fișierului JSON
class MedicalData {
  final HomeData home;
  final AppointmentDetails appointmentDetails;

  const MedicalData({required this.home, required this.appointmentDetails});
}

// Funcție top-level ca să poată rula într-un isolate separat (compute)
MedicalData _parseMedicalData(String raw) {
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return MedicalData(
    home: HomeData.fromJson(json['homeScreen'] as Map<String, dynamic>),
    appointmentDetails: AppointmentDetails.fromJson(
      json['appointmentDetails'] as Map<String, dynamic>,
    ),
  );
}

// Repository-ul se ocupă de încărcarea asincronă a datelor din JSON
class MedicalRepository {
  static const String dataPath = 'lab v2.json';

  final AssetBundle _bundle;
  final Duration _delay;

  MedicalRepository({AssetBundle? bundle, Duration? delay})
    : _bundle = bundle ?? rootBundle,
      _delay = delay ?? const Duration(milliseconds: 800);

  MedicalData? _cache;

  // Încarcă și parsează datele; rezultatul e păstrat în cache
  Future<MedicalData> loadData({bool forceRefresh = false}) async {
    if (_cache != null && !forceRefresh) return _cache!;

    // Întârziere artificială ca să se vadă starea de Loading
    await Future<void>.delayed(_delay);

    try {
      final raw = await _bundle.loadString(dataPath, cache: false);
      _cache = await compute(_parseMedicalData, raw);
      return _cache!;
    } catch (e) {
      throw MedicalDataException('Nu s-au putut încărca datele: $e');
    }
  }

  // Simulează trimiterea unei programări către server
  Future<void> bookAppointment({
    required String doctorName,
    required String dateId,
    required String hourId,
  }) async {
    await Future<void>.delayed(_delay);
  }
}

class MedicalDataException implements Exception {
  final String message;
  const MedicalDataException(this.message);

  @override
  String toString() => message;
}
