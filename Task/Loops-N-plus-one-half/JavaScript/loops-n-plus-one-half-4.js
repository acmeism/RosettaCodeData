function range(m, n) {
  return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
    return m + i;
  });
}

console.log(
  (function (nFrom, nTo) {
    var iLast = nTo - 1;

    return range(nFrom, nTo).reduce(
      function (accumulator, n, i) {
        return accumulator +
          n.toString() +

          (i < iLast ? ', ' : ''); // conditional sub-expression

      }, ''
    )
  })(1, 10)
);
