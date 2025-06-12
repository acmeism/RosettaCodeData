var nsort = function(input) {
  var e = function(s) {
    return (' ' + s + ' ').replace(/[\s]+/g, ' ').toLowerCase().replace(/[\d]+/, function(d) {
      d = '' + 1e20 + d;
      return d.substring(d.length - 20);
    });
  };
  return input.sort(function(a, b) {
    return e(a).localeCompare(e(b));
  });
};

console.log(nsort([
  "file10.txt",
  "\nfile9.txt",
  "File11.TXT",
  "file12.txt"
]));
// -> ['\nfile9.txt', 'file10.txt', 'File11.TXT', 'file12.txt']
