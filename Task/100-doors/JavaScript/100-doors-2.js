(function () {
  return chain(

    // 100 passes ...
    rng(0, 99).reduce(function (a, _, i) {
      return a.slice(0, i).concat(
        a.slice(i).map(function (v, j) {
          return (i + j + 1) % (i + 1) ? v : {
            door: v.door,
            open: !v.open
          };
        })
      )
    },

    // 100 closed doors at start
    Array.apply(null, Array(100)).map(function (x, i) {
      return {
        open: false,
        door: i + 1
      };
    })),

    // Filtering by chained function
    function (door) {
      return door.open ? [door] : [];
    }
  )

  // Monadic bind (chain) for lists
  function chain(xs, f) {
    return [].concat.apply([], xs.map(f));
  }

  // range(1, 20) --> [1..20]
  function rng(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }
})();
