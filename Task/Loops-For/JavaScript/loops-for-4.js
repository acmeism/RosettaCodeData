console.log(
  range(5).reduce(
    function (a, n) {
      return a + Array(n + 1).join('*') + '\n';
    }, ''
  )
);
