express = require 'express'
datafiles = require './datafiles'
util = require 'util'
passwordHash = require 'password-hash'
fs = require 'fs'
config = require './config'
child = require 'child_process'


app = express.createServer()
app.use express.cookieParser()
app.use express.bodyParser()
#app.use express.session { secret: 'burrito13' }
app.use express.static(__dirname + '/public')

session = {}

#hostname = 

getCookie = (req, name) ->
  nameEQ = name + "="
  if not req.headers.cookie? then return null

  ca = req.headers.cookie.split(";")
  i = 0
  while i < ca.length
    c = ca[i]
    c = c.substring(1, c.length)  while c.charAt(0) is " "
    return c.substring(nameEQ.length, c.length)  if c.indexOf(nameEQ) is 0
    i++
  null


defaultpass = 'admin695'
hashedPass = passwordHash.generate defaultpass

defaults =
  user: 'admin'
  pass: hashedPass

userpass = datafiles.getData 'user', defaults

checkSecurity = (user, pass) ->
  if not userpass.user is user
    return false
  else
    return (passwordHash.verify pass, userpass.pass)


app.get "/", (req, res) ->
  if not req.headers.cookie?
    res.writeHead 200,
      'Content-Type': 'text/html'
    res.end 'Security check failed. Please <a href="/showlogin">login</a>'
  else
    sessionid = getCookie req, 'sessionid'
    if sessionid? and session[sessionid]
      res.end fs.readFileSync 'index.html'
    else
      res.writeHead 200,
        'Content-Type': 'text/html'
      res.end 'Security check failed. Please <a href="/showlogin">login</a>'


app.post "/login", (req, res) ->
  if checkSecurity req.body.user, req.body.pass
    session[req.body.id] = true
    res.cookie('sessionid', req.body.id, { expires: new Date(Date.now() + 9900000)})
    res.redirect '/'
  else
    res.end 'Security check failed.  Go back to try again.'

  
app.get "/showlogin", (req, res) ->
  res.end fs.readFileSync 'showlogin.html'

app.get "/man.js", (req, res) ->
  res.end fs.readFileSync 'man.js'

app.get "/manstyle.css", (req, res) ->
  res.end fs.readFileSync 'manstyle.css'

app.get "/sites", (req, res) ->
  sessionid = getCookie req, 'sessionid'
  if sessionid? and session[sessionid]
    sites = datafiles.getData 'subs', {}
    res.writeHead 200,
      'Content-Type': 'application/json'
    res.end JSON.stringify(sites)
  else
    res.end 'Security check failed'

app.post "/addsite", (req, res) ->
  sessionid = getCookie req, 'sessionid'
  if sessionid? and session[sessionid]
    sites = datafiles.getData 'subs', {}
    sites[req.body.site] =
      port:  req.body.port
      domains: ''
    child.exec "installscripts/oic #{req.body.site} #{req.body.port}"
    datafiles.setData 'subs', sites
    
    res.end 'ok'
  else
    res.end 'Security check failed'


app.post "/updatesite", (req, res) ->
  sessionid = getCookie req, 'sessionid'
  if sessionid? and session[sessionid]
    sites = datafiles.getData 'subs', {}
    console.log req
    toupdate = sites[req.body.site]
    toupdate.domains = req.body.domains
    console.log 'toupdate is now'
    console.log toupdate
    sites[req.body.site] = toupdate
    console.log 'sites is now'
    console.log sites
    datafiles.setData 'subs', sites
    res.end 'ok'
  else
    res.end 'Security check failed'



app.get "/config", (req, res) ->
  sessionid = getCookie req, 'sessionid'
  if sessionid? and session[sessionid]
    res.writeHead 200,
      'Content-Type': 'application/json'
    res.end JSON.stringify(config)
  else
    res.end 'Security check failed'




app.listen 3200
