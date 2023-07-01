(() => {
    'use strict';

    const main = () =>
        unlines(
            map(mayanFramed,
                [4005, 8017, 326205, 886205, 1081439556, 1000000, 1000000000]
            )
        );

    // MAYAN NUMBERS --------------------------------------

    // mayanFramed :: Int -> String
    const mayanFramed = n =>
        '\nMayan ' + n.toString() + ':\n\n' +
        wikiTable({
            style: 'text-align:center; background-color:#F0EDDE; ' +
            'color:#605B4B; border:2px solid silver',
            colwidth: '3em'
        })(
            mayanGlyph(n)
        );

    // mayanGlyph :: Int -> [[String]]
    const mayanGlyph = n =>
        filter(any(compose(not, isNull)),
            transpose(leftPadded(
                showIntAtBase(20, mayanDigit, n, [])
            ))
        );

    // mayanDigit :: Int -> [String]
    const mayanDigit = n =>
        0 !== n ? cons(
            replicateString(rem(n, 5), '●'),
            replicate(quot(n, 5), '━━')
        ) : ['Θ'];

    // FORMATTING -----------------------------------------

    // wikiTable :: Dict -> [[a]] -> String
    const wikiTable = opts => rows => {
        const colWidth = () =>
            'colwidth' in opts ? (
                '|style="width:' + opts.colwidth + ';"'
            ) : '';
        return 0 < rows.length ? (
            '{| ' + ['class', 'style'].reduce(
                (a, k) => k in opts ? (
                    a + k + '="' + opts[k] + '" '
                ) : a, ''
            ) + '\n' + rows.map(
                (row, i) => row.map(
                    x => (0 === i ? (
                        colWidth() + '| '
                    ) : '|') + (x.toString() || ' ')
                ).join('\n')
            ).join('\n|-\n') + '\n|}\n\n'
        ) : '';
    };

    // leftPadded :: [[String]] -> [[String]]
    const leftPadded = xs => {
        const w = maximum(map(length, xs));
        return map(
            x => replicate(w - x.length, '').concat(x),
            xs
        );
    };

    // GENERIC FUNCTIONS ----------------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // any :: (a -> Bool) -> [a] -> Bool
    const any = p => xs => xs.some(p);

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (f, g) => x => f(g(x));

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.reduce((a, x) => a.concat(f(x)), []);

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) =>
        Array.isArray(xs) ? (
            [x].concat(xs)
        ) : 'GeneratorFunction' !== xs.constructor.constructor.name ? (
            x + xs
        ) : ( // Existing generator wrapped with one additional element
            function*() {
                yield x;
                let nxt = xs.next()
                while (!nxt.done) {
                    yield nxt.value;
                    nxt = xs.next();
                }
            }
        )();

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // foldl1 :: (a -> a -> a) -> [a] -> a
    const foldl1 = (f, xs) =>
        1 < xs.length ? xs.slice(1)
        .reduce(f, xs[0]) : xs[0];

    // isNull :: [a] -> Bool
    // isNull :: String -> Bool
    const isNull = xs =>
        Array.isArray(xs) || ('string' === typeof xs) ? (
            1 > xs.length
        ) : undefined;

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // maximum :: Ord a => [a] -> a
    const maximum = xs =>
        0 < xs.length ? (
            foldl1((a, x) => x > a ? x : a, xs)
        ) : undefined;

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

    // not :: Bool -> Bool
    const not = b => !b;

    // quot :: Int -> Int -> Int
    const quot = (n, m) => Math.floor(n / m);

    // quotRem :: Int -> Int -> (Int, Int)
    const quotRem = (m, n) =>
        Tuple(Math.floor(m / n), m % n);

    // rem :: Int -> Int -> Int
    const rem = (n, m) => n % m;

    // replicate :: Int -> a -> [a]
    const replicate = (n, x) =>
        Array.from({
            length: n
        }, () => x);

    // replicateString :: Int -> String -> String
    const replicateString = (n, s) => s.repeat(n);

    // showIntAtBase :: Int -> (Int -> [String])
    //               -> Int -> [[String]] -> [[String]]
    const showIntAtBase = (base, toStr, n, rs) => {
        const go = ([n, d], r) => {
            const r_ = cons(toStr(d), r);
            return 0 !== n ? (
                go(Array.from(quotRem(n, base)), r_)
            ) : r_;
        };
        return go(Array.from(quotRem(n, base)), rs);
    };

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

    // MAIN ---
    return main();
})();
