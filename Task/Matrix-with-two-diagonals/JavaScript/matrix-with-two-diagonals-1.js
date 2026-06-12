(() => {
    "use strict";

    // ------------ MATRIX WITH TWO DIAGONALS ------------

    // doubleDiagonal :: Int -> [[Int]]
    const doubleDiagonal = n => {
        // A square matrix of dimension n with ones
        // along both diagonals, and zeros elsewhere.
        const xs = enumFromTo(1)(n);

        return xs.map(
            y => xs.map(
                x => Number(
                    [y, 1 + n - y].includes(x)
                )
            )
        );
    };


    // ---------------------- TEST -----------------------
    const main = () => [7, 8].map(
        n => showMatrix(
            doubleDiagonal(n)
        )
    ).join("\n\n");


    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // showMatrix :: [[a]] -> String
    const showMatrix = rows =>
        // String representation of a matrix.
        rows.map(
            row => row.map(String).join(" ")
        ).join("\n");


    // MAIN --
    return main();
})();
