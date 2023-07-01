var square = { |x| x * x };
var map = { |fn, xs|
  all {: fn.value(x), x <- xs };
};
map.value(square, [1, 2, 3]);
