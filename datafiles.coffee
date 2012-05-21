fs = require 'fs'
config = require './config'
path = require 'path'

exports.setData = (id, obj) ->
  pathx = config.datapath
  fname = pathx + "/" + id
  json = JSON.stringify(obj)
  fs.writeFileSync fname, json
  true

exports.getData = (id, def) ->
  ret = undefined
  pathx = config.datapath
  fname = pathx + "/" + id
  console.log "fname is #{fname}"
  fr = undefined
  if path.existsSync fname
    data = fs.readFileSync fname
    try
      JSON.parse data
    catch e
      console.log "Couldn't parse JSON " + e.message
  else
    console.log "filenotfound " + fname
    exports.setData id, def
    def
