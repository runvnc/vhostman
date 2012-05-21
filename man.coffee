#man oh man
#generate a port

createCookie = (name, value, days) ->
  if days
    date = new Date()
    date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
    expires = "; expires=" + date.toGMTString()
  else
    expires = ""
  document.cookie = name + "=" + value + expires + "; path=/"


#login = ->

$ ->
  $.get 'sites', (sites) ->
    console.log sites
    str = ''
    portnum = 3030
    for site, val of sites
      str += "<li><button class=\"button black\">Remove</button><span class=\"site\">#{site}</span> <span class=\"port\"> #{val[1]}</port></li>"
      portnum = Math.max val[1], portnum
    $('#sites').html str
    portnum++
    $('#port').val portnum



