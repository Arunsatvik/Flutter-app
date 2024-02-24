import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List<Map<String, dynamic>> checkedInStudents = [];

  @override
  void initState() {
    super.initState();
    // Fetch the list of checked-in students when the page loads
    _fetchCheckedInStudents();
  }

  Future<void> _fetchCheckedInStudents() async {
    final response = await http
        .get(Uri.parse('http://localhost:3001/checkout/getCheckedInStudents'));

    if (response.statusCode == 200) {
      setState(() {
        checkedInStudents =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Handle the error or display a message
      print('Error fetching checked-in students: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Out"),
      ),
      drawer: const Sidebar(),
      body: Container(
        alignment: Alignment.topCenter,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('S NO.')),
            DataColumn(label: Text('Student Name')),
            DataColumn(label: Text('Checked in Time')),
            DataColumn(label: Text('Checkout')),
          ],
          rows: List<DataRow>.generate(
            checkedInStudents.length,
            (index) => DataRow(
              cells: [
                DataCell(Text((index + 1).toString())),
                DataCell(Text(
                  '${checkedInStudents[index]['student_First_Name']} ${checkedInStudents[index]['student_Last_Name']}',
                )),
                DataCell(Text(
                  _formatDateTime(checkedInStudents[index]['Checkin_DateTime']),
                )),
                DataCell(ElevatedButton(
                  onPressed: () {
                    // Ask for email in a popup before proceeding with checkout
                    _promptForEmailAndCheckout(checkedInStudents[index]);
                  },
                  child: const Text('Checkout'),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _promptForEmailAndCheckout(Map<String, dynamic> student) async {
    String enteredEmail = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = '';

        return AlertDialog(
          title: const Text('Enter Email'),
          content: TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(email); // Dismiss the dialog and return email
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (enteredEmail != null && enteredEmail.isNotEmpty) {
      // If the user entered an email, proceed with checkout
      _handleCheckout(student, enteredEmail);
    }
  }

  void _handleCheckout(Map<String, dynamic> student, String email) async {
    // Show a loading indicator
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      barrierDismissible: false,
    );
    Map<String, dynamic> formData = {
      'student_id': student['student_id'],
      'email': email,
    };

    // Call the API to perform the checkout
    http.Response response = await http.post(
      Uri.parse('http://localhost:3001/checkout/performCheckout'),
      body: jsonEncode(formData),
      headers: {'Content-Type': 'application/json'},
    );

    // Dismiss the loading indicator
    Navigator.of(context).pop();

    // Display the result
    if (response.statusCode == 200) {
      // Checkout successful
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Success'),
            content: Text('Checkout successful!'),
          );
        },
      );

// Delay for 3 seconds and then close the success popup
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(); // Close the dialog
        _fetchCheckedInStudents();
      });
    } else {
      // Checkout failed, display error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                Text('Checkout failed: ${json.decode(response.body)['error']}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the error dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  String _formatDateTime(String dateTimeString) {
    // Convert the dateTimeString to the desired format: 'YYYY-MM-DD HH:MM:SS'
    final dateTime = DateTime.parse(dateTimeString);
    final formattedDateTime =
        '${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} '
        '${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}';
    return formattedDateTime;
  }

  String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : value.toString();
  }
}
