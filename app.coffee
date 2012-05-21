datafiles = require './datafiles'
bouncy = require 'bouncy'


httpbouncer = null
httpsbouncer = null

makebouncer = (port) ->
  ret = bouncy (req, bounce) ->
  if sites.hasOwnProperty req.headers.host
    site = sites[req.headers.host]
    host = site[0]
    port = site[1]
    bounce host, port
  else
    console.log "site #{req.headers.host} not found"
  ret.listen port

setup = ->
  sites = datafiles.getData 'subs', {}
  if httpbouncer? then httpbouncer.close()
  httpbouncer = makebouncer 80
  if httpsbouncer? then httpsbouncer.close()
  httpsbouncer = makebouncer 443


setup()

