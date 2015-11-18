(function () {
  return chain(

    rng(1, 100),

    function (x) {
      var root = Math.sqrt(x);

      return root === Math.floor(root) ? inject(x) : fail();
    }
  );


  /*************************************************************/

  // monadic Bind/chain for lists
  function chain(xs, f) {
    return [].concat.apply([], xs.map(f));
  }

  // monadic Return/inject for lists
  function inject(x) { return [x]; }

  // monadic Fail for lists
  function fail() { return []; }

  // rng(1, 20) --> [1..20]
  function rng(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }

})();
