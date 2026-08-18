import 'package:flutter/material.dart';
import '../data/local_data.dart';
import '../models/appointment.dart';
import '../services/appointment_manager.dart';

class ScheduleAppointment extends StatefulWidget {
  final VoidCallback? onAppointmentBooked;
  final String? preselectedDoctor;

  const ScheduleAppointment({
    super.key,
    this.onAppointmentBooked,
    this.preselectedDoctor,
  });

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  // Controllers
  final TextEditingController patientController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  // Selected doctor & time slot
  String? selectedDoctor;
  String? doctorError;
  String? selectedTimeSlot;

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Quick Time Slots
  final List<String> timeSlots = const [
    "09:00 AM",
    "10:30 AM",
    "11:15 AM",
    "02:00 PM",
    "03:30 PM",
    "04:45 PM",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedDoctor != null) {
      selectedDoctor = widget.preselectedDoctor;
    }
  }

  @override
  void didUpdateWidget(covariant ScheduleAppointment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.preselectedDoctor != null &&
        widget.preselectedDoctor != oldWidget.preselectedDoctor) {
      setState(() {
        selectedDoctor = widget.preselectedDoctor;
        doctorError = null;
      });
    }
  }

  @override
  void dispose() {
    patientController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  // -------------------------
  // DATE PICKER HELPERS
  // -------------------------

  Future<void> selectDate() async {
    final DateTime today = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void _selectQuickDate(int daysFromToday) {
    final date = DateTime.now().add(Duration(days: daysFromToday));
    setState(() {
      dateController.text = "${date.day}/${date.month}/${date.year}";
    });
  }

  // -------------------------
  // TIME PICKER
  // -------------------------

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        final formattedTime = pickedTime.format(context);
        timeController.text = formattedTime;
        selectedTimeSlot = formattedTime;
      });
    }
  }

  // -------------------------
  // SUBMIT & CONFIRM MODAL
  // -------------------------

  void bookAppointment() {
    final isFormValid = _formKey.currentState!.validate();
    final isDoctorValid = selectedDoctor != null && selectedDoctor!.isNotEmpty;

    if (!isDoctorValid) {
      setState(() {
        doctorError = "Please select a doctor";
      });
    } else {
      setState(() {
        doctorError = null;
      });
    }

    if (isFormValid && isDoctorValid) {
      _showConfirmationModal();
    }
  }

  void _showConfirmationModal() {
    final String patient = patientController.text.trim();
    final String doctor = selectedDoctor!;
    final String date = dateController.text.trim();
    final String time = timeController.text.trim();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0056B3).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.event_available,
                      color: Color(0xFF0056B3),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Confirm Appointment Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Please review the details before confirming.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      label: "Patient Name",
                      value: patient,
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.medical_services_outlined,
                      label: "Doctor",
                      value: doctor,
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.calendar_month_outlined,
                      label: "Date",
                      value: date,
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.access_time_outlined,
                      label: "Time",
                      value: time,
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: Icons.info_outline,
                      label: "Status",
                      widgetValue: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: const Text(
                          "Upcoming",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0056B3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Edit Details",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Create and save appointment
                        final newAppointment = Appointment(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          patientName: patient,
                          doctorName: doctor,
                          date: date,
                          time: time,
                          status: 'Upcoming',
                        );

                        AppointmentManager.instance.addAppointment(newAppointment);

                        // Clear form
                        patientController.clear();
                        dateController.clear();
                        timeController.clear();
                        setState(() {
                          selectedDoctor = null;
                          selectedTimeSlot = null;
                        });

                        Navigator.pop(dialogContext);

                        // Show success banner with switch action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Appointment scheduled successfully!",
                            ),
                            backgroundColor: const Color(0xFF0056B3),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: "View",
                              textColor: Colors.white,
                              onPressed: () {
                                if (widget.onAppointmentBooked != null) {
                                  widget.onAppointmentBooked!();
                                }
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0056B3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Confirm & Schedule",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    String? value,
    Widget? widgetValue,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0056B3)),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const Spacer(),
        widgetValue ??
            Text(
              value ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------
                // PAGE HEADER BANNER
                // ------------------------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0056B3), Color(0xFF003875)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0056B3).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "MEDCORE CONSULTATION",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Book an Appointment",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Schedule a consultation with our top specialists.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ------------------------------------
                // 1. PATIENT INFORMATION CARD
                // ------------------------------------
                const Text(
                  "1. Patient Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: patientController,
                    decoration: const InputDecoration(
                      labelText: "Patient Full Name",
                      hintText: "e.g. Jane Kelson",
                      prefixIcon: Icon(Icons.person_outline, color: Color(0xFF0056B3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter patient full name";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // ------------------------------------
                // 2. SELECT DOCTOR (VISUAL CARDS & DROPDOWN)
                // ------------------------------------
                Row(
                  children: [
                    const Text(
                      "2. Select Specialist",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (selectedDoctor != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Selected",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Visual Doctor Selector Cards
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: LocalData.doctors.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: 12),
                    itemBuilder: (ctx, index) {
                      final doc = LocalData.doctors[index];
                      final isSelected = selectedDoctor == doc.name;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDoctor = doc.name;
                            doctorError = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 140,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0056B3).withValues(alpha: 0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0056B3)
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF0056B3).withValues(alpha: 0.15)
                                    : Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isSelected
                                        ? const Color(0xFF0056B3)
                                        : const Color(0xFF0056B3).withValues(alpha: 0.1),
                                    child: Icon(
                                      Icons.person,
                                      size: 18,
                                      color: isSelected ? Colors.white : const Color(0xFF0056B3),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF0056B3),
                                      size: 20,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                doc.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? const Color(0xFF0056B3) : Colors.black87,
                                ),
                              ),
                              Text(
                                doc.specialty,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (doctorError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      doctorError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 24),

                // ------------------------------------
                // 3. SELECT DATE
                // ------------------------------------
                const Text(
                  "3. Appointment Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Quick Date Pills
                Row(
                  children: [
                    _buildQuickDateChip(
                      label: "Today",
                      onTap: () => _selectQuickDate(0),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickDateChip(
                      label: "Tomorrow",
                      onTap: () => _selectQuickDate(1),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickDateChip(
                      label: "In 2 Days",
                      onTap: () => _selectQuickDate(2),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Custom Date Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: selectDate,
                    decoration: const InputDecoration(
                      labelText: "Appointment Date",
                      hintText: "Select date",
                      prefixIcon: Icon(Icons.calendar_month_outlined, color: Color(0xFF0056B3)),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select appointment date";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // ------------------------------------
                // 4. SELECT TIME
                // ------------------------------------
                const Text(
                  "4. Appointment Time",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Quick Time Slot Grid
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: timeSlots.map((slot) {
                    final isSelected = selectedTimeSlot == slot || timeController.text == slot;
                    return ChoiceChip(
                      label: Text(slot),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0056B3),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedTimeSlot = slot;
                            timeController.text = slot;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Custom Time Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: timeController,
                    readOnly: true,
                    onTap: selectTime,
                    decoration: const InputDecoration(
                      labelText: "Custom Appointment Time",
                      hintText: "Select time",
                      prefixIcon: Icon(Icons.access_time_outlined, color: Color(0xFF0056B3)),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select appointment time";
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // ------------------------------------
                // LIVE BOOKING SUMMARY BADGE
                // ------------------------------------
                if (selectedDoctor != null || dateController.text.isNotEmpty || timeController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0056B3).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF0056B3).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFF0056B3), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Doctor: ${selectedDoctor ?? 'Not selected'} | Date: ${dateController.text.isEmpty ? 'Not set' : dateController.text} | Time: ${timeController.text.isEmpty ? 'Not set' : timeController.text}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0056B3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // ------------------------------------
                // BOOK BUTTON
                // ------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: bookAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0056B3),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: const Color(0xFF0056B3).withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Book Appointment",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 22),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickDateChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
      labelStyle: const TextStyle(fontSize: 12, color: Colors.black87),
      onPressed: onTap,
    );
  }
}
