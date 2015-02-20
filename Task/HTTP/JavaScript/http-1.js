var req = new XMLHTTPRequest();
req.onload = function() {
  console.log(this.responseText);
};

req.open('get', 'http://rosettacode.org', true);
req.send()
