(() => {
    'use strict';

    // MISSING PERMUTATION ---------------------------------------------------

    // missingPermutation :: [String] -> String
    const missingPermutation = xs =>
        map(
            // Rarest letter,
            compose([
                sort,
                group,
                curry(minimumBy)(comparing(length)),
                head
            ]),

            // in each column.
            transpose(map(stringChars, xs))
        )
        .join('');


    // GENERIC FUNCTIONAL PRIMITIVES -----------------------------------------

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map(row => row[iCol]));

    // sort :: Ord a => [a] -> [a]
    const sort = xs => xs.sort();

    // group :: Eq a => [a] -> [[a]]
    const group = xs => groupBy((a, b) => a === b, xs);

    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = (f, xs) => {
        const dct = xs.slice(1)
            .reduce((a, x) => {
                const
                    h = a.active.length > 0 ? a.active[0] : undefined,
                    blnGroup = h !== undefined && f(h, x);

                return {
                    active: blnGroup ? a.active.concat(x) : [x],
                    sofar: blnGroup ? a.sofar : a.sofar.concat([a.active])
                };
            }, {
                active: xs.length > 0 ? [xs[0]] : [],
                sofar: []
            });
        return dct.sofar.concat(dct.active.length > 0 ? [dct.active] : []);
    };

    // length :: [a] -> Int
    const length = xs => xs.length;

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : a > b ? 1 : 0
        };

    // minimumBy :: (a -> a -> Ordering) -> [a] -> a
    const minimumBy = (f, xs) =>
        xs.reduce((a, x) => a === undefined ? x : (
            f(x, a) < 0 ? x : a
        ), undefined);

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f)

    // compose :: [(a -> a)] -> (a -> a)
    const compose = fs => x => fs.reduce((a, f) => f(a), x);

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // stringChars :: String -> [Char]
    const stringChars = s => s.split('');


    // TEST ------------------------------------------------------------------

    return missingPermutation(["ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD",
        "ADCB", "CDAB", "DABC", "BCAD", "CADB", "CDBA", "CBAD", "ABDC", "ADBC",
        "BDCA", "DCBA", "BACD", "BADC", "BDAC", "CBDA", "DBCA", "DCAB"
    ]);

    // -> "DBAC"
})();
