(() => {
    'use strict';

    // main :: IO ()
    const main = () =>
        anagrams(lines(readFile('~/mitWords.txt')))
        .flatMap(circularOnly)
        .map(xs => xs.join(' -> '))
        .join('\n')

    // anagrams :: [String] -> [[String]]
    const anagrams = ws =>
        groupBy(
            on(eq, fst),
            sortBy(
                comparing(fst),
                ws.map(w => Tuple(sort(chars(w)).join(''), w))
            )
        ).flatMap(
            gp => 2 < gp.length ? [
                gp.map(snd)
            ] : []
        )

    // circularOnly :: [String] -> [[String]]
    const circularOnly = ws => {
        const h = ws[0];
        return ws.length < h.length ? (
            []
        ) : (() => {
            const rs = rotations(h);
            return rs.every(r => ws.includes(r)) ? (
                [rs]
            ) : [];
        })();
    };

    // rotations :: String -> [String]
    const rotations = s =>
        takeIterate(s.length, rotated, s)

    // rotated :: [a] -> [a]
    const rotated = xs => xs.slice(1).concat(xs[0]);


    // GENERIC FUNCTIONS ----------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // chars :: String -> [Char]
    const chars = s => s.split('');

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // eq (==) :: Eq a => a -> a -> Bool
    const eq = (a, b) => a === b

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = (f, xs) => {
        const tpl = xs.slice(1)
            .reduce((a, x) => {
                const h = a[1].length > 0 ? a[1][0] : undefined;
                return (undefined !== h) && f(h, x) ? (
                    Tuple(a[0], a[1].concat([x]))
                ) : Tuple(a[0].concat([a[1]]), [x]);
            }, Tuple([], 0 < xs.length ? [xs[0]] : []));
        return tpl[0].concat([tpl[1]]);
    };

    // lines :: String -> [String]
    const lines = s => s.split(/[\r\n]/);

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    const mapAccumL = (f, acc, xs) =>
        xs.reduce((a, x, i) => {
            const pair = f(a[0], x, i);
            return Tuple(pair[0], a[1].concat(pair[1]));
        }, Tuple(acc, []));

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = (f, g) => (a, b) => f(g(a), g(b));

    // readFile :: FilePath -> IO String
    const readFile = fp => {
        const
            e = $(),
            uw = ObjC.unwrap,
            s = uw(
                $.NSString.stringWithContentsOfFileEncodingError(
                    $(fp)
                    .stringByStandardizingPath,
                    $.NSUTF8StringEncoding,
                    e
                )
            );
        return undefined !== s ? (
            s
        ) : uw(e.localizedDescription);
    };

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // sort :: Ord a => [a] -> [a]
    const sort = xs => xs.slice()
        .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) =>
        xs.slice()
        .sort(f);

    // takeIterate :: Int -> (a -> a) -> a -> [a]
    const takeIterate = (n, f, x) =>
        snd(mapAccumL((a, _, i) => {
            const v = 0 !== i ? f(a) : x;
            return [v, v];
        }, x, Array.from({
            length: n
        })));

    // MAIN ---
    return main();
})();
