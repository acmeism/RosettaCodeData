(function (nFrom, nTo) {

  // MONADIC CHAIN (bind) IN LIEU OF FILTER
  // ( monadic return for lists is just lambda x -> [x] )

  return chain(
    rng(nFrom, nTo),

    function mPerfect(n) {
      return (chain(
        rng(1, Math.floor(Math.sqrt(n))),
        function (y) {
          return (n % y) === 0 && n > 1 ? [y, n / y] : [];
        }
      ).reduce(function (a, x) {
        return a + x;
      }, 0) / 2 === n) ? [n] : [];
    }

  );

  /******************************************************************/

  // Monadic bind (chain) for lists
  function chain(xs, f) {
    return [].concat.apply([], xs.map(f));
  }

  function rng(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }

})(1, 10000);
