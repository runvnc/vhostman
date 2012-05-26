datafiles = require './datafiles'
bouncy = require 'bouncy'


httpbouncer = null
httpsbouncer = null


getlist = (str) ->
  ret = []
  list = str.split ','
  for item in list
    if item? and item isnt '' and item.trim().length > 1
      ret.push item.trim()
   ret

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
   
      console.log "site #{req.headers.host} not found"
  ret.listen port


setup = ->
  sites = datafiles.getData 'subs', {}
  if httpbouncer? then httpbouncer.close()
  httpbouncer = makebouncer 80
  if httpsbouncer? then httpsbouncer.close()
  httpsbouncer = makebouncer 443


setup()

