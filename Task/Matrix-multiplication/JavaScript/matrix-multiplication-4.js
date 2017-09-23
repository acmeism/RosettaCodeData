((() => {
    'use strict';

    // matrixMultiply :: Num a => [[a]] -> [[a]] -> [[a]]
    const matrixMultiply = (a, b) => {
        const bCols = transpose(b);
        return a.map(aRow => bCols.map(bCol => dotProduct(aRow, bCol)));
    }

    // dotProduct :: Num a => [[a]] -> [[a]] -> [[a]]
    const dotProduct = (xs, ys) => sum(zipWith(product, xs, ys));


    // GENERIC

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) =>
        xs.length === ys.length ? (
            xs.map((x, i) => f(x, ys[i]))
        ) : undefined;

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map(row => row[iCol]));

    // sum :: (Num a) => [a] -> a
    const sum = xs =>
        xs.reduce((a, x) => a + x, 0);

    // product :: Num a => a -> a -> a
    const product = (a, b) => a * b;


    // TEST
    return matrixMultiply(
        [
            [-1, 1, 4],
            [6, -4, 2],
            [-3, 5, 0],
            [3, 7, -2]
        ],

        [
            [-1, 1, 4, 8],
            [6, 9, 10, 2],
            [11, -4, 5, -3]
        ]
    );

    // --> [[51, -8, 26, -18], [-8, -38, -6, 34],
    //        [33, 42, 38, -14], [17, 74, 72, 44]]
}))();
