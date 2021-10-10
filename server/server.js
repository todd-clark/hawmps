require('dotenv').config();

const express = require('express');
const path = require('path');
const bcrypt = require('bcrypt');
const app = express(),
      bodyParser = require("body-parser");
      port = 3080;

var mysql = require('mysql'); 

var pool = mysql.createPool({
  connectionLimit: process.env.DB_CONN_LIMIT,
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB
});

// // place holder for the data
//  const users = [];
//  const crew = [];

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, '../client/dist')));

app.get('/api/crew', (req, res) => {
    var sql = ` SELECT 
                  id, 
                  coalesce(full_name, first_name) AS fullName, 
                  gender 
                FROM crew
                WHERE full_name LIKE ${mysql.escape('%' + req.query.searchCriteria + '%')} 
                LIMIT 1000;`;

    pool.query(sql, function (err, result) {
      if (err) throw err;
      res.json(result);
    });
});

app.get('/api/member', (req, res) => {
  var sql = ` SELECT 
                COALESCE (full_name, first_name) AS fullName,
                r.role_name AS role,
                cr.role_data AS roleInfo
              FROM crew c 
                JOIN crew_roles cr on c.id = cr.crew_id 
                JOIN roles r on r.id = cr.role_id 
              WHERE c.id = ${mysql.escape(req.query.id)};`;
  
  pool.query(sql, function (err, result) {
    if (err) throw err;
    console.log(result);
    res.json(result);
  });
});

//authenticate user
app.get('/api/auth', (req, res) => {
  console.log('api/auth called!!!!!!!')
  res.json("authorized");
});

//create user
app.post('/api/user', (req, res) => {
  var username = req.get('username');
  var pass = req.get('pass');
  var saltRounds = 10;

  bcrypt.hash(pass, saltRounds, function(err, hash) {
    var sql = ` INSERT INTO users (username, pass_hash) 
                VALUES (${mysql.escape(username)}, ${mysql.escape(hash)})`;
  
  pool.query(sql, function (err, result) {
      if (err) {
        console.log(err);
        if(err.sqlMessage.startsWith('Duplicate entry')){
          res.json(`Error: User ${username} already exists!`);
        }
      }
      else{
        console.log(`User ${username} added!`);
        res.json(`User ${username} added!`);
      }
    });
  });
});

app.get('/', (req,res) => {
  res.sendFile(path.join(__dirname, '../client/build/index.html'));
});

app.listen(port, () => {
    console.log(`Server listening on the port::${port}`);
});