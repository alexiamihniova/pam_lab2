import 'package:equatable/equatable.dart';

// Un interval selectabil (oră sau zi)
class Slot extends Equatable {
  final String id;
  final String label;
  final bool selected;

  const Slot({required this.id, required this.label, this.selected = false});

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'] as String,
      label: json['label'] as String,
      selected: json['selected'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, label, selected];
}

// Secțiune cu titlu + listă de intervale ("workingHours", "date")
class SlotSection extends Equatable {
  final String title;
  final List<Slot> slots;

  const SlotSection({required this.title, required this.slots});

  factory SlotSection.fromJson(Map<String, dynamic> json) {
    return SlotSection(
      title: json['title'] as String? ?? '',
      slots: (json['slots'] as List<dynamic>? ?? [])
          .map((e) => Slot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Id-ul intervalului selectat implicit în JSON
  String? get initialSelectedId {
    for (final slot in slots) {
      if (slot.selected) return slot.id;
    }
    return slots.isNotEmpty ? slots.first.id : null;
  }

  @override
  List<Object?> get props => [title, slots];
}

// Informațiile despre doctor afișate pe ecranul de detalii
class DetailsDoctor extends Equatable {
  final String name;
  final String clinic;
  final String avatarUrl;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;

  const DetailsDoctor({
    required this.name,
    required this.clinic,
    required this.avatarUrl,
    this.canMessage = true,
    this.canCall = true,
    this.canVideoCall = true,
  });

  factory DetailsDoctor.fromJson(Map<String, dynamic> json) {
    final actions = json['actions'] as Map<String, dynamic>? ?? {};
    return DetailsDoctor(
      name: json['name'] as String,
      clinic: json['clinic'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      canMessage: actions['message'] as bool? ?? true,
      canCall: actions['call'] as bool? ?? true,
      canVideoCall: actions['videoCall'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [
    name,
    clinic,
    avatarUrl,
    canMessage,
    canCall,
    canVideoCall,
  ];
}

// Datele ecranului de detalii ("appointmentDetails" din JSON)
class AppointmentDetails extends Equatable {
  final String title;
  final DetailsDoctor doctor;
  final String paymentLabel;
  final String paymentFormatted;
  final String detailsTitle;
  final String description;
  final SlotSection workingHours;
  final SlotSection date;
  final String bookLabel;
  final bool bookEnabled;

  const AppointmentDetails({
    required this.title,
    required this.doctor,
    required this.paymentLabel,
    required this.paymentFormatted,
    required this.detailsTitle,
    required this.description,
    required this.workingHours,
    required this.date,
    required this.bookLabel,
    required this.bookEnabled,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    final payment = json['payment'] as Map<String, dynamic>? ?? {};
    final details = json['details'] as Map<String, dynamic>? ?? {};
    final book =
        (json['actions'] as Map<String, dynamic>?)?['bookAppointment']
            as Map<String, dynamic>? ??
        {};
    return AppointmentDetails(
      title: json['title'] as String? ?? 'Appointment',
      doctor: DetailsDoctor.fromJson(json['doctor'] as Map<String, dynamic>),
      paymentLabel: payment['label'] as String? ?? 'Payment',
      paymentFormatted: payment['formatted'] as String? ?? '',
      detailsTitle: details['title'] as String? ?? 'Details',
      description: details['description'] as String? ?? '',
      workingHours: SlotSection.fromJson(
        json['workingHours'] as Map<String, dynamic>? ?? {},
      ),
      date: SlotSection.fromJson(json['date'] as Map<String, dynamic>? ?? {}),
      bookLabel: book['label'] as String? ?? 'Book an Appointment',
      bookEnabled: book['enabled'] as bool? ?? true,
    );
  }

  // Aceleași detalii, dar pentru alt doctor (ex: un doctor din "Nearby")
  AppointmentDetails withDoctor(DetailsDoctor other) {
    return AppointmentDetails(
      title: title,
      doctor: other,
      paymentLabel: paymentLabel,
      paymentFormatted: paymentFormatted,
      detailsTitle: detailsTitle,
      description: description,
      workingHours: workingHours,
      date: date,
      bookLabel: bookLabel,
      bookEnabled: bookEnabled,
    );
  }

  @override
  List<Object?> get props => [
    title,
    doctor,
    paymentLabel,
    paymentFormatted,
    detailsTitle,
    description,
    workingHours,
    date,
    bookLabel,
    bookEnabled,
  ];
}
