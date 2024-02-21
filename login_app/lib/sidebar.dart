// sidebar.dart
import 'package:flutter/material.dart';
import 'package:login_app/homepage.dart';
import 'package:login_app/qrcode.dart';
import 'checkin.dart';
import 'checkout.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: const Text(
              "Welcome!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            title: const Text("Home"), // Add a "Home" item
            onTap: () {
              // Navigate to the HomePage when "Home" is tapped
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            title: const Text("Check In"),
            onTap: () {
              // Navigate to the CheckInPage when "Check In" is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckInPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Check Out"),
            onTap: () {
              // Navigate to the CheckOutPage when "Check Out" is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckOutPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Scan QR code"),
            onTap: () {
              // Navigate to the QrCodePage when "Scan QR code" is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrCodePage()),
              );
            },
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}
