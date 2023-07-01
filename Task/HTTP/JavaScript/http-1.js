var req = new XMLHttpRequest();
req.onload = function() {
  console.log(this.responseText);
};

req.open('get', 'http://rosettacode.org', true);
req.send()
