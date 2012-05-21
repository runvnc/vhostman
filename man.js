(function() {
  var createCookie;

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

  $(function() {
    return $.get('sites', function(sites) {
      var portnum, site, str, val;
      console.log(sites);
      str = '';
      portnum = 3030;
      for (site in sites) {
        val = sites[site];
        str += "<li><button class=\"button black\">Remove</button><span class=\"site\">" + site + "</span> <span class=\"port\"> " + val[1] + "</port></li>";
        portnum = Math.max(val[1], portnum);
      }
      $('#sites').html(str);
      portnum++;
      return $('#port').val(portnum);
    });
  });

}).call(this);
