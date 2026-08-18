import 'package:flutter/material.dart';
import "../screens/schedule_appointment.dart";
import "../screens/appointments.dart";
import "../screens/home.dart";
import "../services/appointment_manager.dart";

void main() => runApp(const NavigationPage());

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  String? preselectedDoctor;

  void changeTab(int index, {String? doctorName}) {
    setState(() {
      if (doctorName != null) {
        preselectedDoctor = doctorName;
      }
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppointmentManager.instance,
      builder: (context, child) {
        final count = AppointmentManager.instance.appointments.length;
        final badgeLabel = Text('$count');

        return Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.local_hospital, color: Color(0xFF0056B3)),
            title: const Text(
              'MedCore',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: const Color(0xFF0056B3),
            backgroundColor: Colors.white,
            selectedIndex: currentPageIndex,
            destinations: <Widget>[
              const NavigationDestination(
                selectedIcon: Icon(Icons.home, color: Colors.white),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              const NavigationDestination(
                selectedIcon: Icon(Icons.calendar_month, color: Colors.white),
                icon: Icon(Icons.calendar_month_outlined),
                label: 'Schedule',
              ),
              NavigationDestination(
                selectedIcon: count > 0
                    ? Badge(
                        label: badgeLabel,
                        child: const Icon(Icons.medical_services, color: Colors.white),
                      )
                    : const Icon(Icons.medical_services, color: Colors.white),
                icon: count > 0
                    ? Badge(
                        label: badgeLabel,
                        child: const Icon(Icons.medical_services_outlined),
                      )
                    : const Icon(Icons.medical_services_outlined),
                label: 'Appointments',
              ),
            ],
          ),
          body: IndexedStack(
            index: currentPageIndex,
            children: <Widget>[
              Home(
                onBookAppointmentTap: () => changeTab(1),
                onBookDoctorTap: (doctorName) => changeTab(1, doctorName: doctorName),
              ),
              ScheduleAppointment(
                preselectedDoctor: preselectedDoctor,
                onAppointmentBooked: () => changeTab(2),
              ),
              AppointmentsScreen(onNavigateToSchedule: () => changeTab(1)),
            ],
          ),
        );
      },
    );
  }
}
