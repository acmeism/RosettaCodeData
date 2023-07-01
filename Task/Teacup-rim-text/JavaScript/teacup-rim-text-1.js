(() => {
    'use strict';

    // main :: IO ()
    const main = () =>
        showGroups(
            circularWords(
                // Local copy of:
                // https://www.mit.edu/~ecprice/wordlist.10000
                lines(readFile('~/mitWords.txt'))
            )
        );

    // circularWords :: [String] -> [String]
    const circularWords = ws =>
        ws.filter(isCircular(new Set(ws)), ws);

    // isCircular :: Set String -> String -> Bool
    const isCircular = lexicon => w => {
        const iLast = w.length - 1;
        return 1 < iLast && until(
            ([i, bln, s]) => iLast < i || !bln,
            ([i, bln, s]) => [1 + i, lexicon.has(s), rotated(s)],
            [0, true, rotated(w)]
        )[1];
    };

    // DISPLAY --------------------------------------------

    // showGroups :: [String] -> String
    const showGroups = xs =>
        unlines(map(
            gp => map(snd, gp).join(' -> '),
            groupBy(
                (a, b) => fst(a) === fst(b),
                sortBy(
                    comparing(fst),
                    map(x => Tuple(concat(sort(chars(x))), x),
                        xs
                    )
                )
            ).filter(gp => 1 < gp.length)
        ));


    // MAC OS JS FOR AUTOMATION ---------------------------

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

    // GENERIC FUNCTIONS ----------------------------------

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

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];

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

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // rotated :: String -> String
    const rotated = xs =>
        xs.slice(1) + xs[0];

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // sort :: Ord a => [a] -> [a]
    const sort = xs => xs.slice()
        .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) =>
        xs.slice()
        .sort(f);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return main();
})();
