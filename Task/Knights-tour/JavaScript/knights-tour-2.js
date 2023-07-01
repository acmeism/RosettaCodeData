(() => {
    'use strict';

    // knightsTour :: Int -> [(Int, Int)] -> [(Int, Int)]
    const knightsTour = rowLength => moves => {
        const go = path => {
            const
                findMoves = xy => difference(knightMoves(xy), path),
                warnsdorff = minimumBy(
                    comparing(compose(length, findMoves))
                ),
                options = findMoves(path[0]);
            return 0 < options.length ? (
                go([warnsdorff(options)].concat(path))
            ) : reverse(path);
        };

        // board :: [[(Int, Int)]]
        const board = concatMap(
            col => concatMap(
                row => [
                    [col, row]
                ],
                enumFromTo(1, rowLength)),
            enumFromTo(1, rowLength)
        );

        // knightMoves :: (Int, Int) -> [(Int, Int)]
        const knightMoves = ([x, y]) =>
            concatMap(
                ([dx, dy]) => {
                    const ab = [x + dx, y + dy];
                    return elem(ab, board) ? (
                        [ab]
                    ) : [];
                }, [
                    [-2, -1],
                    [-2, 1],
                    [-1, -2],
                    [-1, 2],
                    [1, -2],
                    [1, 2],
                    [2, -1],
                    [2, 1]
                ]
            );
        return go(moves);
    };

    // TEST -----------------------------------------------
    // main :: IO()
    const main = () => {

        // boardSize :: Int
        const boardSize = 8;

        // tour :: [(Int, Int)]
        const tour = knightsTour(boardSize)(
            [fromAlgebraic('e5')]
        );

        // report :: String
        const report = '(Board size ' +
            boardSize + '*' + boardSize + ')\n\n' +
            'Route: \n\n' +
            showRoute(boardSize)(tour) + '\n\n' +
            'Coverage and order: \n\n' +
            showCoverage(boardSize)(tour) + '\n\n';
        return (
            console.log(report),
            report
        );
    }

    // DISPLAY --------------------------------------------

    // algebraic :: (Int, Int) -> String
    const algebraic = ([x, y]) =>
        chr(x + 96) + y.toString();

    // fromAlgebraic :: String -> (Int, Int)
    const fromAlgebraic = s =>
        2 <= s.length ? (
            [ord(s[0]) - 96, parseInt(s.slice(1))]
        ) : undefined;

    // showCoverage :: Int -> [(Int, Int)] -> String
    const showCoverage = rowLength => xys => {
        const
            intMax = xys.length,
            w = 1 + intMax.toString().length
        return unlines(map(concat,
            chunksOf(
                rowLength,
                map(composeList([justifyRight(w, ' '), str, fst]),
                    sortBy(
                        mappendComparing([
                            compose(fst, snd),
                            compose(snd, snd)
                        ]),
                        zip(enumFromTo(1, intMax), xys)
                    )
                )
            )
        ));
    };

    // showRoute :: Int -> [(Int, Int)] -> String
    const showRoute = rowLength => xys => {
        const w = 1 + rowLength.toString().length;
        return unlines(map(
            xs => xs.join(' -> '),
            chunksOf(
                rowLength,
                map(compose(justifyRight(w, ' '), algebraic), xys)
            )
        ));
    };


    // GENERIC FUNCTIONS ----------------------------------


    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // chr :: Int -> Char
    const chr = x => String.fromCodePoint(x);

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = (n, xs) =>
        enumFromThenTo(0, n, xs.length - 1)
        .reduce(
            (a, i) => a.concat([xs.slice(i, (n + i))]),
            []
        );

    // compare :: a -> a -> Ordering
    const compare = (a, b) =>
        a < b ? -1 : (a > b ? 1 : 0);

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

    // composeList :: [(a -> a)] -> (a -> a)
    const composeList = fs =>
        x => fs.reduceRight((a, f) => f(a), x, fs);

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.reduce((a, x) => a.concat(f(x)), []);


    // difference :: Eq a => [a] -> [a] -> [a]
    const difference = (xs, ys) => {
        const s = new Set(ys.map(str));
        return xs.filter(x => !s.has(str(x)));
    };

    // elem :: Eq a => a -> [a] -> Bool
    const elem = (x, xs) => xs.some(eq(x))


    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = (x1, x2, y) => {
        const d = x2 - x1;
        return Array.from({
            length: Math.floor(y - x2) / d + 2
        }, (_, i) => x1 + (d * i));
    };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // eq (==) :: Eq a => a -> a -> Bool
    const eq = a => b => {
        const t = typeof a;
        return t !== typeof b ? (
            false
        ) : 'object' !== t ? (
            'function' !== t ? (
                a === b
            ) : a.toString() === b.toString()
        ) : (() => {
            const kvs = Object.entries(a);
            return kvs.length !== Object.keys(b).length ? (
                false
            ) : kvs.every(([k, v]) => eq(v)(b[k]));
        })();
    };

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = (n, cFiller) => s =>
        n > s.length ? (
            s.padStart(n, cFiller)
        ) : s;


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

    // mappendComparing :: [(a -> b)] -> (a -> a -> Ordering)
    const mappendComparing = fs =>
        (x, y) => fs.reduce(
            (ordr, f) => (ordr || compare(f(x), f(y))),
            0
        );

    // minimumBy :: (a -> a -> Ordering) -> [a] -> a
    const minimumBy = f => xs =>
        xs.reduce((a, x) => undefined === a ? x : (
            0 > f(x, a) ? x : a
        ), undefined);

    // ord :: Char -> Int
    const ord = c => c.codePointAt(0);

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) =>
        xs.slice()
        .sort(f);

    // str :: a -> String
    const str = x => x.toString();

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        xs.slice(0, n);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // Use of `take` and `length` here allows for zipping with non-finite
    // lists - i.e. generators like cycle, repeat, iterate.

    // zip :: [a] -> [b] -> [(a, b)]
    const zip = (xs, ys) => {
        const lng = Math.min(length(xs), length(ys));
        const bs = take(lng, ys);
        return take(lng, xs).map((x, i) => Tuple(x, bs[i]));
    };

    // MAIN ---
    return main();
})();
