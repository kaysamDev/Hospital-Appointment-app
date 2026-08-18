class Appointment {
  final String id;
  final String patientName;
  final String doctorName;
  final String date;
  final String time;
  final DateTime createdAt;
  final String status; // 'Upcoming', 'Completed', 'Cancelled'

  Appointment({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.time,
    DateTime? createdAt,
    this.status = 'Upcoming',
  }) : createdAt = createdAt ?? DateTime.now();

  Appointment copyWith({
    String? patientName,
    String? doctorName,
    String? date,
    String? time,
    String? status,
  }) {
    return Appointment(
      id: id,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      time: time ?? this.time,
      createdAt: createdAt,
      status: status ?? this.status,
    );
  }
}
