// Functions as values of a variable
var cube = function(x) {
  return Math.pow(x, 3);
};
var cuberoot = function(x) {
  return Math.pow(x, 1/3);
};

// Higher order function
var compose = function (f, g) {
  return function (x) {
    return f(g(x));
  };
};

// Storing functions in a array
var fun = [Math.sin, Math.cos, cube];
var inv = [Math.asin, Math.acos, cuberoot];

for (var i = 0; i < 3; i++) {
  // Applying the composition to 0.5
  console.log(compose(inv[i], fun[i])(0.5));
}
