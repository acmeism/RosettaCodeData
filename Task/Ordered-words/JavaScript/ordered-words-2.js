var http = require('http');

http.get({
  host: 'www.puzzlers.org',
  path: '/pub/wordlists/unixdict.txt'
}, function(res) {
  var data = '';
  res.on('data', function(chunk) {
    data += chunk;
  });
  res.on('end', function() {
    var words = data.split('\n');
    var max = 0;
    var ordered = [];
    words.forEach(function(word) {
      if (word.split('').sort().join('') != word) return;
      if (word.length == max) {
        ordered.push(word);
      } else if (word.length > max) {
        ordered = [word];
        max = word.length;
      }
    });
    console.log(ordered.join(', '));
  });
});
