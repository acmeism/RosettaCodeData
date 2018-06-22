var calcPi = function() {
  var n = 20000;
  var pi = 0;
  for (var i = 0; i < n; i++) {
    var temp = 4 / (i*2+1);
    if (i % 2 == 0) {
      pi += temp;
    }
    else {
      pi -= temp;
    }
  }
  return pi;
}
