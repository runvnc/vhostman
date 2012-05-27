(function() {
  var createCookie, refreshsites;

  createCookie = function(name, value, days) {
    var date, expires;
    if (days) {
      date = new Date();
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toGMTString();
    } else {
      expires = "";
    }
    return document.cookie = name + "=" + value + expires + "; path=/";
  };

  refreshsites = function() {
    return $.get('sites', function(sites) {
      var portnum, site, sitelink, str, val;
      console.log(sites);
      str = '';
      portnum = 3030;
      for (site in sites) {
        val = sites[site];
        sitelink = "<a href=\"http://" + site + "\">" + site + "</a>";
        str += "<li><button class=\"button black\">Remove</button><span class=\"site\">" + sitelink + "</span><input type=\"text\" name=\"custom\" class=\"custom\" placeholder=\"domain(s), e.g. mysite1.com, other1.com\" value=\"" + val.domains + "\"/><button class=\"button black saveit\">Save</button></li>";
        portnum = Math.max(val.port, portnum);
      }
      $('#sites').html(str);
      portnum++;
      $('#port').val(portnum);
      $('.saveit').off('click');
      return $('.saveit').on('click', function() {
        var domains;
        site = $(this).parent().find('.site').text();
        domains = $(this).parent().find('.custom').val();
        return $.post('/updatesite', {
          site: site,
          domains: domains
        }, function(res) {
          return refreshsites();
        });
      });
    });
  };

  $(function() {
    $.get('config', function(config) {
      window.config = config;
      $('#domain').text(config.domain);
      return $('#addnew').click(function() {
        var obj;
        obj = {
          site: $('#site').val() + '.' + config.domain,
          port: $('#port').val()
        };
        return $.post('/addsite', obj, function(res) {
          return window.location.reload();
        });
      });
    });
    return refreshsites();
  });

}).call(this);
