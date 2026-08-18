import 'package:flutter/foundation.dart';
import '../data/local_data.dart';
import '../models/appointment.dart';

class AppointmentManager extends ChangeNotifier {
  // Singleton pattern for application-wide access
  static final AppointmentManager instance = AppointmentManager._internal();

  factory AppointmentManager() {
    return instance;
  }

  AppointmentManager._internal() {
    _appointments.addAll(LocalData.initialAppointments);
  }

  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  int get upcomingCount =>
      _appointments.where((a) => a.status == 'Upcoming').length;

  void addAppointment(Appointment appointment) {
    _appointments.insert(0, appointment);
    notifyListeners();
  }

  void updateAppointment(Appointment updatedAppointment) {
    final index = _appointments.indexWhere((a) => a.id == updatedAppointment.id);
    if (index != -1) {
      _appointments[index] = updatedAppointment;
      notifyListeners();
    }
  }

  void deleteAppointment(String id) {
    _appointments.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
