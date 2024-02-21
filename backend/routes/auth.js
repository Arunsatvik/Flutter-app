const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const connection = require('../db.js'); // Import the database connection

router.post('/signup', (req, res) => {
  const { name, email, password, location } = req.body;
  const hashedPassword = hashPassword(password);

  connection.query(
    'INSERT INTO users (name, email, password, location) VALUES (?, ?, ?, ?)',
    [name, email, hashedPassword, location],
    (error) => {
      if (error) {
        console.error('Error signing up user:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      } else {
        res.status(201).json({ message: 'Signup successful' });
      }
    }
  );
});

router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  connection.query(
    'SELECT email, password FROM users WHERE email = ?',
    [email],
    async (error, results) => {
      if (error) {
        console.error('Error querying user:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      } else {
        if (results.length > 0) {
          const user = results[0];
          const passwordMatch = password === user.password;
          if (passwordMatch) {
            res.status(200).json({ message: 'Login successful' });
          } else {
            res.status(401).json({ error: 'Invalid email or password' });
          }
        } else {
          res.status(404).json({ error: 'User not found' });
        }
      }
    }
  );
});

module.exports = router;
