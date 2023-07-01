(() => {
    'use strict';

    // doublyEvenMagicSquare :: Int -> [[Int]]
    const doublyEvenMagicSquare = n =>
        0 === n % 4 ? (() => {
            const
                sqr = n * n,
                power = Math.log2(sqr),
                scale = replicate(n / 4);
            return chunksOf(n)(
                map((x, i) => x ? 1 + i : sqr - i)(
                    isInt(power) ? truthSeries(power) : (
                        compose(
                            flatten,
                            scale,
                            map(scale),
                            chunksOf(4)
                        )(truthSeries(4))
                    )
                )
            );
        })() : undefined;

    // truthSeries :: Int -> [Bool]
    const truthSeries = n =>
        0 >= n ? (
            [true]
        ) : (() => {
            const xs = truthSeries(n - 1);
            return xs.concat(xs.map(x => !x));
        })();



    // TEST -----------------------------------------------
    const main = () =>
        // Magic squares of orders 4, 8 and 12, with
        // checks of row, column and diagonal sums.
        intercalate('\n\n')(
            map(n => {
                const
                    lines = doublyEvenMagicSquare(n),
                    sums = map(sum)(
                        lines.concat(
                            transpose(lines)
                            .concat(diagonals(lines))
                        )
                    ),
                    total = sums[0];
                return unlines([
                    "Order: " + str(n),
                    "Summing to: " + str(total),
                    "Row, column and diagonal sums checked: " +
                    str(all(eq(total))(sums)) + '\n',
                    unlines(map(compose(
                        intercalate('  '),
                        map(compose(justifyRight(3)(' '), str))
                    ))(lines))
                ]);
            })([4, 8, 12])
        );


    // GENERIC FUNCTIONS ----------------------------------

    // all :: (a -> Bool) -> [a] -> Bool
    const all = p =>
        // True if p(x) holds for every x in xs.
        xs => xs.every(p);

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n => xs =>
        enumFromThenTo(0)(n)(
            xs.length - 1
        ).reduce(
            (a, i) => a.concat([xs.slice(i, (n + i))]),
            []
        );

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);

    // diagonals :: [[a]] -> [[a], [a]]
    const diagonals = rows =>
        // Two diagonal sequences,
        // from top left and bottom left
        // respectively, of a given matrix.
        map(flip(zipWith(index))(
            enumFromTo(0)(pred(
                0 < rows.length ? (
                    rows[0].length
                ) : 0
            ))
        ))([rows, reverse(rows)]);

    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = x1 => x2 => y => {
        const d = x2 - x1;
        return Array.from({
            length: Math.floor(y - x2) / d + 2
        }, (_, i) => x1 + (d * i));
    };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m => n =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // eq (==) :: Eq a => a -> a -> Bool
    const eq = a => b => a === b;

    // flatten :: NestedList a -> [a]
    const flatten = nest => nest.flat(Infinity);

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        x => y => f(y)(x);

    // index (!!) :: [a] -> Int -> a
    const index = xs => i => xs[i];

    // intercalate :: String -> [String] -> String
    const intercalate = s =>
        xs => xs.join(s);

    // isInt :: Int -> Bool
    const isInt = x => x === Math.floor(x);

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n => cFiller => s =>
        n > s.length ? (
            s.padStart(n, cFiller)
        ) : s;

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // pred :: Enum a => a -> a
    const pred = x => x - 1;

    // replicate :: Int -> a -> [a]
    const replicate = n => x =>
        Array.from({
            length: n
        }, () => x);

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // show :: a -> String
    const show = x => JSON.stringify(x);

    // str :: a -> String
    const str = x => x.toString();

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map((row) => row[iCol]));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys =>
        xs.slice(
            0, Math.min(xs.length, ys.length)
        ).map((x, i) => f(x)(ys[i]));

    // MAIN ------------------------------------------------
    return main();
})();
