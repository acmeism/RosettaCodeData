// Javascript doesn't have built-in support for ranges
// Insted we use arrays of two elements to represent ranges
var mapRange = function(from, to, s) {
  return to[0] + (s - from[0]) * (to[1] - to[0]) / (from[1] - from[0]);
};

var range = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
for (var i = 0; i < range.length; i++) {
  range[i] = mapRange([0, 10], [-1, 0], range[i]);
}

console.log(range);
