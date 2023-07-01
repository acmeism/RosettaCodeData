(function () {
  'use strict';

  // [n] -> [[[n]]]
  function partitions(a1, a2, a3) {
    var n = a1 + a2 + a3;

    return combos(range(1, n), n, [a1, a2, a3]);
  }

  function combos(s, n, xxs) {
    if (!xxs.length) return [[]];

    var x = xxs[0],
        xs = xxs.slice(1);

    return mb( choose(s, n, x),                 function (l_rest) {
    return mb( combos(l_rest[1], (n - x), xs),  function (r) {
      // monadic return/injection requires 1 additional
      // layer of list nesting:
      return [ [l_rest[0]].concat(r) ];

    })});
  }

  function choose(aa, n, m) {
    if (!m) return [[[], aa]];

    var a = aa[0],
        as = aa.slice(1);

    return n === m ? (
      [[aa, []]]
    ) : (
      choose(as, n - 1, m - 1).map(function (xy) {
        return [[a].concat(xy[0]), xy[1]];
      }).concat(choose(as, n - 1, m).map(function (xy) {
        return [xy[0], [a].concat(xy[1])];
      }))
    );
  }

  // GENERIC

  // Monadic bind (chain) for lists
  function mb(xs, f) {
    return [].concat.apply([], xs.map(f));
  }

  // [m..n]
  function range(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }

  // EXAMPLE

  return partitions(2, 0, 2);

})();
