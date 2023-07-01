(function (n) {

    // Read range of values into a series of 'diagonal rows'
    // for a square of given dimension,
    // starting at diagonal row i.
    //  [
    //   [0],
    //   [1, 2],
    //   [3, 4, 5],
    //   [6, 7, 8, 9],
    //   [10, 11, 12, 13, 14],
    //   [15, 16, 17, 18],
    //   [19, 20, 21],
    //   [22, 23],
    //   [24]
    //  ]

    // diagonals :: n -> [[n]]
      function diagonals(n) {
          function diags(xs, iCol, iRow) {
              if (iCol < xs.length) {
                  var xxs = splitAt(iCol, xs);

                  return [xxs[0]].concat(diags(
                      xxs[1],
                      (iCol + (iRow < n ? 1 : -1)),
                      iRow + 1
                  ));
              } else return [xs];
          }

          return diags(range(0, n * n - 1), 1, 1);
      }



    // Recursively read off n heads from the diagonals (as rows)
    // n -> [[n]] -> [[n]]
    function nHeads(n, lst) {
        var zipEdge = lst.slice(0, n);

        return lst.length ? [zipEdge.map(function (x) {
            return x[0];
        })].concat(nHeads(n, [].concat.apply([], zipEdge.map(function (
                x) {
                return x.length > 1 ? [x.slice(1)] : [];
            }))
            .concat(lst.slice(n)))) : [];
    }

    // range(intFrom, intTo, optional intStep)
    // Int -> Int -> Maybe Int -> [Int]
    function range(m, n, delta) {
        var d = delta || 1,
            blnUp = n > m,
            lng = Math.floor((blnUp ? n - m : m - n) / d) + 1,
            a = Array(lng),
            i = lng;

        if (blnUp)
            while (i--) a[i] = (d * i) + m;
        else
            while (i--) a[i] = m - (d * i);
        return a;
    }

    // splitAt :: Int -> [a] -> ([a],[a])
    function splitAt(n, xs) {
        return [xs.slice(0, n), xs.slice(n)];
    }

    // Recursively take n heads from the alternately reversed diagonals

    //  [                                            [
    //   [0],           ->    [0, 1, 5, 6, 14] and:
    //   [1, 2],                                       [2],
    //   [5, 4, 3],                                    [4, 3],
    //   [6, 7, 8, 9],                                 [7, 8, 9],
    //   [14, 13, 12, 11, 10],                         [13, 12, 11, 10],
    //   [15, 16, 17, 18],                             [15, 16, 17, 18],
    //   [21, 20, 19],                                 [21, 20, 19],
    //   [22, 23],                                     [22, 23],
    //   [24]                                          [24]
    // ]                                             ]
    //
    //    In the next recursion with the remnant on the right, the next
    //    5 heads will be [2, 4, 7, 13, 15] - the second row of our zig zag matrix.
    //    (and so forth)


    return nHeads(n, diagonals(n)
        .map(function (x, i) {
            i % 2 || x.reverse();
            return x;
        }));

})(5);
