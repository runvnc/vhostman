express = require 'express'
MongolianDeadBeef = require 'mongolian'
server = new MongolianDeadBeef
nowjs = require 'now'
fs = require 'fs'
util = require 'util'
config = require './config'


db = server.db 'app'

app = express.createServer()
app.use express.cookieParser()
app.use express.session { secret: 'burrito13' }
app.use express.static(__dirname + '/public')

app.get "/", (req, res) ->
  res.end fs.readFileSync 'index.html'

nowjs = require 'now'
everyone = nowjs.initialize app

everyone.now.dbinsert = (col, data) ->
  db.collection(col).insert data

everyone.now.dbupdate = (col, criteria, data) ->
  db.collection(col).update criteria, data

everyone.now.dbfind = (col, callback) ->
  db.collection(col).find().toArray (err, data) ->
    callback data


app.listen config.port
