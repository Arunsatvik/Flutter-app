const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const connection = require('../db.js');

// checkout.js

router.get('/getCheckedInStudents', (req, res) => {
    // Fetch the list of currently checked-in students
    connection.query(
      'SELECT check_in_id, students_profile.student_id, student_First_Name, student_Last_Name, students_profile.Email, Checkin_DateTime ' +
      'FROM checked_in ' +
      'JOIN students_profile ON checked_in.student_id = students_profile.student_id ' +
      'WHERE Checkout_DateTime IS NULL',
      (error, results) => {
        if (error) {
          console.error('Error fetching checked-in students:', error);
          res.status(500).json({ error: 'Internal Server Error' });
        } else {
          res.status(200).json(results);
        }
      }
    );
  });
  

  // checkout.js

  router.post('/performCheckout', (req, res) => {
    const { student_id, email } = req.body;

    // Validate the email for security (you can add more validation logic)
    if (!email || typeof email !== 'string') {
        return res.status(400).json({ error: 'Invalid email' });
    }

    // Check if the student is checked in
    connection.query(
        'SELECT * FROM checked_in WHERE student_id = ? AND Checkout_DateTime IS NULL',
        [student_id],
        (checkError, checkResults) => {
            if (checkError) {
                console.error('Error checking student check-in status:', checkError);
                res.status(500).json({ error: 'Internal Server Error' });
            } else if (checkResults.length === 0) {
                res.status(404).json({ error: 'Student not currently checked in' });
            } else {
                // Verify if the entered email matches the student's email
                const storedEmail = checkResults[0].Email;
                if (storedEmail !== email) {
                    res.status(400).json({ error: 'Entered email does not match' });
                    return;
                }

                // Student is checked in, update Checkout_DateTime
                connection.query(
                    'UPDATE checked_in SET Checkout_DateTime = CURRENT_TIMESTAMP WHERE student_id = ?',
                    [student_id],
                    (updateError) => {
                        if (updateError) {
                            console.error('Error updating checkout timestamp:', updateError);
                            res.status(500).json({ error: 'Internal Server Error' });
                        } else {
                            res.status(200).json({ message: 'Checkout successful' });
                        }
                    }
                );
            }
        }
    );
});

  
  

module.exports = router;