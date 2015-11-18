var i, p, pascal, primerow, primes, show, _i;

pascal = function() {
  var a;
  a = [];
  return function() {
    var b, i;
    if (a.length === 0) {
      return a = [1];
    } else {
      b = (function() {
        var _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = a.length - 1; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(a[i] + a[i + 1]);
        }
        return _results;
      })();
      return a = [1].concat(b).concat([1]);
    }
  };
};

show = function(a) {
  var degree, i, sgn, show_x, str, _i, _ref;
  show_x = function(e) {
    switch (e) {
      case 0:
        return "";
      case 1:
        return "x";
      default:
        return "x^" + e;
    }
  };
  degree = a.length - 1;
  str = "(x - 1)^" + degree + " =";
  sgn = 1;
  for (i = _i = 0, _ref = a.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
    str += ' ' + (sgn > 0 ? "+" : "-") + ' ' + a[i] + show_x(degree - i);
    sgn = -sgn;
  }
  return str;
};

primerow = function(row) {
  var degree;
  degree = row.length - 1;
  return row.slice(1, degree).every(function(x) {
    return x % degree === 0;
  });
};

p = pascal();

for (i = _i = 0; _i <= 7; i = ++_i) {
  console.log(show(p()));
}

p = pascal();

p();

p();

primes = (function() {
  var _j, _results;
  _results = [];
  for (i = _j = 1; _j <= 49; i = ++_j) {
    if (primerow(p())) {
      _results.push(i + 1);
    }
  }
  return _results;
})();

console.log("");

console.log("The primes upto 50 are: " + primes);
