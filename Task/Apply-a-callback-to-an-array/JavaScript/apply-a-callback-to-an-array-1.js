function map(a, func) {
  for (var i in a)
    a[i] = func(a[i]);
}

var a = [1, 2, 3, 4, 5];
map(a, function(v) { return v * v; });
