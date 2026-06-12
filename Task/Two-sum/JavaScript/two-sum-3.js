(() => {
    'use strict';

    // SUMTWO ----------------------------------------------------------------

    // sumTwo :: Int -> [Int] -> [(Int, Int)]
    function sumTwo(n, xs) {
        const ixs = zip(enumFromTo(0, length(xs) - 1), xs);
        return bind(ixs,
            ([i, x]) => bind(drop(i + 1, ixs),
                ([j, y]) => (x + y === n) ? [
                    [i, j]
                ] : []
            )
        );
    };

    // GENERIC FUNCTIONS -----------------------------------------------------

    // bind (>>=) :: [a] -> (a -> [b]) -> [b]
    const bind = (xs, f) => [].concat.apply([], xs.map(f));

    // drop :: Int -> [a] -> [a]
    const drop = (n, xs) => xs.slice(n);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // length :: [a] -> Int
    const length = xs => xs.length;

    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[0], null, x[1]] : x
        );

    // zip :: [a] -> [b] -> [(a,b)]
    const zip = (xs, ys) =>
        xs.slice(0, Math.min(xs.length, ys.length))
        .map((x, i) => [x, ys[i]]);


    // TEST ------------------------------------------------------------------
    return show(
        sumTwo(21, [0, 2, 11, 19, 90, 10])
    );
})();
