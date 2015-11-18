(function(n) {

  // USING A LIST MONAD DIRECTLY, WITHOUT LIST COMPREHENSION NOTATION

  return mb( rng(1,     n), function(x) {
  return mb( rng(1 + x, n), function(y) {
  return mb( rng(1 + y, n), function(z) {

  return ( x * x + y * y === z * z ) ? mReturn([x, y, z]) : [];

  })})});

  /******************************************************************/

  // Monadic bind (chain) for lists
  function mb(xs, f) {
    return [].concat.apply([], xs.map(f));
  }

  // Monadic return (inject) for lists
  function mReturn(a) {
    return [a];
  }

  function rng(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(
      function (x, i) { return m + i; }
    );
  }

})(100);
