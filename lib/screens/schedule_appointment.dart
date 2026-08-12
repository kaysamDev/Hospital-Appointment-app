import 'package:flutter/material.dart';

class ScheduleAppointment extends StatefulWidget {
  const ScheduleAppointment({super.key});

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  // Controllers
  final TextEditingController patientController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  // Selected doctor
  String? selectedDoctor;

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    patientController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  // -------------------------
  // DATE PICKER
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
        timeController.text = pickedTime.format(context);
      });
    }
  }

  // -------------------------
  // SUBMIT
  // -------------------------

  void bookAppointment() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment details are valid")),
      );

      // Later:
      // Navigator.push(...)
      // to your appointment summary page.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Text(
                "Book an Appointment",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // -------------------------
              // PATIENT NAME
              // -------------------------
              TextFormField(
                controller: patientController,

                decoration: InputDecoration(
                  labelText: "Patient Name",
                  labelStyle: const TextStyle(color: Colors.black),
                  hintText: "Jane Kelson",

                  floatingLabelBehavior: FloatingLabelBehavior.always,

                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF0056B3),
                  ),

                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0056B3), width: 2),
                  ),

                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),

                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your name";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // -------------------------
              // DOCTOR
              // -------------------------
              DropdownMenu<String>(
                width: double.infinity,

                label: const Text("Doctor's Name"),

                hintText: "Select a doctor",

                leadingIcon: const Icon(
                  Icons.medical_services_outlined,
                  color: Color(0xFF0056B3),
                ),

                dropdownMenuEntries: const [
                  DropdownMenuEntry(
                    value: "Dr. James Smith",
                    label: "Dr. James Smith",
                  ),
                  DropdownMenuEntry(
                    value: "Dr. Jao Pedro",
                    label: "Dr. Jao Pedro",
                  ),
                  DropdownMenuEntry(
                    value: "Dr. Richardson Regan",
                    label: "Dr. Richardson Regan",
                  ),
                  DropdownMenuEntry(
                    value: "Dr. Samuel Boafo",
                    label: "Dr. Samuel Boafo",
                  ),
                ],

                onSelected: (value) {
                  setState(() {
                    selectedDoctor = value;
                  });
                },

                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0056B3)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // -------------------------
              // DATE
              // -------------------------
              TextFormField(
                controller: dateController,
                readOnly: true,

                onTap: selectDate,

                decoration: InputDecoration(
                  labelText: "Appointment Date",

                  labelStyle: const TextStyle(color: Colors.black),

                  hintText: "Select appointment date",

                  floatingLabelBehavior: FloatingLabelBehavior.always,

                  prefixIcon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF0056B3),
                  ),

                  suffixIcon: const Icon(Icons.arrow_drop_down),

                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0056B3)),
                  ),

                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a date";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // -------------------------
              // TIME
              // -------------------------
              TextFormField(
                controller: timeController,
                readOnly: true,

                onTap: selectTime,

                decoration: InputDecoration(
                  labelText: "Appointment Time",

                  labelStyle: const TextStyle(color: Colors.black),

                  hintText: "Select appointment time",

                  floatingLabelBehavior: FloatingLabelBehavior.always,

                  prefixIcon: const Icon(
                    Icons.access_time_outlined,
                    color: Color(0xFF0056B3),
                  ),

                  suffixIcon: const Icon(Icons.arrow_drop_down),

                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),

                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0056B3)),
                  ),

                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a time";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // -------------------------
              // BOOK BUTTON
              // -------------------------
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: bookAppointment,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056B3),

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Book an Appointment",
                          textAlign: TextAlign.start,

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Icon(Icons.arrow_right_alt, size: 28),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
