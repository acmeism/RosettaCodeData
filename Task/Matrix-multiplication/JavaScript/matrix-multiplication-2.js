(function () {
    'use strict';

    // matrixMultiply:: [[n]] -> [[n]] -> [[n]]
    function matrixMultiply(a, b) {
        var bCols = transpose(b);

        return a.map(function (aRow) {
            return bCols.map(function (bCol) {
                return dotProduct(aRow, bCol);
            });
        });
    }

    // [[n]] -> [[n]] -> [[n]]
    function dotProduct(xs, ys) {
        return sum(zipWith(product, xs, ys));
    }

    return matrixMultiply(
        [[-1,  1,  4],
         [ 6, -4,  2],
         [-3,  5,  0],
         [ 3,  7, -2]],

        [[-1,  1,  4,  8],
         [ 6,  9, 10,  2],
         [11, -4,  5, -3]]
    );

    // --> [[51, -8, 26, -18], [-8, -38, -6, 34],
    //        [33, 42, 38, -14], [17, 74, 72, 44]]


    // GENERIC LIBRARY FUNCTIONS

    // (a -> b -> c) -> [a] -> [b] -> [c]
    function zipWith(f, xs, ys) {
        return xs.length === ys.length ? (
            xs.map(function (x, i) {
                return f(x, ys[i]);
            })
        ) : undefined;
    }

    // [[a]] -> [[a]]
    function transpose(lst) {
        return lst[0].map(function (_, iCol) {
            return lst.map(function (row) {
                return row[iCol];
            });
        });
    }

    // sum :: (Num a) => [a] -> a
    function sum(xs) {
        return xs.reduce(function (a, x) {
            return a + x;
        }, 0);
    }

    // product :: n -> n -> n
    function product(a, b) {
        return a * b;
    }

})();
