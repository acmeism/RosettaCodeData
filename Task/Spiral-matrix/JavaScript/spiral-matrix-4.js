(() => {
    "use strict";

    // ------------------ SPIRAL MATRIX ------------------

    // spiral :: Int -> [[Int]]
    const spiral = n => {
        const go = (rows, cols, start) =>
            Boolean(rows) ? [
                enumFromTo(start)(start + pred(cols)),
                ...transpose(
                    go(
                        cols,
                        pred(rows),
                        start + cols
                    )
                ).map(reverse)
            ] : [
                []
            ];

        return go(n, n, 0);
    };


    // ---------------------- TEST -----------------------
    // main :: () -> String
    const main = () => {
        const
            n = 5,
            cellWidth = 1 + `${pred(n ** 2)}`.length;

        return unlines(
            spiral(n).map(
                row => (
                    row.map(x => `${x}`
                    .padStart(cellWidth, " "))
                )
                .join("")
            )
        );
    };


    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // pred :: Enum a => a -> a
    const pred = x => x - 1;


    // reverse :: [a] -> [a]
    const reverse = xs =>
        "string" === typeof xs ? (
            xs.split("").reverse()
            .join("")
        ) : xs.slice(0).reverse();


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


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join("\n");


    // MAIN ---
    return main();
})();
