(() => {
    'use strict';

    // QUICKSELECT ------------------------------------------------------------

    // quickselect :: Ord a => Int -> [a] -> a
    const quickSelect = (k, xxs) => {
        const
            [x, xs] = uncons(xxs),
            [ys, zs] = partition(v => v < x, xs),
            l = length(ys);

        return (k < l) ? (
            quickSelect(k, ys)
        ) : (k > l) ? (
            quickSelect(k - l - 1, zs)
        ) : x;
    };


    // GENERIC FUNCTIONS ------------------------------------------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // length :: [a] -> Int
    const length = xs => xs.length;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // partition :: Predicate -> List -> (Matches, nonMatches)
    // partition :: (a -> Bool) -> [a] -> ([a], [a])
    const partition = (p, xs) =>
        xs.reduce((a, x) =>
            p(x) ? [a[0].concat(x), a[1]] : [a[0], a[1].concat(x)], [
                [],
                []
            ]);

    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => xs.length ? [xs[0], xs.slice(1)] : undefined;


    // TEST -------------------------------------------------------------------
    const v = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4];

    return map(i => quickSelect(i, v), enumFromTo(0, length(v) - 1));
})();
