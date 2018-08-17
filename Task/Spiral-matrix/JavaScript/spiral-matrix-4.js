(() => {
    'use strict';

    // main :: () -> String
    const main = () =>
        unlines(
            map(unwords, spiral(5))
        );

    // spiral :: Int -> [[Int]]
    const spiral = n => {
        const go = (rows, cols, start) =>
            0 < rows ? [
                enumFromTo(start, start + pred(cols)),
                ...map(
                    reverse,
                    transpose(
                        go(
                            cols,
                            pred(rows),
                            start + cols
                        )
                    )
                )
            ] : [
                []
            ];
        return go(n, n, 0);
    };

    // GENERIC FUNCTIONS ----------------------------------

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs.map(f))
        })() : [];

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        m <= n ? iterateUntil(
            x => n <= x,
            x => 1 + x,
            m
        ) : [];

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        const vs = [x];
        let h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // length :: [a] -> Int
    const length = xs => xs.length;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    //  Ordering: (LT|EQ|GT):
    //  GT: 1 (or other positive n)
    //    EQ: 0
    //  LT: -1 (or other negative n)

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        0 < xs.length ? (
            xs.slice(1)
            .reduce((a, x) => 0 < f(x, a) ? x : a, xs[0])
        ) : undefined;


    // pred :: Enum a => a -> a
    const pred = x => x - 1;

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // replicate :: Int -> a -> [a]
    const replicate = (n, x) =>
        Array.from({
            length: n
        }, () => x);

    // transpose :: [[a]] -> [[a]]
    const transpose = tbl => {
        const
            gaps = replicate(
                length(maximumBy(comparing(length), tbl)), []
            ),
            rows = map(xs => xs.concat(gaps.slice(xs.length)), tbl);
        return map(
            (_, col) => concatMap(row => [row[col]], rows),
            rows[0]
        );
    };

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // MAIN ---
    return main();
})();
