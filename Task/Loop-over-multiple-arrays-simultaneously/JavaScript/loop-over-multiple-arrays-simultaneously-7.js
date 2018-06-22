(() => {
    'use strict';

    // GENERIC FUNCTIONS -----------------------------------------------------

    // concat :: [[a]] -> [a]
    const concat = xs =>
        xs.length > 0 ? (() => {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        })() : [];

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, col) => xs.map(row => row[col]));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // TEST ------------------------------------------------------------------
    const xs = [
        ['a', 'b', 'c'],
        ['A', 'B', 'C'],
        [1, 2, 3]
    ];

    return unlines(
        map(concat, transpose(xs))
    );
})();
