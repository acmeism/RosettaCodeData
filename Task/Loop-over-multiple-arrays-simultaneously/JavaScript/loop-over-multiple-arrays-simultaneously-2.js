var lstOut = ['', '', ''];

[["a", "b", "c"], ["A", "B", "C"], ["1", "2", "3"]].forEach(
  function (a) {
    [0, 1, 2].forEach(
      function (i) {
        // side-effect on an array outside the function
        lstOut[i] += a[i];
      }
    );
  }
);

// lstOut --> ["aA1", "bB2", "cC3"]
