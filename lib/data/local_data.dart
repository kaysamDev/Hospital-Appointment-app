import 'package:flutter/material.dart';
import '../models/appointment.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String experience;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    this.rating = 4.9,
    this.experience = '10+ yrs exp',
  });
}

class MedicalService {
  final String title;
  final IconData icon;
  final String description;

  const MedicalService({
    required this.title,
    required this.icon,
    required this.description,
  });
}

class HospitalFeature {
  final String title;
  final IconData icon;
  final String subtitle;

  const HospitalFeature({
    required this.title,
    required this.icon,
    required this.subtitle,
  });
}

class LocalData {
  LocalData._();

  // ------------------------------------
  // DOCTORS LIST
  // ------------------------------------
  static const List<Doctor> doctors = [
    Doctor(
      id: 'doc_1',
      name: 'Dr. James Smith',
      specialty: 'Cardiologist',
      rating: 4.9,
      experience: '12+ yrs exp',
    ),
    Doctor(
      id: 'doc_2',
      name: 'Dr. Jao Pedro',
      specialty: 'Pediatrician',
      rating: 4.8,
      experience: '8+ yrs exp',
    ),
    Doctor(
      id: 'doc_3',
      name: 'Dr. Richardson Regan',
      specialty: 'General Medicine',
      rating: 4.9,
      experience: '15+ yrs exp',
    ),
    Doctor(
      id: 'doc_4',
      name: 'Dr. Samuel Boafo',
      specialty: 'Orthopedic Surgeon',
      rating: 4.7,
      experience: '10+ yrs exp',
    ),
  ];

  static List<String> get doctorNames =>
      doctors.map((doc) => doc.name).toList();

  // ------------------------------------
  // FEATURED SERVICES
  // ------------------------------------
  static const List<MedicalService> services = [
    MedicalService(
      title: "General Medicine",
      icon: Icons.medical_services_outlined,
      description: "Comprehensive primary care for all age groups.",
    ),
    MedicalService(
      title: "Pediatrics",
      icon: Icons.child_care_outlined,
      description: "Dedicated medical care for infants and children.",
    ),
    MedicalService(
      title: "Cardiology",
      icon: Icons.monitor_heart_outlined,
      description: "Advanced heart care and diagnosis.",
    ),
    MedicalService(
      title: "Orthopedics",
      icon: Icons.accessibility_new_outlined,
      description: "Specialized treatment for bones and joints.",
    ),
  ];

  // ------------------------------------
  // WHY CHOOSE US FEATURES
  // ------------------------------------
  static const List<HospitalFeature> whyChooseUsFeatures = [
    HospitalFeature(
      title: "Experienced Medical Professionals",
      icon: Icons.verified_user_outlined,
      subtitle: "Board-certified doctors with decades of combined experience.",
    ),
    HospitalFeature(
      title: "State-of-the-Art Facilities",
      icon: Icons.biotech_outlined,
      subtitle: "Modern diagnostic labs & advanced surgical technology.",
    ),
    HospitalFeature(
      title: "24/7 Emergency & Critical Care",
      icon: Icons.health_and_safety_outlined,
      subtitle: "Round-the-clock emergency assistance and trauma care.",
    ),
  ];

  // ------------------------------------
  // INITIAL MOCK APPOINTMENTS
  // ------------------------------------
  static List<Appointment> get initialAppointments => [
        Appointment(
          id: '1',
          patientName: 'Jane Kelson',
          doctorName: 'Dr. James Smith',
          date: '15/8/2026',
          time: '10:30 AM',
          status: 'Upcoming',
        ),
        Appointment(
          id: '2',
          patientName: 'John Doe',
          doctorName: 'Dr. Richardson Regan',
          date: '18/8/2026',
          time: '02:00 PM',
          status: 'Upcoming',
        ),
      ];
}
