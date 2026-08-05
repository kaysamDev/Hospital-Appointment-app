import 'package:flutter/material.dart';
import "../screens/schedule_appointment.dart";
import "../screens/appointments.dart";
import "../screens/home.dart";

void main() => runApp(const NavigationPage());

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color(0xFF0056B3),
        backgroundColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.white),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month, color: Colors.white),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Schedule',
          ),
          NavigationDestination(
            selectedIcon: Badge(
              label: Text('2'),
              child: Icon(Icons.medical_services, color: Colors.white),
            ),
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.medical_services_outlined),
            ),
            label: 'Appointments',
          ),
        ],
      ),
      body: <Widget>[
        Home(),
        // Schedule Appointment page
        ScheduleAppointment(),
        // Appointments
        Apponintments(),
      ][currentPageIndex],
    );
  }
}
