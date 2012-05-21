(function() {
  var createCookie, login;

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

  login = function() {};

  $(function() {
    $.get('sites', function(sites) {
      var port, site, str, _i, _len;
      str = '';
      port = 3030;
      for (_i = 0, _len = sites.length; _i < _len; _i++) {
        site = sites[_i];
        str += "<li>" + site.name + " : " + site.port + "</li>";
        port = Math.max(site.port, port);
      }
      $('#sites').html(str);
      return port++;
    });
    return $('#port').val(port);
  });

}).call(this);
