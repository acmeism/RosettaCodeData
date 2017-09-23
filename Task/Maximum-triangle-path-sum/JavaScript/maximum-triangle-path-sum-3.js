(function () {

  // Right fold using final element as initial accumulator
  // (a -> a -> a) -> t a -> a
  function foldr1(f, lst) {
    return lst.length > 1 ? (
      f(lst[0], foldr1(f, lst.slice(1)))
    ) : lst[0];
  }

  // function of arity 3 mapped over nth items of each of 3 lists
  // (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
  function zipWith3(f, xs, ys, zs) {
    return zs.length ? [f(xs[0], ys[0], zs[0])].concat(
      zipWith3(f, xs.slice(1), ys.slice(1), zs.slice(1))) : [];
  }

  // Evaluating from bottom up (right fold)
  // and with recursion left to right (head and first item of tail at each stage)
  return foldr1(
    function (xs, ys) {
      return zipWith3(
        function (x, y, z) {
          return x + (y < z ? z : y);
        },
        xs, ys, ys.slice(1) // item above, and larger of two below
      );
    }, [
        [55],
        [94, 48],
        [95, 30, 96],
        [77, 71, 26, 67],
        [97, 13, 76, 38, 45],
        [07, 36, 79, 16, 37, 68],
        [48, 07, 09, 18, 70, 26, 06],
        [18, 72, 79, 46, 59, 79, 29, 90],
        [20, 76, 87, 11, 32, 07, 07, 49, 18],
        [27, 83, 58, 35, 71, 11, 25, 57, 29, 85],
        [14, 64, 36, 96, 27, 11, 58, 56, 92, 18, 55],
        [02, 90, 03, 60, 48, 49, 41, 46, 33, 36, 47, 23],
        [92, 50, 48, 02, 36, 59, 42, 79, 72, 20, 82, 77, 42],
        [56, 78, 38, 80, 39, 75, 02, 71, 66, 66, 01, 03, 55, 72],
        [44, 25, 67, 84, 71, 67, 11, 61, 40, 57, 58, 89, 40, 56, 36],
        [85, 32, 25, 85, 57, 48, 84, 35, 47, 62, 17, 01, 01, 99, 89, 52],
        [06, 71, 28, 75, 94, 48, 37, 10, 23, 51, 06, 48, 53, 18, 74, 98, 15],
        [27, 02, 92, 23, 08, 71, 76, 84, 15, 52, 92, 63, 81, 10, 44, 10, 69, 93]
    ]
  )[0];

})();
