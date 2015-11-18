(function () {

  function memoized(fn) {
    var dctMemo = {};

    return function (x) {
      var varValue = dctMemo[x];

      if ('u' === (typeof varValue)[0])
        dctMemo[x] = varValue = fn(x);
      return varValue;
    };
  }
  // Hailstone Sequence
  // n -> [n]
  function hailstone(n) {
    return n === 1 ? [1] : (
      [n].concat(
        hailstone(n % 2 ? n * 3 + 1 : n / 2)
      )
    )
  }

   // Derived a memoized version of the function,
  //  which can reuse previously calculated paths

  var fnCollatz = memoized(hailstone);

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
      function (a, x, i) {
        var lng = fnCollatz(x).length;

        return lng > a.l ? {
          n: i + 1,
          l: lng
        } : a

      }, {
        n: 0,
        l: 0
      }
    )
  }

  return longestBelow(100000);

})();
