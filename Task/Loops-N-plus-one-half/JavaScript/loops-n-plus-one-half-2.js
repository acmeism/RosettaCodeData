function range(m, n) {
  return Array.apply(null, Array(n - m + 1)).map(
    function (x, i) {
      return m + i;
    }
  );
}

console.log(
  range(1, 10).join(', ')
);
