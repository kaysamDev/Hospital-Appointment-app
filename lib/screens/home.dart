import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: Column(
          children: [
            // Image.asset("assets/images/hospital_reception.jpg"),
            Image(image: AssetImage('assets/images/hospital_reception.jpg')),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    "Compassionate Care, Advanced Medicine",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Your health is our priority. Experience world-class medical services at MedCore",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the next screen
                    },
                    label: const Text("Book an Appointment"),
                    icon: const Icon(Icons.arrow_right_alt),
                    iconAlignment: IconAlignment.end,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0056B3),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
