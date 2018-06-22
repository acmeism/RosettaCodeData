(() => {
    // main :: IO String
    const main = () => {

        // Strings derived from integers,
        // and split into [(initial string, final character)] tuples.

        // xs :: [(String, Char)]
        const xs = map(n => fanArrow(init, last)(n.toString()), [
            12, 127, 28, 42, 39, 113, 42, 18, 44, 118, 44, 37, 113, 124,
            37, 48, 127, 36, 29, 31, 125, 139, 131, 115, 105, 132, 104,
            123, 35, 113, 122, 42, 117, 119, 58, 109, 23, 105, 63, 27,
            44, 105, 99, 41, 128, 121, 116, 125, 32, 61, 37, 127, 29, 113,
            121, 58, 114, 126, 53, 114, 96, 25, 109, 7, 31, 141, 46, 13, 27,
            43, 117, 116, 27, 7, 68, 40, 31, 115, 124, 42, 128, 52, 71, 118,
            117, 38, 27, 106, 33, 117, 116, 111, 40, 119, 47, 105, 57, 122,
            109, 124, 115, 43, 120, 43, 27, 27, 18, 28, 48, 125, 107, 114,
            34, 133, 45, 120, 30, 127, 31, 116, 146
        ]);

        // Re-reading the initial strings as Ints
        // (empty strings read as 0),

        // ns :: [(Int, Char)]
        const ns = map(x => {
            const s = fst(x);
            return Tuple(s.length > 0 ? (
                parseInt(s, 10)
            ) : 0, snd(x));
        }, xs);

        // and sorting and grouping by these initial Ints,
        // interpreting them as data-collection bins.

        // bins :: [[(Int, Char)]]
        const bins =
            groupBy(
                (a, b) => a[0] === b[0],
                sortBy(mappendComparing([
                    [fst, true],
                    [snd, true]
                ]), ns)
            );

        // Forming bars by the ordered accumulation of
        // final characters in each bin,

        // bars :: [(Int, String)]
        const bars = map(
            fanArrow(
                x => fst(x[0]),
                x => map(snd, x)
            ),
            bins
        );

        // and obtaining a complete series, with empty bars
        // interpolated for any missing integers.

        // series :: [(Int, String)]
        const series = concat(mapAccumL(
            (a, x) => {
                const n = x[0];
                return a !== n ? (
                    Tuple(1 + n,
                        map(i => Tuple(i, []),
                            enumFromToInt(a, n - 1)
                        )
                        .concat([x])
                    )
                ) : Tuple(1 + a, [x]);
            }, 7, bars
        )[1]);

        // Assembling the series as a list of strings with
        // right-justified indices,

        // plotLines :: [String]
        const plotLines = foldr(
            (x, a) => cons(concat([
                justifyRight(2, ' ', x[0].toString()),
                ' |  ',
                unwords(x[1])
            ]), a), [],
            series
        );

        // and passing these over to IO as a single
        // newline-delimited string.

        return unlines(plotLines);
    };

    // GENERIC FUNCTIONS -----------------------------------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b
    });

    // compare :: a -> a -> Ordering
    const compare = (a, b) => a < b ? -1 : (a > b ? 1 : 0);

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        xs.length > 0 ? (() => {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        })() : [];

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x, ...xs];

    // enumFromToInt :: Int -> Int -> [Int]
    const enumFromToInt = (m, n) =>
        n >= m ? Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i) : [];

    // Compose a function from a simple value to a tuple of
    // the separate outputs of two different functions
    // fanArrow (&&&) :: (a -> b) -> (a -> c) -> (a -> (b, c))
    const fanArrow = (f, g) => x => Tuple(f(x), g(x));

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // Note that that the Haskell signature of foldr is different from that of
    // foldl - the positions of accumulator and current value are reversed
    // foldr :: (a -> b -> b) -> b -> [a] -> b
    const foldr = (f, a, xs) => xs.reduceRight(flip(f), a);

    // fst :: (a, b) -> a
    const fst = tpl => tpl.type !== 'Tuple' ? undefined : tpl[0];

    // Typical usage: groupBy(on(eq, f), xs)
    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = (f, xs) => {
        const dct = xs.slice(1)
            .reduce((a, x) => {
                const h = a.active.length > 0 ? a.active[0] : undefined;
                return h !== undefined && f(h, x) ? {
                    active: a.active.concat([x]),
                    sofar: a.sofar
                } : {
                    active: [x],
                    sofar: a.sofar.concat([a.active])
                };
            }, {
                active: xs.length > 0 ? [xs[0]] : [],
                sofar: []
            });
        return dct.sofar.concat(dct.active.length > 0 ? [dct.active] : []);
    };

    // init :: [a] -> [a]
    const init = xs => xs.length > 0 ? xs.slice(0, -1) : undefined;

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = (n, cFiller, strText) =>
        n > strText.length ? (
            (cFiller.repeat(n) + strText)
            .slice(-n)
        ) : strText;

    // last :: [a] -> a
    const last = xs => xs.length ? xs.slice(-1)[0] : undefined;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    const mapAccumL = (f, acc, xs) =>
        xs.reduce((a, x, i) => {
            const pair = f(a[0], x, i);
            return Tuple(pair[0], a[1].concat(pair[1]));
        }, Tuple(acc, []));

    // mappendComparing :: [((a -> b), Bool)] -> (a -> a -> Ordering)
    const mappendComparing = fboolPairs =>
        (x, y) => fboolPairs.reduce(
            (ordr, fb) => {
                const f = fb[0];
                return ordr !== 0 ? (
                    ordr
                ) : fb[1] ? (
                    compare(f(x), f(y))
                ) : compare(f(y), f(x));
            }, 0
        );

    // snd :: (a, b) -> b
    const snd = tpl => tpl.type !== 'Tuple' ? undefined : tpl[1];

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) =>
        xs.slice()
        .sort(f);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // MAIN ------------------------------------------------------------------
    return main();
})();
