(() => {
    'use strict';

    // GENERIC FUNCTIONS ------------------------------------------------------

    // abs :: Num a => a -> a
    const abs = Math.abs;

    // all :: (a -> Bool) -> [a] -> Bool
    const all = (f, xs) => xs.every(f);

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // delete_ :: Eq a => a -> [a] -> [a]
    const delete_ = (x, xs) =>
        deleteBy((a, b) => a === b, x, xs);

    // deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
    const deleteBy = (f, x, xs) =>
        xs.length > 0 ? (
            f(x, xs[0]) ? (
                xs.slice(1)
            ) : [xs[0]].concat(deleteBy(f, x, xs.slice(1)))
        ) : [];

    // enumFromTo :: Enum a => a -> a -> [a]
    const enumFromTo = (m, n) => {
        const [tm, tn] = [typeof m, typeof n];
        return tm !== tn ? undefined : (() => {
            const
                blnS = (tm === 'string'),
                [base, end] = [m, n].map(blnS ? (s => s.codePointAt(0)) : id);
            return Array.from({
                length: Math.floor(end - base) + 1
            }, (_, i) => blnS ? String.fromCodePoint(base + i) : m + i);
        })();
    };

    // id :: a -> a
    const id = x => x;

    // justifyRight :: Int -> Char -> Text -> Text
    const justifyRight = (n, cFiller, strText) =>
        n > strText.length ? (
            (cFiller.repeat(n) + strText)
            .slice(-n)
        ) : strText;

    // permutations :: [a] -> [[a]]
    const permutations = xs =>
        xs.length ? concatMap(x => concatMap(ys => [
                [x].concat(ys)
            ],
            permutations(delete_(x, xs))), xs) : [
            []
        ];

    // show :: a -> String
    const show = x => JSON.stringify(x);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const ny = ys.length;
        return (xs.length <= ny ? xs : xs.slice(0, ny))
            .map((x, i) => f(x, ys[i]));
    };


    // CONNECTION PUZZLE ------------------------------------------------------

    // universe :: [[Int]]
    const universe = permutations(enumFromTo(1, 8));

    // isSolution :: [Int] -> Bool
    const isSolution = ([a, b, c, d, e, f, g, h]) =>
        all(x => abs(x) > 1, [a - d, c - d, g - d, e - d, a - c, c - g, g - e,
            e - a, b - e, d - e, h - e, f - e, b - d, d - h, h - f, f - b
        ]);

    // firstSolution :: [Int]
    const firstSolution = universe[until(
        i => isSolution(universe[i]),
        i => i + 1,
        0
    )];

    // TEST -------------------------------------------------------------------

    // [Int]
    const [a, b, c, d, e, f, g, h] = firstSolution;

    return unlines(
        zipWith(
            (a, n) => a + ' = ' + n.toString(),
            enumFromTo('A', 'H'),
            firstSolution
        )
        .concat(
            [
                [],
                [a, b],
                [c, d, e, f],
                [g, h]
            ].map(xs => justifyRight(5, ' ', unwords(xs.map(show))))
        )
    );
})();
