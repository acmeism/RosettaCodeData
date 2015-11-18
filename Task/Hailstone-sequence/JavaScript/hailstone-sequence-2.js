(function () {

  // Hailstone Sequence
  // n -> [n]
  function hailstone(n) {
    return n === 1 ? [1] : (
      [n].concat(
        hailstone(n % 2 ? n * 3 + 1 : n / 2)
      )
    )
  }

  var lstCollatz27 = hailstone(27);

  return {
    length: lstCollatz27.length,
    sequence: lstCollatz27
  };

})();
