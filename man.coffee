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

refreshsites = ->
  $.get 'sites', (sites) ->
    console.log sites
    str = ''
    portnum = 3030
    for site, val of sites
      str += "<li><button class=\"button black\">Remove</button><span class=\"site\">#{site}</span><input type=\"text\" name=\"custom\" class=\"custom\" placeholder=\"domain(s), e.g. mysite1.com, other1.com\" value=\"#{val.domains}\"/><button class=\"button black saveit\">Save</button></li>"
      portnum = Math.max val[1], portnum
    $('#sites').html str
    portnum++
    $('#port').val portnum
    $('.saveit').off 'click'
    $('.saveit').on 'click', ->
      site = $(@).parent().find('.site').text()
      domains = $(@).parent().find('.custom').val()
      $.post '/updatesite', {site:site, domains:domains}, (res) ->
        refreshsites()


$ ->
  $.get 'config', (config) ->
    window.config = config
    $('#domain').text config.domain
    $('#addnew').click ->
      obj =
        site: $('#site').val() + '.' + config.domain
        port: $('#port').val()
      $.post '/addsite', obj, (res) ->
        window.location.reload()
  refreshsites()
   
