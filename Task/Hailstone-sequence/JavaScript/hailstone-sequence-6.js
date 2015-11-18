(function (n) {

  var dctMemo = {};

  // Length only of hailstone sequence
  // n -> n
  function collatzLength(n) {
    var i = 1,
      a = n,
      lng;

    while (a !== 1) {
      lng = dctMemo[a];
      if ('u' === (typeof lng)[0]) {
        a = (a % 2 ? 3 * a + 1 : a / 2);
        i++;
      } else return lng + i - 1;
    }
    return i;
  }

  // Iterative version of range
  // [m..n]
  function range(m, n) {
    var a = Array(n - m + 1),
      i = n + 1;
    while (i--) a[i - 1] = i;
    return a;
  }

  // Fold/reduce over an array to find the maximum length
  function longestBelow(n) {

    return range(1, n).reduce(
      function (a, x) {

        var lng = dctMemo[x] || (dctMemo[x] = collatzLength(x));

        return lng > a.l ? {
          n: x,
          l: lng
        } : a

      }, {
        n: 0,
        l: 0
      }
    )
  }

  return [100000, 1000000, 10000000].map(longestBelow);

})();
