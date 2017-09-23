(() => {
    'use strict';

    // N QUEENS PROBLEM ------------------------------------------------------

    // queenPuzzle :: Int -> Int -> [[Int]]
    const queenPuzzle = (nRows, nCols) =>
        nRows <= 0 ? [
            []
        ] : queenPuzzle(nRows - 1, nCols)
        .reduce((a, solution) =>
            append(a, enumFromTo(0, nCols - 1)
                .reduce((b, iCol) =>
                    safe(nRows - 1, iCol, solution) ? (
                        b.concat([solution.concat(iCol)])
                    ) : b, [])
            ), []);

    // safe : Int -> Int -> [Int] -> Bool
    const safe = (iRow, iCol, solution) => !any(
        ([sc, sr]) =>
        (iCol === sc) || (sc + sr === iCol + iRow) || (sc - sr === iCol - iRow),
        zip(solution, enumFromTo(0, iRow - 1))
    );

    // GENERIC FUNCTIONS -----------------------------------------------------

    // abs :: Num a => a -> a
    const abs = Math.abs

    // any :: (a -> Bool) -> [a] -> Bool
    const any = (f, xs) => xs.some(f);

    // (++) :: [a] -> [a] -> [a]
    const append = (xs, ys) => xs.concat(ys);

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = (n, xs) =>
        xs.reduce((a, _, i, xs) =>
            i % n ? a : a.concat([xs.slice(i, i + n)]), []);

    // concat :: [[a]] -> [a] | [String] -> String
    const concat = xs => {
        if (xs.length > 0) {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        } else return [];
    };

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // 2 or more arguments
    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat([].slice.apply(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // intercalate :: String -> [a] -> String
    const intercalate = curry((s, xs) => xs.join(s));

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f)

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map(row => row[iCol]));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // zip :: [a] -> [b] -> [(a,b)]
    const zip = (xs, ys) =>
        xs.slice(0, Math.min(xs.length, ys.length))
        .map((x, i) => [x, ys[i]]);

    // TEST ------------------------------------------------------------------
    // Ten columns of solutions to the 7*7 board

    // showSolutions :: Int -> Int -> String
    const showSolutions = (nCols, nBoardSize) =>
        intercalate('\n\n', map(unlines,
            map(col => map(intercalate("  "), transpose(map(rows =>
                    map(r => concat(concatMap(c =>
                        c === r ? '♛' : '.',
                        enumFromTo(1, rows.length))), rows), col))),
                chunksOf(nCols, queenPuzzle(nBoardSize, nBoardSize))
            )));

    return showSolutions(10, 7);
})();
