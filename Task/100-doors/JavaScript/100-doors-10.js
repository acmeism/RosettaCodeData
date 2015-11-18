(function () {

  return rng(1, Math.sqrt(100)).map(function (x) {
    return x * x;
  });

  // rng(1, 20) --> [1..20]
  function rng(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }

})();
