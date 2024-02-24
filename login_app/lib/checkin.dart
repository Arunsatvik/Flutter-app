import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckInPage extends StatefulWidget {
  const CheckInPage({Key? key}) : super(key: key);

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final TextEditingController studentFirstNameController =
      TextEditingController();
  final TextEditingController studentLastNameController =
      TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alternateEmailController =
      TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController parentGuardianController =
      TextEditingController();
  final TextEditingController secondaryParentGuardianController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  // Add error variables for each field
  String? studentFirstNameError;
  String? studentLastNameError;
  String? ageError;
  String? emailError;
  String? addressLine1Error;
  String? zipCodeError;
  String? phoneNumberError;
  String? parentGuardianError;

  bool isParentGuardianVisible = false;
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
        title: const Text("Check In"),
      ),
      drawer: const Sidebar(),
      body: checkedInStudents.length >= 12
          ? const Center(
              child: Text(
                "Center is fully occupied, Please check back after sometime",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(
                      controller: studentFirstNameController,
                      labelText: 'First Name*',
                      errorText: studentFirstNameError,
                    ),
                    _buildTextField(
                      controller: studentLastNameController,
                      labelText: 'Last Name*',
                      errorText: studentLastNameError,
                    ),
                    _buildTextField(
                      controller: ageController,
                      labelText: 'Age*',
                      keyboardType: TextInputType.number,
                      errorText: ageError,
                      onChanged: (value) {
                        // Check if age is less than or equal to 12
                        if (value != null && int.tryParse(value) != null) {
                          int age = int.parse(value);
                          setState(() {
                            isParentGuardianVisible = age <= 12;
                          });
                        }
                      },
                    ),
                    _buildTextField(
                      controller: emailController,
                      labelText: 'Email*',
                      errorText: emailError,
                    ),
                    _buildTextField(
                      controller: alternateEmailController,
                      labelText: 'Alternate Email',
                    ),
                    _buildTextField(
                      controller: addressLine1Controller,
                      labelText: 'Address Line 1*',
                      errorText: addressLine1Error,
                    ),
                    _buildTextField(
                      controller: addressLine2Controller,
                      labelText: 'Address Line 2',
                    ),
                    _buildTextField(
                      controller: zipCodeController,
                      labelText: 'Zip Code*',
                      errorText: zipCodeError,
                    ),
                    _buildTextField(
                      controller: parentGuardianController,
                      labelText: 'Parent / Guardian',
                      errorText: parentGuardianError,
                    ),
                    _buildTextField(
                      controller: secondaryParentGuardianController,
                      labelText: 'Secondary Parent/Guardian',
                    ),
                    _buildTextField(
                      controller: phoneNumberController,
                      labelText: 'Phone Number*',
                      errorText: phoneNumberError,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate the form
                        if (_validateForm()) {
                          // Perform the check-in
                          _performCheckIn();
                        }
                      },
                      child: const Text('Check In'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    String? errorText,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: errorText != null ? Colors.red : Colors.black,
            ),
          ),
          errorText: errorText,
          errorStyle: const TextStyle(color: Colors.red),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyle(
          color: errorText != null ? Colors.red : null,
        ),
        validator: (value) {
          if (errorText != null && value!.isEmpty) {
            return errorText;
          }
          return null;
        },
      ),
    );
  }

  bool _validateForm() {
    List<String> missingFields = [];

    // Reset previous error states
    setState(() {
      studentFirstNameError = null;
      studentLastNameError = null;
      ageError = null;
      emailError = null;
      addressLine1Error = null;
      zipCodeError = null;
      phoneNumberError = null;
      parentGuardianError = null;
    });

    if (studentFirstNameController.text.isEmpty) {
      missingFields.add('First Name');
      setState(() {
        studentFirstNameError = 'First Name required';
      });
    }

    if (studentLastNameController.text.isEmpty) {
      missingFields.add('Last Name');
      setState(() {
        studentLastNameError = 'Last Name required';
      });
    }

    if (ageController.text.isEmpty) {
      missingFields.add('Age');
      setState(() {
        ageError = 'Age required';
      });
    }

    if (emailController.text.isEmpty) {
      missingFields.add('Email');
      setState(() {
        emailError = 'Email required';
      });
    }

    if (addressLine1Controller.text.isEmpty) {
      missingFields.add('Address Line 1');
      setState(() {
        addressLine1Error = 'Address required';
      });
    }

    if (zipCodeController.text.isEmpty) {
      missingFields.add('Zip Code');
      setState(() {
        zipCodeError = 'Zip code required';
      });
    }

    if (phoneNumberController.text.isEmpty) {
      missingFields.add('Phone Number');
      setState(() {
        phoneNumberError = 'Phone Number required';
      });
    }

    if (isParentGuardianVisible && parentGuardianController.text.isEmpty) {
      missingFields.add('Parent/Guardian');
      setState(() {
        parentGuardianError =
            'Parent/Guardian required for students of age 12 and below';
      });
    }

    // If there are missing fields, return false
    if (missingFields.isNotEmpty) {
      return false;
    }

    // Return true if there are no missing fields
    return true;
  }

  void _performCheckIn() async {
    // Build the form data JSON body
    Map<String, dynamic> formData = {
      'student_First_Name': studentFirstNameController.text,
      'student_Last_Name': studentLastNameController.text,
      'Age': ageController.text,
      'Email': emailController.text,
      'Alternate_Email': alternateEmailController.text,
      'Address_line_1': addressLine1Controller.text,
      'Address_line_2': addressLine2Controller.text,
      'Zip_code': zipCodeController.text,
      'parent_guardian': parentGuardianController.text,
      'secondary_parent_guardian': secondaryParentGuardianController.text,
      'phonenumber': phoneNumberController.text,
    };

    // Print the JSON body
    // print('Form Data JSON: $formData');

    try {
      // Make createOrUpdateStudentProfile request
      http.Response profileResponse = await http.post(
        Uri.parse('http://localhost:3001/checkin/createOrUpdateStudentProfile'),
        body: jsonEncode(formData),
        headers: {'Content-Type': 'application/json'},
      );

      // Check the response status
      if (profileResponse.statusCode == 200 ||
          profileResponse.statusCode == 201) {
        // Student profile created or updated successfully
        print("entered checkin api ");

        // Now, make check-in request
        http.Response checkInResponse = await http.post(
          Uri.parse('http://localhost:3001/checkin/checkIn'),
          body: jsonEncode(formData),
          headers: {'Content-Type': 'application/json'},
        );

        // Check the response status for check-in
        if (checkInResponse.statusCode == 201) {
          // Show success popup for 5 seconds
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Check-in successful!'),
              );
            },
          );

          // Delay for 5 seconds and then close the success popup
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop(); // Close the dialog

            // Clear form fields
            studentFirstNameController.clear();
            studentLastNameController.clear();
            ageController.clear();
            emailController.clear();
            alternateEmailController.clear();
            addressLine1Controller.clear();
            addressLine2Controller.clear();
            zipCodeController.clear();
            parentGuardianController.clear();
            secondaryParentGuardianController.clear();
            phoneNumberController.clear();

            // Reset visibility of Parent/Guardian field
            setState(() {
              isParentGuardianVisible = false;
            });
            _fetchCheckedInStudents();
          });
        } else {
          // Handle error case for check-in
          _showErrorDialog('Error during check-in.');
        }
      } else {
        // Handle error case for createOrUpdateStudentProfile
        _showErrorDialog('Error during student profile creation or update.');
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
      _showErrorDialog('Error during student profile creation or update.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
