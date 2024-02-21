// checkin.dart
import 'package:flutter/material.dart';
import 'sidebar.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR code"),
      ),
      drawer:
          const Sidebar(), // Provide a dummy username or retrieve it as needed
      body: Center(
        child: const Text("Scan QR code"),
      ),
    );
  }
}
