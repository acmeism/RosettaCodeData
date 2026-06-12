var http = require('http');
var options = {
  host: 'rosettacode.org',
  path: '/favicon.ico'
};
callback = function(response) {
  var str = '';
  response.on('data', function (chunk) {
    str += chunk;
  });
  response.on('end', function () {
    console.log(new Buffer(str).toString('base64'));//Base64 encoding right here.
  });
}
