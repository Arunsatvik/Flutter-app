import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_app/login.dart'; // Update with your actual project path
import 'sidebar.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url =
        'https://qpwrk0nk6f.execute-api.us-west-1.amazonaws.com/v1/region/ventura/student/def@gmail.com';

    // Define your JSON payload
    final payload = {
      "statusCode": 200,
      "body": {
        "even_type": "signup",
        "student_First_Name": "Satvik",
        "student_Last_Name": "Mallampalli",
        "Age": 13,
        "Email": "satvik@gmail.com",
        "Alternate_Email": "",
        "Address_line_1": "111",
        "Address_line_2": "Oak Park",
        "Zip_code": 91377,
        "parent_guardian": "Arun",
        "secondary_parent_guardian": "",
        "phone": 9182736450
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'FfO6fyEEv69nrAKnZvcjK2CK9BU9iYP39HftWGmB',
        },
        body: jsonEncode(payload), // Encode the payload as JSON
      );

      if (response.statusCode == 200) {
        // Successful request
        print('Response: ${response.body}');
      } else {
        // Handle errors
        print('Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Big Brothers Big Sisters, Ventura County!",
              style: TextStyle(fontSize: 24),
            ),
            // Add other content here if needed
          ],
        ),
      ),
      drawer: const Sidebar(), // Include the sidebar here
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  // Logout button pressed
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false, // Pop all routes on top of LoginScreen
                  );
                },
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
