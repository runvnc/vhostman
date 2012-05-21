(function() {
  var app, checkSecurity, datafiles, defaultpass, defaults, express, fs, getCookie, hashedPass, passwordHash, session, userpass, util;

  express = require('express');

  datafiles = require('./datafiles');

  util = require('util');

  passwordHash = require('password-hash');

  fs = require('fs');

  app = express.createServer();

  app.use(express.cookieParser());

  app.use(express.bodyParser());

  app.use(express.static(__dirname + '/public'));

  session = {};

  getCookie = function(req, name) {
    var c, ca, i, nameEQ;
    nameEQ = name + "=";
    ca = req.headers.cookie.split(";");
    i = 0;
    while (i < ca.length) {
      c = ca[i];
      while (c.charAt(0) === " ") {
        c = c.substring(1, c.length);
      }
      if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
      i++;
    }
    return null;
  };

  defaultpass = 'admin695';

  hashedPass = passwordHash.generate(defaultpass);

  defaults = {
    user: 'admin',
    pass: hashedPass
  };

  userpass = datafiles.getData('user', defaults);

  checkSecurity = function(user, pass) {
    if (!userpass.user === user) {
      return false;
    } else {
      return passwordHash.verify(pass, userpass.pass);
    }
  };

  app.get("/", function(req, res) {
    var sessionid;
    if (!(req.headers.cookie != null)) {
      res.writeHead(200, {
        'Content-Type': 'text/html'
      });
      res.end('Security check failed. Please <a href="/showlogin">login</a>');
    }
    sessionid = getCookie(req, 'sessionid');
    if ((sessionid != null) && session[sessionid]) {
      return res.end(fs.readFileSync('index.html'));
    } else {
      res.writeHead(200, {
        'Content-Type': 'text/html'
      });
      return res.end('Security check failed. Please <a href="/showlogin">login</a>');
    }
  });

  app.post("/login", function(req, res) {
    if (checkSecurity(req.body.user, req.body.pass)) {
      session[req.body.id] = true;
      res.cookie('sessionid', req.body.id, {
        expires: new Date(Date.now() + 9900000)
      });
      return res.redirect('/');
    } else {
      return res.end('Security check failed.  Go back to try again.');
    }
  });

  app.get("/showlogin", function(req, res) {
    return res.end(fs.readFileSync('showlogin.html'));
  });

  app.get("/man.js", function(req, res) {
    return res.end(fs.readFileSync('man.js'));
  });

  app.get("/manstyle.css", function(req, res) {
    return res.end(fs.readFileSync('manstyle.css'));
  });

  app.get("/sites", function(req, res) {
    var sessionid, sites;
    sessionid = getCookie(req, 'sessionid');
    if ((sessionid != null) && session[sessionid]) {
      sites = datafiles.getData('subs', {});
      res.writeHead(200, {
        'Content-Type': 'application/json'
      });
      return res.end(JSON.stringify(sites));
    } else {
      return res.end('Security check failed');
    }
  });

  app.listen(3200);

}).call(this);
