(() => {
    "use strict";

    // ------------------ MOSAIC MATRIX ------------------

    // mosaic :: Int -> [[Int]]
    const mosaic = n => matrix(n)(n)(
        row => col => (1 + row + col) % 2
    );


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        // Matrices of dimensions 7 and 8.
        [7, 8].map(
            compose(
                showMatrix(String),
                mosaic
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


    // showMatrix :: (a -> String) -> [[a]] -> String
    const showMatrix = fShow =>
        rows => 0 < rows.length ? (() => {
            const w = fShow(Math.max(...rows.flat())).length;

            return rows.map(
                cells => cells.map(
                    x => fShow(x).padStart(w, " ")
                ).join(" ")
            ).join("\n");
        })() : "";

    // main
    return main();
})();
