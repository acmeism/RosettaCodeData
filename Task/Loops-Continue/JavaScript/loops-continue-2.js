function rng(n) {
  return n ? rng(n - 1).concat(n) : [];
}

console.log(
  rng(10).reduce(
    function (a, x) {
      return a + x.toString() + (x % 5 ? ', ' : '\n');
    }, ''
  )
);
