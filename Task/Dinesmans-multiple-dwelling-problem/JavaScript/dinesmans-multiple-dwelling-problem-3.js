(() => {
    'use strict';

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // and :: [Bool] -> Bool
    const and = xs => {
        let i = xs.length;
        while (i--)
            if (!xs[i]) return false;
        return true;
    }

    // permutations :: [a] -> [[a]]
    const permutations = xs =>
        xs.length ? concatMap(x => concatMap(ys => [
                [x].concat(ys)
            ],
            permutations(delete_(x, xs))), xs) : [
            []
        ];

    // delete :: a -> [a] -> [a]
    const delete_ = (x, xs) =>
        deleteBy((a, b) => a === b, x, xs);

    // deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
    const deleteBy = (f, x, xs) =>
        xs.reduce((a, y) => f(x, y) ? a : a.concat(y), []);

    // PROBLEM DECLARATION

    const floors = range(1, 5);

    return concatMap(([c, b, f, m, s]) =>
        and([ // CONDITIONS (assuming full occupancy, no cohabitation)
            b !== 5, c !== 1, f !== 1, f !== 5,
            m > c, Math.abs(s - f) > 1, Math.abs(c - f) > 1
        ]) ? [{
            Baker: b,
            Cooper: c,
            Fletcher: f,
            Miller: m,
            Smith: s
        }] : [], permutations(floors));

    // --> [{"Baker":3, "Cooper":2, "Fletcher":4, "Miller":5, "Smith":1}]
})();
