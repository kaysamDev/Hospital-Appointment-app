import 'package:flutter/material.dart';
import '../data/local_data.dart';
import '../models/appointment.dart';
import '../services/appointment_manager.dart';

// Alias for backward compatibility if referenced elsewhere
typedef Apponintments = AppointmentsScreen;

class AppointmentsScreen extends StatefulWidget {
  final VoidCallback? onNavigateToSchedule;

  const AppointmentsScreen({super.key, this.onNavigateToSchedule});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<String> get doctorList => LocalData.doctorNames;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ------------------------------------
  // VIEW DETAIL MODAL
  // ------------------------------------
  void _showDetailModal(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF0056B3).withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.medical_services_outlined,
                      color: Color(0xFF0056B3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Patient: ${appointment.patientName}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(appointment.status),
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
                    _buildModalInfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: "Appointment ID",
                      value: "#${appointment.id.substring(0, appointment.id.length > 8 ? 8 : appointment.id.length)}",
                    ),
                    const Divider(height: 20),
                    _buildModalInfoRow(
                      icon: Icons.person_outline,
                      label: "Patient Name",
                      value: appointment.patientName,
                    ),
                    const Divider(height: 20),
                    _buildModalInfoRow(
                      icon: Icons.calendar_month_outlined,
                      label: "Date",
                      value: appointment.date,
                    ),
                    const Divider(height: 20),
                    _buildModalInfoRow(
                      icon: Icons.access_time_outlined,
                      label: "Time",
                      value: appointment.time,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showEditModal(context, appointment);
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text("Edit"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF0056B3)),
                        foregroundColor: const Color(0xFF0056B3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showDeleteConfirmDialog(context, appointment);
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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

  // ------------------------------------
  // EDIT MODAL
  // ------------------------------------
  void _showEditModal(BuildContext context, Appointment appointment) {
    final editPatientController =
        TextEditingController(text: appointment.patientName);
    final editDateController = TextEditingController(text: appointment.date);
    final editTimeController = TextEditingController(text: appointment.time);
    String selectedEditDoctor = appointment.doctorName;
    String selectedEditStatus = appointment.status;

    final editFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: editFormKey,
                  child: SingleChildScrollView(
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
                        const SizedBox(height: 16),
                        const Text(
                          "Edit Appointment",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Patient Name
                        TextFormField(
                          controller: editPatientController,
                          decoration: const InputDecoration(
                            labelText: "Patient Name",
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "Patient name required"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Doctor Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: doctorList.contains(selectedEditDoctor)
                              ? selectedEditDoctor
                              : doctorList.first,
                          decoration: const InputDecoration(
                            labelText: "Doctor's Name",
                            prefixIcon: Icon(Icons.medical_services_outlined),
                            border: OutlineInputBorder(),
                          ),
                          items: doctorList
                              .map(
                                (d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(d),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedEditDoctor = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Date
                        TextFormField(
                          controller: editDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Appointment Date",
                            prefixIcon: Icon(Icons.calendar_month_outlined),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            final today = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: today,
                              firstDate: today,
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setModalState(() {
                                editDateController.text =
                                    "${picked.day}/${picked.month}/${picked.year}";
                              });
                            }
                          },
                          validator: (v) => v == null || v.isEmpty
                              ? "Date required"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Time
                        TextFormField(
                          controller: editTimeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Appointment Time",
                            prefixIcon: Icon(Icons.access_time_outlined),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setModalState(() {
                                editTimeController.text =
                                    picked.format(context);
                              });
                            }
                          },
                          validator: (v) => v == null || v.isEmpty
                              ? "Time required"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Status Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: selectedEditStatus,
                          decoration: const InputDecoration(
                            labelText: "Status",
                            prefixIcon: Icon(Icons.info_outline),
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Upcoming',
                              child: Text('Upcoming'),
                            ),
                            DropdownMenuItem(
                              value: 'Completed',
                              child: Text('Completed'),
                            ),
                            DropdownMenuItem(
                              value: 'Cancelled',
                              child: Text('Cancelled'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedEditStatus = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (editFormKey.currentState!.validate()) {
                                final updated = appointment.copyWith(
                                  patientName: editPatientController.text.trim(),
                                  doctorName: selectedEditDoctor,
                                  date: editDateController.text.trim(),
                                  time: editTimeController.text.trim(),
                                  status: selectedEditStatus,
                                );

                                AppointmentManager.instance
                                    .updateAppointment(updated);

                                Navigator.pop(ctx);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Appointment updated!"),
                                    backgroundColor: Color(0xFF0056B3),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0056B3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ------------------------------------
  // DELETE CONFIRM DIALOG
  // ------------------------------------
  void _showDeleteConfirmDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text("Cancel Appointment"),
            ],
          ),
          content: Text(
            "Are you sure you want to cancel the appointment for ${appointment.patientName} with ${appointment.doctorName}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Keep"),
            ),
            ElevatedButton(
              onPressed: () {
                AppointmentManager.instance.deleteAppointment(appointment.id);
                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Appointment cancelled."),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Cancel Appointment"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color fg;

    switch (status) {
      case 'Completed':
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        break;
      case 'Cancelled':
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        break;
      case 'Upcoming':
      default:
        bg = const Color(0xFF0056B3).withValues(alpha: 0.1);
        fg = const Color(0xFF0056B3);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildModalInfoRow({
    required IconData icon,
    required String label,
    required String value,
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
        Text(
          value,
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
    return ListenableBuilder(
      listenable: AppointmentManager.instance,
      builder: (context, child) {
        final allAppointments = AppointmentManager.instance.appointments;

        final filteredAppointments = allAppointments.where((appt) {
          final query = _searchQuery.toLowerCase();
          return appt.patientName.toLowerCase().contains(query) ||
              appt.doctorName.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Scheduled Appointments",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search doctor or patient...",
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF0056B3)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stats Header
                Row(
                  children: [
                    Text(
                      "Total (${filteredAppointments.length})",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0056B3).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${AppointmentManager.instance.upcomingCount} Upcoming",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0056B3),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Appointment List or Empty State
                Expanded(
                  child: filteredAppointments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? "No matching appointments found"
                                    : "No appointments scheduled yet",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (widget.onNavigateToSchedule != null &&
                                  _searchQuery.isEmpty)
                                ElevatedButton.icon(
                                  onPressed: widget.onNavigateToSchedule,
                                  icon: const Icon(Icons.add),
                                  label: const Text("Book an Appointment"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0056B3),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredAppointments.length,
                          separatorBuilder: (ctx, i) =>
                              const SizedBox(height: 12),
                          itemBuilder: (ctx, index) {
                            final appt = filteredAppointments[index];

                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _showDetailModal(context, appt),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                const Color(0xFF0056B3)
                                                    .withValues(alpha: 0.1),
                                            child: const Icon(
                                              Icons.medical_services_outlined,
                                              color: Color(0xFF0056B3),
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  appt.doctorName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Patient: ${appt.patientName}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          _buildStatusChip(appt.status),
                                        ],
                                      ),
                                      const Divider(height: 24),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            size: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            appt.date,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.access_time_outlined,
                                            size: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            appt.time,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                          const Spacer(),
                                          // Action buttons
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              size: 20,
                                              color: Color(0xFF0056B3),
                                            ),
                                            onPressed: () =>
                                                _showEditModal(context, appt),
                                            tooltip: "Edit",
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            onPressed: () =>
                                                _showDeleteConfirmDialog(
                                                    context, appt),
                                            tooltip: "Delete",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
