(() => {
    'use strict';

    // rangeFormat :: [Int] -> String
    const rangeFormat = xs =>
        splitBy((a, b) => b - a > 1, xs)
        .map(rangeString)
        .join(',');

    // rangeString :: [Int] -> String
    const rangeString = xs =>
        xs.length > 2 ? (
            [head(xs), last(xs)].map(show)
            .join('-')
        ) : xs.join(',')


    // GENERIC FUNCTIONS

    // Splitting not on a delimiter, but whenever the relationship between
    // two consecutive items matches a supplied predicate function

    // splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const splitBy = (f, xs) => {
        if (xs.length < 2) return [xs];
        const
            h = head(xs),
            lstParts = xs.slice(1)
            .reduce(([acc, active, prev], x) =>
                f(prev, x) ? (
                    [acc.concat([active]), [x], x]
                ) : [acc, active.concat(x), x], [
                    [],
                    [h],
                    h
                ]);
        return lstParts[0].concat([lstParts[1]]);
    };

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // last :: [a] -> a
    const last = xs => xs.length ? xs.slice(-1)[0] : undefined;

    // show :: a -> String
    const show = x => JSON.stringify(x);

    // TEST
    return rangeFormat([0, 1, 2, 4, 6, 7, 8, 11, 12, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
        37, 38, 39
    ]);
})();
