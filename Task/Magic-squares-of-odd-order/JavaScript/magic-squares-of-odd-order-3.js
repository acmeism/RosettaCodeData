(() => {

    // Number of rows -> n rows of integers
    // oddMagicTable :: Int -> [[Int]]
    const oddMagicTable = n =>
        mapAsTable(n, siamMap(quot(n, 2)));

    // Highest index of square -> Siam xys so far -> xy -> next xy coordinate
    // nextSiam :: Int -> M.Map (Int, Int) Int -> (Int, Int) -> (Int, Int)
    const nextSiam = (uBound, sMap, [x, y]) => {
        const [a, b] = [x + 1, y - 1];
        return (a > uBound && b < 0) ? (
                [uBound, 1]             // Move down if obstructed by corner
            ) : a > uBound ? (
                [0, b]                  // Wrap at right edge
            ) : b < 0 ? (
                [a, uBound]             // Wrap at upper edge
            ) : mapLookup(sMap, [a, b])
            .nothing ? (                // Unimpeded default: one up one right
                [a, b]
            ) : [a - 1, b + 2];         // Position occupied: move down
    };

    // Order of table -> Siamese indices keyed by coordinates
    // siamMap :: Int -> M.Map (Int, Int) Int
    const siamMap = n => {
        const
            uBound = 2 * n,
            sPath = (uBound, sMap, xy, n) => {
                const [x, y] = xy,
                newMap = mapInsert(sMap, xy, n);
                return (y == uBound && x == quot(uBound, 2) ? (
                    newMap
                ) : sPath(
                    uBound, newMap, nextSiam(uBound, newMap, [x, y]), n + 1));
            };
        return sPath(uBound, {}, [n, 0], 1);
    };

    // Size of square -> integers keyed by coordinates -> rows of integers
    // mapAsTable :: Int -> M.Map (Int, Int) Int -> [[Int]]
    const mapAsTable = (nCols, dct) => {
        const axis = enumFromTo(0, nCols - 1);
        return map(row => map(k => fromJust(mapLookup(dct, k)), row),
            bind(axis, y => [bind(axis, x => [
                [x, y]
            ])]));
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // bind :: [a] -> (a -> [b]) -> [b]
    const bind = (xs, f) => [].concat.apply([], xs.map(f));

    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat(Array.from(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // fromJust :: M a -> a
    const fromJust = m => m.nothing ? {} : m.just;

    // fst :: [a, b] -> a
    const fst = pair => pair.length === 2 ? pair[0] : undefined;

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // justifyRight :: Int -> Char -> Text -> Text
    const justifyRight = (n, cFiller, strText) =>
        n > strText.length ? (
            (cFiller.repeat(n) + strText)
            .slice(-n)
        ) : strText;

    // length :: [a] -> Int
    const length = xs => xs.length;

    // log :: a -> IO ()
    const log = (...args) =>
        console.log(
            args
            .map(show)
            .join(' -> ')
        );

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // mapInsert :: Dictionary -> k -> v -> Dictionary
    const mapInsert = (dct, k, v) =>
        (dct[(typeof k === 'string' && k) || show(k)] = v, dct);

    // mapKeys :: Map k a -> [k]
    const mapKeys = dct =>
        sortBy(mappendComparing([snd, fst]),
            map(JSON.parse, Object.keys(dct)));

    // mapLookup :: Dictionary -> k -> Maybe v
    const mapLookup = (dct, k) => {
        const
            v = dct[(typeof k === 'string' && k) || show(k)],
            blnJust = (typeof v !== 'undefined');
        return {
            nothing: !blnJust,
            just: v
        };
    };

    // mappendComparing :: [(a -> b)] -> (a -> a -> Ordering)
    const mappendComparing = fs => (x, y) =>
        fs.reduce((ord, f) => {
            if (ord !== 0) return ord;
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : a > b ? 1 : 0
        }, 0);

    // maximum :: [a] -> a
    const maximum = xs =>
        xs.reduce((a, x) => (x > a || a === undefined ? x : a), undefined);

    // Integral a => a -> a -> a
    const quot = (n, m) => Math.floor(n / m);

    // show :: a -> String
    const show = x => JSON.stringify(x);
    //
    // snd :: (a, b) -> b
    const snd = tpl => Array.isArray(tpl) ? tpl[1] : undefined;
    //
    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) => xs.slice()
        .sort(f);

    // table :: String -> [[String]] -> [String]
    const table = (delim, rows) =>
        map(curry(intercalate)(delim),
            transpose(map(col =>
                map(curry(justifyRight)(maximum(map(length, col)))(' '), col),
                transpose(rows))));

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, col) => xs.map(row => row[col]));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // TEST -------------------------------------------------------------------

    return intercalate('\n\n',
        bind([3, 5, 7],
            n => unlines(table("  ",
                map(xs => map(show, xs), oddMagicTable(n))))));
})();
