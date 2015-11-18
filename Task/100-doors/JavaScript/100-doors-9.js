(function () {

  return rng(1, 100).filter(
    function (x) {
      var root = Math.sqrt(x);

      return root === Math.floor(root);
    }
  );

  // rng(1, 20) --> [1..20]
  function rng(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }

})();
