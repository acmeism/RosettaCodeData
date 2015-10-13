 [
    ["a", "b", "c"],
    ["A", "B", "C"],
    ["1", "2", "3"]
  ].reduce(
    function (a, e) {
      return [
          a[0] + e[0],
          a[1] + e[1],
          a[2] + e[2]
        ];
    }, ['', '', ''] // initial copy of the accumulator, passed to reduce()
  );

// --> ["aA1", "bB2", "cC3"]
