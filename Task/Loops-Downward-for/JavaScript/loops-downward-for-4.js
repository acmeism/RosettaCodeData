function range(m, n) {
  return Array.apply(null, Array(n - m + 1)).map(
    function (x, i) {
      return m + i;
    }
  );
}

range(0, 10).reverse().forEach(
  function (x) {
    console.log(x);
  }
);
