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


login = ->

$ ->
  $.get 'sites', (sites) ->
    str = ''
    port = 3030
    for site in sites
      str += "<li>#{site.name} : #{site.port}</li>"
      port = Math.max site.port, port
    $('#sites').html str
    port++

  $('#port').val port



