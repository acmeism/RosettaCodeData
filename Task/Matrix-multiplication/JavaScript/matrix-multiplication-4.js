((() => {
    "use strict";

    // -------------- MATRIX MULTIPLICATION --------------

    // matrixMultiply :: Num a => [[a]] -> [[a]] -> [[a]]
    const matrixMultiply = a =>
        b => {
            const cols = transpose(b);

            return a.map(
                compose(
                    f => cols.map(f),
                    dotProduct
                )
            );
        };


    // ---------------------- TEST -----------------------
    const main = () =>
        JSON.stringify(matrixMultiply(
            [
                [-1, 1, 4],
                [6, -4, 2],
                [-3, 5, 0],
                [3, 7, -2]
            ]
        )([
            [-1, 1, 4, 8],
            [6, 9, 10, 2],
            [11, -4, 5, -3]
        ]));


    // --------------------- GENERIC ---------------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // dotProduct :: Num a => [[a]] -> [[a]] -> [[a]]
    const dotProduct = xs =>
        // Sum of the products of the corresponding
        // values in two lists of the same length.
        compose(sum, zipWith(mul)(xs));


    // mul :: Num a => a -> a -> a
    const mul = a =>
        b => a * b;


    // sum :: (Num a) => [a] -> a
    const sum = xs =>
        xs.reduce((a, x) => a + x, 0);


    // transpose :: [[a]] -> [[a]]
    const transpose = rows =>
        // The columns of the input transposed
        // into new rows.
        // Simpler version of transpose, assuming input
        // rows of even length.
        Boolean(rows.length) ? rows[0].map(
            (_, i) => rows.flatMap(
                v => v[i]
            )
        ) : [];


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        ).slice(
            0, Math.min(xs.length, ys.length)
        );

    // MAIN ---
    return main();
}))();
