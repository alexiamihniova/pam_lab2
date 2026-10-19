import 'package:equatable/equatable.dart';

import '../../data/models/appointment_details.dart';

enum BookingStatus { loading, success, error }

// Starea trimiterii programării (butonul "Book an Appointment")
enum SubmitStatus { idle, submitting, done, failed }

class BookingState extends Equatable {
  final BookingStatus status;
  final AppointmentDetails? details;
  final String? selectedHourId;
  final String? selectedDateId;
  final SubmitStatus submitStatus;
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.loading,
    this.details,
    this.selectedHourId,
    this.selectedDateId,
    this.submitStatus = SubmitStatus.idle,
    this.errorMessage,
  });

  String? get selectedHourLabel =>
      _labelFor(details?.workingHours.slots, selectedHourId);
  String? get selectedDateLabel =>
      _labelFor(details?.date.slots, selectedDateId);

  bool get canBook =>
      details != null &&
      details!.bookEnabled &&
      selectedHourId != null &&
      selectedDateId != null &&
      submitStatus != SubmitStatus.submitting;

  static String? _labelFor(List<Slot>? slots, String? id) {
    if (slots == null || id == null) return null;
    for (final s in slots) {
      if (s.id == id) return s.label;
    }
    return null;
  }

  BookingState copyWith({
    BookingStatus? status,
    AppointmentDetails? details,
    String? selectedHourId,
    String? selectedDateId,
    SubmitStatus? submitStatus,
    String? errorMessage,
  }) {
    return BookingState(
      status: status ?? this.status,
      details: details ?? this.details,
      selectedHourId: selectedHourId ?? this.selectedHourId,
      selectedDateId: selectedDateId ?? this.selectedDateId,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    details,
    selectedHourId,
    selectedDateId,
    submitStatus,
    errorMessage,
  ];
}
