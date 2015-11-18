// Monadic bind (chain) for lists
function chain(xs, f) {
  return [].concat.apply([], xs.map(f));
}

// [m..n]
function range(m, n) {
  return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
    return m + i;
  });
}

function factors_naive(n) {
  return chain( range(1, n), function (x) {       // monadic chain/bind
    return n % x ? [] : [x];                      // monadic fail or inject/return
  });
}

factors_naive(6)
