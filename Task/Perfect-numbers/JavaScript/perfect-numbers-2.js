(function (nFrom, nTo) {

  function perfect(n) {
    return n === range(1, n - 1).reduce(
      function (a, x) {
        return n % x ? a : a + x;
      }, 0
    );
  }

  function range(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }

  return range(nFrom, nTo).filter(perfect);

})(1, 10000);
