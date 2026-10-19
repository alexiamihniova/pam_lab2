import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/appointment_details.dart';
import '../../data/repositories/medical_repository.dart';
import 'booking_state.dart';

// Cubit-ul ecranului de detalii: alegerea orei/zilei și trimiterea programării
class BookingCubit extends Cubit<BookingState> {
  final MedicalRepository _repository;

  // Dacă e setat, detaliile se afișează pentru acest doctor (din "Nearby")
  final DetailsDoctor? doctorOverride;

  BookingCubit(this._repository, {this.doctorOverride})
    : super(const BookingState());

  Future<void> load() async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final data = await _repository.loadData();
      var details = data.appointmentDetails;
      if (doctorOverride != null) details = details.withDoctor(doctorOverride!);
      emit(
        state.copyWith(
          status: BookingStatus.success,
          details: details,
          selectedHourId: details.workingHours.initialSelectedId,
          selectedDateId: details.date.initialSelectedId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: BookingStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void selectHour(String id) =>
      emit(state.copyWith(selectedHourId: id, submitStatus: SubmitStatus.idle));

  void selectDate(String id) =>
      emit(state.copyWith(selectedDateId: id, submitStatus: SubmitStatus.idle));

  Future<void> book() async {
    if (!state.canBook) return;
    emit(state.copyWith(submitStatus: SubmitStatus.submitting));
    try {
      await _repository.bookAppointment(
        doctorName: state.details!.doctor.name,
        dateId: state.selectedDateId!,
        hourId: state.selectedHourId!,
      );
      emit(state.copyWith(submitStatus: SubmitStatus.done));
    } catch (e) {
      emit(
        state.copyWith(
          submitStatus: SubmitStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
