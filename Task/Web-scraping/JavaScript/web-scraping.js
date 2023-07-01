var req = new XMLHttpRequest();
req.onload = function () {
  var re = /[JFMASOND].+ UTC/; //beginning of month name to 'UTC'
  console.log(this.responseText.match(re)[0]);
};
req.open('GET', 'http://tycho.usno.navy.mil/cgi-bin/timer.pl', true);
req.send();
