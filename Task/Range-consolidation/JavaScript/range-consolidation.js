(() => {
    'use strict';

    const main = () => {

        // consolidated :: [(Float, Float)] -> [(Float, Float)]
        const consolidated = xs =>
            foldl((abetc, xy) =>
                0 < abetc.length ? (() => {
                    const
                        etc = abetc.slice(1),
                        [a, b] = abetc[0],
                        [x, y] = xy;

                    return y >= b ? (
                        cons(xy, etc)
                    ) : y >= a ? (
                        cons([x, b], etc)
                    ) : cons(xy, abetc);
                })() : [xy],
                [],
                sortBy(flip(comparing(fst)),
                    map(([a, b]) => a < b ? (
                            [a, b]
                        ) : [b, a],
                        xs
                    )
                )
            );

        // TEST -------------------------------------------
        console.log(
            tabulated(
                'Range consolidations:',
                JSON.stringify,
                JSON.stringify,
                consolidated,
                [
                    [
                        [1.1, 2.2]
                    ],
                    [
                        [6.1, 7.2],
                        [7.2, 8.3]
                    ],
                    [
                        [4, 3],
                        [2, 1]
                    ],
                    [
                        [4, 3],
                        [2, 1],
                        [-1, -2],
                        [3.9, 10]
                    ],
                    [
                        [1, 3],
                        [-6, -1],
                        [-4, -5],
                        [8, 2],
                        [-6, -6]
                    ]
                ]
            )
        );
    };

    // GENERIC FUNCTIONS ----------------------------

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

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));

    // foldl :: (a -> b -> a) -> a -> [b] -> a
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = (n, cFiller, s) =>
        n > s.length ? (
            s.padStart(n, cFiller)
        ) : s;

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

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        0 < xs.length ? (
            xs.slice(1)
            .reduce((a, x) => 0 < f(x, a) ? x : a, xs[0])
        ) : undefined;

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) =>
        xs.slice()
        .sort(f);

    // tabulated :: String -> (a -> String) ->
    //                        (b -> String) ->
    //           (a -> b) -> [a] -> String
    const tabulated = (s, xShow, fxShow, f, xs) => {
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        const
            ys = map(xShow, xs),
            w = maximumBy(comparing(x => x.length), ys).length,
            rows = zipWith(
                (a, b) => justifyRight(w, ' ', a) + ' -> ' + b,
                ys,
                map(compose(fxShow, f), xs)
            );
        return s + '\n' + unlines(rows);
    };

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const
            lng = Math.min(length(xs), length(ys)),
            as = take(lng, xs),
            bs = take(lng, ys);
        return Array.from({
            length: lng
        }, (_, i) => f(as[i], bs[i], i));
    };

    // MAIN ---
    return main();
})();
