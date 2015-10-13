sum(function (x) { return 1 / (x * x) }, range(1, 1000));

function sum(fn, lstRange) {
  return lstRange.reduce(
    function (lngSum, x) {
      return lngSum + fn(x);
    }, 0
  );
}

function range(m, n) {
  return Array.apply(null, Array(n - m + 1)).map(
    function (x, i) {
      return m + i;
    }
  );
}
