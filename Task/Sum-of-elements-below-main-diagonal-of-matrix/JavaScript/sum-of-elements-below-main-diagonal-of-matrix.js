(() => {
    "use strict";

    // -------- LOWER TRIANGLE OF A SQUARE MATRIX --------

    // lowerTriangle :: [[a]] -> Either String [[a]]
    const lowerTriangle = matrix =>
        // Either a message, if the matrix is not square,
        // or the lower triangle of the matrix.
        isSquare(matrix) ? (
            Right(
                matrix.reduce(
                    ([n, rows], xs) => [
                        1 + n,
                        rows.concat([xs.slice(0, n)])
                    ],
                    [0, []]
                )[1]
            )
        ) : Left("Not a square matrix");


    // isSquare :: [[a]] -> Bool
    const isSquare = rows => {
        // True if the length of every row in the matrix
        // matches the number of rows in the matrix.
        const n = rows.length;

        return rows.every(x => n === x.length);
    };

    // ---------------------- TEST -----------------------
    const main = () =>
        either(
            msg => `Lower triangle undefined :: ${msg}`
        )(
            rows => sum([].concat(...rows))
        )(
            lowerTriangle([
                [1, 3, 7, 8, 10],
                [2, 4, 16, 14, 4],
                [3, 1, 9, 18, 11],
                [12, 14, 17, 18, 20],
                [7, 1, 3, 9, 5]
            ])
        );

    // --------------------- GENERIC ---------------------

    // Left :: a -> Either a b
    const Left = x => ({
        type: "Either",
        Left: x
    });


    // Right :: b -> Either a b
    const Right = x => ({
        type: "Either",
        Right: x
    });


    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = fl =>
        // Application of the function fl to the
        // contents of any Left value in e, or
        // the application of fr to its Right value.
        fr => e => e.Left ? (
            fl(e.Left)
        ) : fr(e.Right);


    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);

    // MAIN ---
    return main();
})();
