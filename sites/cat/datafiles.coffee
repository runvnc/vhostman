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
  fr = undefined
  if path.existsSync fname
    data = fs.readFileSync fname
    try
      JSON.parse data
    catch e
      console.log "Couldn't parse notifications JSON " + e.message      
  else
    console.log "filenotfound " + fname
    exports.setData id, def
    def
