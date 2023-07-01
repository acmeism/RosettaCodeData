function swap(a, b) {
  var tmp = window[a];
  window[a] = window[b];
  window[b] = tmp;
}
var x = 1;
var y = 2;
swap('x', 'y');
