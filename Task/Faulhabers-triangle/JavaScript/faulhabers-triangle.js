(() => {

    // Order of Faulhaber's triangle -> rows of Faulhaber's triangle
    // faulHaberTriangle :: Int -> [[Ratio Int]]
    const faulhaberTriangle = n =>
        map(x => tail(
                scanl((a, x) => {
                    const ys = map((nd, i) =>
                        ratioMult(nd, Ratio(x, i + 2)), a);
                    return cons(ratioMinus(Ratio(1, 1), ratioSum(ys)), ys);
                }, [], enumFromTo(0, x))
            ),
            enumFromTo(0, n));

    // p -> n -> Sum of the p-th powers of the first n positive integers
    // faulhaber :: Int -> Ratio Int -> Ratio Int
    const faulhaber = (p, n) =>
        ratioSum(map(
            (nd, i) => ratioMult(nd, Ratio(raise(n, i + 1), 1)),
            last(faulhaberTriangle(p))
        ));

    // RATIOS -----------------------------------------------------------------

    // (Max numr + denr widths) -> Column width -> Filler -> Ratio -> String
    // justifyRatio :: (Int, Int) -> Int -> Char -> Ratio Integer -> String
    const justifyRatio = (ws, n, c, nd) => {
        const
            w = max(n, ws.nMax + ws.dMax + 2),
            [num, den] = [nd.num, nd.den];
        return all(Number.isSafeInteger, [num, den]) ? (
            den === 1 ? center(w, c, show(num)) : (() => {
                const [q, r] = quotRem(w - 1, 2);
                return concat([
                    justifyRight(q, c, show(num)),
                    '/',
                    justifyLeft(q + r, c, (show(den)))
                ]);
            })()
        ) : "JS integer overflow ... ";
    };

    // Ratio :: Int -> Int -> Ratio
    const Ratio = (n, d) => ({
        num: n,
        den: d
    });

    // ratioMinus :: Ratio -> Ratio -> Ratio
    const ratioMinus = (nd, nd1) => {
        const
            d = lcm(nd.den, nd1.den);
        return simpleRatio({
            num: (nd.num * (d / nd.den)) - (nd1.num * (d / nd1.den)),
            den: d
        });
    };

    // ratioMult :: Ratio -> Ratio -> Ratio
    const ratioMult = (nd, nd1) => simpleRatio({
        num: nd.num * nd1.num,
        den: nd.den * nd1.den
    });

    // ratioPlus :: Ratio -> Ratio -> Ratio
    const ratioPlus = (nd, nd1) => {
        const
            d = lcm(nd.den, nd1.den);
        return simpleRatio({
            num: (nd.num * (d / nd.den)) + (nd1.num * (d / nd1.den)),
            den: d
        });
    };

    // ratioSum :: [Ratio] -> Ratio
    const ratioSum = xs =>
        simpleRatio(foldl((a, x) => ratioPlus(a, x), {
            num: 0,
            den: 1
        }, xs));

    // ratioWidths :: [[Ratio]] -> {nMax::Int, dMax::Int}
    const ratioWidths = xss => {
        return foldl((a, x) => {
            const [nw, dw] = ap(
                [compose(length, show)], [x.num, x.den]
            ), [an, ad] = ap(
                [curry(flip(lookup))(a)], ['nMax', 'dMax']
            );
            return {
                nMax: nw > an ? nw : an,
                dMax: dw > ad ? dw : ad
            };
        }, {
            nMax: 0,
            dMax: 0
        }, concat(xss));
    };

    // simpleRatio :: Ratio -> Ratio
    const simpleRatio = nd => {
        const g = gcd(nd.num, nd.den);
        return {
            num: nd.num / g,
            den: nd.den / g
        };
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // all :: (a -> Bool) -> [a] -> Bool
    const all = (f, xs) => xs.every(f);

    // A list of functions applied to a list of arguments
    // <*> :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        [].concat.apply([], fs.map(f => //
            [].concat.apply([], xs.map(x => [f(x)]))));

    // Size of space -> filler Char -> Text -> Centered Text
    // center :: Int -> Char -> Text -> Text
    const center = (n, c, s) => {
        const [q, r] = quotRem(n - s.length, 2);
        return concat(concat([replicate(q, c), s, replicate(q + r, c)]));
    };

    // compose :: (b -> c) -> (a -> b) -> (a -> c)
    const compose = (f, g) => x => f(g(x));

    // concat :: [[a]] -> [a] | [String] -> String
    const concat = xs =>
        xs.length > 0 ? (() => {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        })() : [];

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // 2 or more arguments
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

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // gcd :: Integral a => a -> a -> a
    const gcd = (x, y) => {
        const _gcd = (a, b) => (b === 0 ? a : _gcd(b, a % b)),
            abs = Math.abs;
        return _gcd(abs(x), abs(y));
    };

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // justifyLeft :: Int -> Char -> Text -> Text
    const justifyLeft = (n, cFiller, strText) =>
        n > strText.length ? (
            (strText + cFiller.repeat(n))
            .substr(0, n)
        ) : strText;

    // justifyRight :: Int -> Char -> Text -> Text
    const justifyRight = (n, cFiller, strText) =>
        n > strText.length ? (
            (cFiller.repeat(n) + strText)
            .slice(-n)
        ) : strText;

    // last :: [a] -> a
    const last = xs => xs.length ? xs.slice(-1)[0] : undefined;

    // length :: [a] -> Int
    const length = xs => xs.length;

    // lcm :: Integral a => a -> a -> a
    const lcm = (x, y) =>
        (x === 0 || y === 0) ? 0 : Math.abs(Math.floor(x / gcd(x, y)) * y);

    // lookup :: Eq a => a -> [(a, b)] -> Maybe b
    const lookup = (k, pairs) => {
        if (Array.isArray(pairs)) {
            let m = pairs.find(x => x[0] === k);
            return m ? m[1] : undefined;
        } else {
            return typeof pairs === 'object' ? (
                pairs[k]
            ) : undefined;
        }
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // max :: Ord a => a -> a -> a
    const max = (a, b) => b > a ? b : a;

    // min :: Ord a => a -> a -> a
    const min = (a, b) => b < a ? b : a;

    // quotRem :: Integral a => a -> a -> (a, a)
    const quotRem = (m, n) => [Math.floor(m / n), m % n];

    // raise :: Num -> Int -> Num
    const raise = (n, e) => Math.pow(n, e);

    // replicate :: Int -> a -> [a]
    const replicate = (n, x) =>
        Array.from({
            length: n
        }, () => x);

    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = (f, startValue, xs) =>
        xs.reduce((a, x) => {
            const v = f(a.acc, x);
            return {
                acc: v,
                scan: cons(a.scan, v)
            };
        }, {
            acc: startValue,
            scan: [startValue]
        })
        .scan;

    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[0], null, x[1]] : x
        );

    // tail :: [a] -> [a]
    const tail = xs => xs.length ? xs.slice(1) : undefined;

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');


    // TEST -------------------------------------------------------------------
    const
        triangle = faulhaberTriangle(9),
        widths = ratioWidths(triangle);

    return unlines(
            map(row =>
                concat(map(cell =>
                    justifyRatio(widths, 8, ' ', cell), row)), triangle)
        ) +
        '\n\n' + unlines(
            [
                'faulhaber(17, 1000)',
                justifyRatio(widths, 0, ' ', faulhaber(17, 1000)),
                '\nfaulhaber(17, 8)',
                justifyRatio(widths, 0, ' ', faulhaber(17, 8)),
                '\nfaulhaber(4, 1000)',
                justifyRatio(widths, 0, ' ', faulhaber(4, 1000)),
            ]
        );
})();
