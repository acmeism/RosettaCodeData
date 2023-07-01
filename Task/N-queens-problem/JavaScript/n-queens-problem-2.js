(() => {
    "use strict";

    // ---------------- N QUEENS PROBLEM -----------------

    // queenPuzzle :: Int -> Int -> [[Int]]
    const queenPuzzle = intCols => {
        // All solutions for a given number
        // of columns and rows.
        const go = nRows =>
            nRows <= 0 ? [
                []
            ] : go(nRows - 1).reduce(
                (a, solution) => [
                    ...a, ...(
                        enumFromTo(0)(intCols - 1)
                        .reduce((b, iCol) =>
                            safe(
                                nRows - 1, iCol, solution
                            ) ? (
                                [...b, [...solution, iCol]]
                            ) : b, [])
                    )
                ], []
            );


        return go;
    };

    // safe : Int -> Int -> [Int] -> Bool
    const safe = (iRow, iCol, solution) =>
        !zip(solution)(
            enumFromTo(0)(iRow - 1)
        )
        .some(
            ([sc, sr]) => (iCol === sc) || (
                sc + sr === iCol + iRow
            ) || (sc - sr === iCol - iRow)
        );

    // ---------------------- TEST -----------------------
    // Ten columns of solutions to the 7*7 board

    // main :: IO ()
    const main = () =>
        // eslint-disable-next-line no-console
        console.log(
            showSolutions(10)(7)
        );

    // --------------------- DISPLAY ---------------------

    // showSolutions :: Int -> Int -> String
    const showSolutions = nCols =>
        // Display of solutions, in nCols columns
        // for a board of size N * N.
        n => chunksOf(nCols)(
            queenPuzzle(n)(n)
        )
        .map(xs => transpose(
                xs.map(
                    rows => rows.map(
                        r => enumFromTo(1)(rows.length)
                        .flatMap(
                            x => r === x ? (
                                "♛"
                            ) : "."
                        )
                        .join("")
                    )
                )
            )
            .map(cells => cells.join("  "))
        )
        .map(x => x.join("\n"))
        .join("\n\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n => {
        // xs split into sublists of length n.
        // The last sublist will be short if n
        // does not evenly divide the length of xs .
        const go = xs => {
            const chunk = xs.slice(0, n);

            return Boolean(chunk.length) ? [
                chunk, ...go(xs.slice(n))
            ] : [];
        };

        return go;
    };


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // transpose_ :: [[a]] -> [[a]]
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


    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs =>
        // The paired members of xs and ys, up to
        // the length of the shorter of the two lists.
        ys => Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => [xs[i], ys[i]]);

    // MAIN ---
    return main();
})();
