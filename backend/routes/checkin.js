const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const connection = require('../db.js'); // Import the database connection

// Add these APIs to your server.js file

// API endpoint for student profile creation or update
router.post('/createOrUpdateStudentProfile', (req, res) => {
  const {
    student_First_Name,
    student_Last_Name,
    Age,
    Email,
    Alternate_Email,
    Address_line_1,
    Address_line_2,
    Zip_code,
    parent_guardian,
    secondary_parent_guardian,
    phonenumber,
    sign_up_date = new Date().toISOString().split('T')[0],
    expire_date = null,
  } = req.body;

  // console.log("printing request body \n")
  // console.log(student_First_Name)

  // Check if the student profile already exists
  connection.query(
    'SELECT * FROM students_profile WHERE Email = ?',
    [Email],
    (error, results) => {
      if (error) {
        console.error('Error checking student profile:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      } else {
        if (results.length > 0) {
          // Student profile already exists
          const existingProfile = results[0];

          // Update the parent_guardian field
          connection.query(
            'UPDATE students_profile SET parent_guardian = ?, dw_create_datetime = CURRENT_TIMESTAMP WHERE Email = ?',
            [parent_guardian, Email],
            (error) => {
              if (error) {
                console.error('Error updating student profile:', error);
                res.status(500).json({ error: 'Internal Server Error' });
              } else {
                res.status(200).json({ message: 'Student profile updated successfully' });
              }
            }
          );
        } else {
          // Student profile not found, create a new one
          connection.query(
            'INSERT INTO students_profile SET ?',
            {
              student_First_Name,
              student_Last_Name,
              Age,
              Email,
              Alternate_Email,
              Address_line_1,
              Address_line_2,
              Zip_code,
              parent_guardian,
              secondary_parent_guardian,
              phonenumber,
              sign_up_date,
              expire_date,
               // Set to current timestamp
            },
            (error) => {
              if (error) {
                console.error('Error creating student profile:', error);
                res.status(500).json({ error: 'Internal Server Error' });
              } else {
                res.status(201).json({ message: 'Student profile created successfully' });
              }
            }
          );
        }
      }
    }
  );
});
  
  // API endpoint for student check-in
  router.post('/checkIn', (req, res) => {
    const { Email } = req.body;
  
    // Retrieve student_id from students_profile table based on the provided Email
    connection.query(
      'SELECT student_id FROM students_profile WHERE Email = ?',
      [Email],
      (error, results) => {
        
        if (error) {
          console.error('Error retrieving student_id:', error);
          res.status(500).json({ error: 'Internal Server Error' });
        } else {
          if (results.length > 0) {
            const student_id = results[0].student_id;
  
            // Add check-in details to checked_in table
            connection.query(
              'INSERT INTO checked_in (student_id, Email, Checkout_DateTime) VALUES (?, ?, NULL)',
              [student_id, Email],
              (error) => {
                if (error) {
                  console.error('Error checking in student:', error);
                  res.status(500).json({ error: 'Internal Server Error' });
                } else {
                  res.status(201).json({ message: 'Student checked in successfully' });
                }
              }
            );
          } else {
            res.status(404).json({ error: 'Student not found with the provided Email' });
          }
        }
      }
    );
  });
  
  
  module.exports = router;