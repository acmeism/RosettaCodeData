(() => {
    "use strict";

    // ------------ MATRIX WITH TWO DIAGONALS ------------

    // bothDiagonals :: Int -> [[Int]]
    const bothDiagonals = n =>
        matrix(n)(n)(
            y => x => Number(
                [y, (n - y) - 1].includes(x)
            )
        );


    // ---------------------- TEST -----------------------
    const main = () => [7, 8].map(
        compose(
            showMatrix,
            bothDiagonals
        )
    ).join("\n\n");


    // --------------------- GENERIC ---------------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // matrix Int -> Int -> (Int -> Int -> a) -> [[a]]
    const matrix = nRows => nCols =>
        // A matrix of a given number of columns and rows,
        // in which each value is a given function of its
        // (zero-based) column and row indices.
        f => Array.from({
            length: nRows
        }, (_, iRow) => Array.from({
            length: nCols
        }, (__, iCol) => f(iRow)(iCol)));


    // showMatrix :: [[a]] -> String
    const showMatrix = rows =>
        // String representation of a matrix.
        rows.map(
            row => row.map(String).join(" ")
        ).join("\n");

    // MAIN ---
    return main();
})();
