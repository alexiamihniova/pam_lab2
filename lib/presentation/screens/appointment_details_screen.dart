import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../data/models/appointment_details.dart';
import '../../data/repositories/medical_repository.dart';
import '../../logic/booking/booking_cubit.dart';
import '../../logic/booking/booking_state.dart';
import '../../logic/home/home_cubit.dart';
import '../widgets/app_avatar.dart';
import '../widgets/favorite_button.dart';
import '../widgets/primary_button.dart';
import '../widgets/round_icon.dart';
import '../widgets/section_header.dart';
import '../widgets/selectable_chip.dart';
import '../widgets/state_views.dart';

// =========================================================================
// ECRAN 2: APPOINTMENT DETAILS
// =========================================================================
class AppointmentDetailsScreen extends StatelessWidget {
  // Setate când ecranul e deschis dintr-un doctor din lista "Nearby"
  final String? doctorId;
  final DetailsDoctor? doctor;

  const AppointmentDetailsScreen({super.key, this.doctorId, this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingCubit(
        context.read<MedicalRepository>(),
        doctorOverride: doctor,
      )..load(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<BookingCubit, BookingState>(
            listenWhen: (a, b) => a.submitStatus != b.submitStatus,
            listener: _onSubmitChanged,
            builder: (context, state) {
              switch (state.status) {
                case BookingStatus.loading:
                  return const LoadingView();
                case BookingStatus.error:
                  return ErrorView(
                    message: state.errorMessage ?? 'Unknown error',
                    onRetry: context.read<BookingCubit>().load,
                  );
                case BookingStatus.success:
                  return _DetailsContent(state: state, doctorId: doctorId);
              }
            },
          ),
        ),
      ),
    );
  }

  void _onSubmitChanged(BuildContext context, BookingState state) {
    final messenger = ScaffoldMessenger.of(context);
    if (state.submitStatus == SubmitStatus.done) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text(
            'Appointment booked with ${state.details!.doctor.name}: '
            '${state.selectedDateLabel}, ${state.selectedHourLabel}',
          ),
        ),
      );
    } else if (state.submitStatus == SubmitStatus.failed) {
      messenger.showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Booking failed')),
      );
    }
  }
}

class _DetailsContent extends StatelessWidget {
  final BookingState state;
  final String? doctorId;

  const _DetailsContent({required this.state, this.doctorId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    final details = state.details!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Bara de sus: back + titlu + favorite ----
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, size: 18),
              ),
              Expanded(
                child: Text(
                  details.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (doctorId != null) _DoctorFavoriteButton(doctorId: doctorId!),
            ],
          ),
          const SizedBox(height: 16),

          _DoctorInfo(
            doctor: details.doctor,
            heroTag: doctorId != null ? 'doctor-$doctorId' : null,
            paymentLabel: details.paymentLabel,
            payment: details.paymentFormatted,
          ),
          const SizedBox(height: 24),

          // ---- Detalii ----
          Text(
            details.detailsTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            details.description,
            style: const TextStyle(
              color: AppColors.textGrey,
              height: 1.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _SlotPicker(
            section: details.workingHours,
            selectedId: state.selectedHourId,
            onSelect: cubit.selectHour,
          ),
          const SizedBox(height: 22),
          _SlotPicker(
            section: details.date,
            selectedId: state.selectedDateId,
            onSelect: cubit.selectDate,
          ),
          const SizedBox(height: 30),

          PrimaryButton(
            label: state.submitStatus == SubmitStatus.done
                ? 'Booked ✓'
                : details.bookLabel,
            loading: state.submitStatus == SubmitStatus.submitting,
            onPressed: state.canBook ? cubit.book : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Butonul de favorite citește starea din HomeCubit, deci e sincronizat cu lista
class _DoctorFavoriteButton extends StatelessWidget {
  final String doctorId;
  const _DoctorFavoriteButton({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<HomeCubit, bool>(
      (c) => c.state.doctors.any((d) => d.id == doctorId && d.isFavorite),
    );
    return FavoriteButton(
      isFavorite: isFavorite,
      onPressed: () => context.read<HomeCubit>().toggleFavorite(doctorId),
    );
  }
}

class _DoctorInfo extends StatelessWidget {
  final DetailsDoctor doctor;
  final String? heroTag;
  final String paymentLabel;
  final String payment;

  const _DoctorInfo({
    required this.doctor,
    required this.paymentLabel,
    required this.payment,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = AppAvatar(
      url: doctor.avatarUrl,
      name: doctor.name,
      size: 80,
      borderRadius: 16,
    );
    if (heroTag != null) avatar = Hero(tag: heroTag!, child: avatar);

    void notAvailable() => ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Not available in this demo')));

    return Row(
      children: [
        avatar,
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (doctor.canMessage) ...[
                    RoundIcon(
                      icon: Icons.chat_bubble_outline,
                      onTap: notAvailable,
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (doctor.canCall) ...[
                    RoundIcon(icon: Icons.call_outlined, onTap: notAvailable),
                    const SizedBox(width: 6),
                  ],
                  if (doctor.canVideoCall)
                    RoundIcon(
                      icon: Icons.videocam_outlined,
                      onTap: notAvailable,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                doctor.clinic,
                style: const TextStyle(color: AppColors.primary, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    paymentLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    payment,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Secțiune cu titlu + rând de chip-uri selectabile (ore sau zile)
class _SlotPicker extends StatelessWidget {
  final SlotSection section;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const _SlotPicker({
    required this.section,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: section.title, onAction: () {}),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final slot in section.slots)
              SelectableChip(
                label: slot.label,
                selected: slot.id == selectedId,
                onTap: () => onSelect(slot.id),
              ),
          ],
        ),
      ],
    );
  }
}
