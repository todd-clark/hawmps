require('dotenv').config();

const express = require('express');
const path = require('path');
const bcrypt = require('bcrypt');
const jwt = require('njwt');
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

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, '../client/dist')));

//verify passed in jwt
function verifyJWT(token) { 
  var parts = token.split(' ');
  if (parts.length === 2) {
    var scheme = parts[0];
    var credentials = parts[1];
    if (scheme == 'Bearer') {
      token = credentials;
      return jwt.verify(token, process.env.JWT_KEY);
    }  
  }
};

//search for crew member based on name
app.get('/api/crew', (req, res) => {
  const token = req.get('Authorization');
  var validJWT = verifyJWT(token);
  if(validJWT){
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
  }
  else {
    res.json("Unauthorized");
  }
});

//get crew member data
app.get('/api/member', (req, res) => {
  const token = req.get('Authorization');
  var validJWT = verifyJWT(token);
  if(validJWT){
    var sql = ` SELECT 
                  COALESCE (full_name, first_name) AS fullName,
                  r.role_name AS role,
                  c.gender,
                  JSON_UNQUOTE(JSON_EXTRACT(cr.role_data, '$.Aka')) AS aka,
                  JSON_UNQUOTE(JSON_EXTRACT(cr.role_data, '$.CharacterName')) AS characterName,
                  JSON_UNQUOTE(JSON_EXTRACT(cr.role_data, '$.RoleInfo')) AS roleInfo,
                  JSON_UNQUOTE(COALESCE (JSON_EXTRACT(cr.role_data, '$.Credited'), 'true')) AS credited
                FROM crew c 
                  JOIN crew_roles cr on c.id = cr.crew_id 
                  JOIN roles r on r.id = cr.role_id 
                WHERE c.id = ${mysql.escape(req.query.id)};`;

    pool.query(sql, function (err, result) {
      if (err) throw err;
      console.log(result);
      res.json(result);
    });
  }
  else {
    res.json("Unauthorized");
  }
});

//authenticate user
app.get('/api/auth', (req, res) => {
  var username = req.get('username');
  var pass = req.get('pass');
  if(!pass || !username)
  {
    res.json(false);
  }
  else{
    var sql = ` SELECT 
                  pass_hash AS hash
                FROM users
                WHERE username = ${mysql.escape(username)};`;
    
    pool.query(sql, function (err, result) {
      if (err) throw err;
      console.log(result);

      bcrypt.compare(pass, result[0].hash, function(err, result) {
        if(result){
          const jwt = require('njwt')
          const claims = { iss: 'Hawmp!', username: username }
          const token = jwt.create(claims, process.env.JWT_KEY)
          //Set jwt expiration to 20 min
          token.setExpiration(new Date().getTime() + 60*10000)
          console.log(token.compact())
          res.json(token.compact())
        }
        else{
          console.log(result);
          res.json(null);
        }
      });
    });
  }
});

//create user
app.post('/api/user', (req, res) => {
  var username = req.get('username');
  var pass = req.get('pass');
  var saltRounds = 10;

  if(!pass || !username)
  {
    res.json("All fields are required");
  }
  else{
    bcrypt.hash(pass, saltRounds, function(err, hash) {
      var sql = ` INSERT INTO users (username, pass_hash) 
                  VALUES (${mysql.escape(username)}, ${mysql.escape(hash)})`;
    
    pool.query(sql, function (err, result) {
        if (err) {
          console.log(err);
          if(err.sqlMessage.startsWith('Duplicate entry')){
            res.json(`Error: User already exists!`);
          }
        }
        else{
          res.json(`User ${username} added!`);
        }
      });
    });
  }
});

app.get('/', (req,res) => {
  res.sendFile(path.join(__dirname, '../client/build/index.html'));
});

app.listen(port, () => {
    console.log(`Server listening on the port::${port}`);
});