(function (nFrom, nTo) {

  function perfect(n) {
    var lows = range(1, Math.floor(Math.sqrt(n))).filter(function (x) {
      return (n % x) === 0;
    });

    return n > 1 && lows.concat(lows.map(function (x) {
      return n / x;
    })).reduce(function (a, x) {
      return a + x;
    }, 0) / 2 === n;
  }

  function range(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }

  return range(nFrom, nTo).filter(perfect)

})(1, 10000);
