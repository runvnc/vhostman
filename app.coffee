datafiles = require './datafiles'
bouncy = require 'bouncy'
fs = require 'fs'
request = require 'request'
child = require 'child_process'

sites = {}

httpbouncer = null
httpsbouncer = null


getlist = (str) ->
  ret = []
  list = str.split ','
  for item in list
    if item? and item isnt '' and item.trim().length > 1
      ret.push item.trim()
   ret


findbyport = (port) ->
  for site, val of sites
    if site.port is port
      return site
  return undefined


checkrunning = (port) ->
  opts =
    url: "http://localhost:#{port}"
    timeout: 2500
  request opts, (er, res, body) ->
    if body? and body.length > 5
      console.log "ok response from " + port
      #ok
    else
      site = findbyport port
      if site?
        child.exec "sites/#{port}_#{site}/restart"
      else
        console.log "didnt find site " + site


makebouncer = (port) ->
  ret = bouncy (req, bounce) ->
    if sites.hasOwnProperty req.headers.host
      site = sites[req.headers.host]
      host = 'localhost'
      port = site.port
      bounce host, port
      return

    for site in sites
      domains = getlist site.domains
      for domain in domains
        if req.headers.host is domain
          bounce 'localhost', site.port
          return
   
    res = bounce.respond()
    res.writeHead 404,
      'content-type': 'text/html'
    res.end 'Invalid host'

  ret.listen port


setup = ->
  sites = datafiles.getData 'subs', {}
  for sitename, site of sites
    checkrunning site.port

  if httpbouncer? then httpbouncer.close()
  httpbouncer = makebouncer 80
  if httpsbouncer? then httpsbouncer.close()
  httpsbouncer = makebouncer 443
  try
    fs.watch 'data/subs', (ev) ->
      setup()
  catch e
    console.log 'watch file problem: ' + e.message

setup()

