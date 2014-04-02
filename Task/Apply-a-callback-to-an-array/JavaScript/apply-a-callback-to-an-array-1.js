function map(a, func) {
  var ret = [];
  for (var i = 0; i < a.length; i++) {
    ret[i] = func(a[i]);
  }
  return ret;
}

map([1, 2, 3, 4, 5], function(v) { return v * v; });
