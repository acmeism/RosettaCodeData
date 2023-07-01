(() => {
    'use strict';

    // fractran :: [Ratio Int] -> Int -> Gen [Int]
    const fractran = (xs, n) => {
        function* go(n) {
            const p = r => 0 === v % r.d;
            let
                v = n,
                mb = find(p, xs);
            yield v
            while (!mb.Nothing) {
                mb = bindMay(
                    find(p, xs),
                    r => (
                        v = truncate({
                            type: 'Ratio',
                            n: v * r.n,
                            d: r.d
                        }),
                        Just(v)
                    )
                );
                mb.Just && (yield v)
            }
        };
        return go(n);
    };

    // readRatios :: String -> [Ratio]
    const readRatios = s =>
        map(x => ratio(...map(read, splitOn('/', x))),
            splitOn(',', s)
        );

    // main :: IO()
    const main = () => {

        // strRatios :: String
        const strRatios = `17/91, 78/85, 19/51, 23/38, 29/33, 77/29,
                    95/23 , 77/19,  1/17, 11/13, 13/11, 15/14,  15/2, 55/1`;

        showLog(
            'First fifteen steps:',
            take(15,
                fractran(readRatios(strRatios), 2)
            )
        );

        showLog(
            'First five primes:',
            take(5,
                mapMaybeGen(
                    x => fmapMay(
                        succ,
                        elemIndex(
                            2,
                            takeWhileGen(
                                even,
                                iterate(n => div(n, 2), x)
                            )
                        )
                    ),
                    fractran(readRatios(strRatios), 2)
                )
            )
        );
    };

    // GENERIC ABSTRACTIONS ----------------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // abs :: Num -> Num
    const abs = Math.abs;

    // bindMay (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
    const bindMay = (mb, mf) =>
        mb.Nothing ? mb : mf(mb.Just);

    // div :: Int -> Int -> Int
    const div = (x, y) => Math.floor(x / y);

    // elemIndex :: Eq a => a -> [a] -> Maybe Int
    const elemIndex = (x, xs) => {
        const i = xs.indexOf(x);
        return -1 === i ? (
            Nothing()
        ) : Just(i);
    };

    // even :: Int -> Bool
    const even = n => 0 === n % 2;

    // find :: (a -> Bool) -> [a] -> Maybe a
    const find = (p, xs) => {
        for (let i = 0, lng = xs.length; i < lng; i++) {
            if (p(xs[i])) return Just(xs[i]);
        }
        return Nothing();
    };

    // fmapMay (<$>) :: (a -> b) -> Maybe a -> Maybe b
    const fmapMay = (f, mb) =>
        mb.Nothing ? (
            mb
        ) : Just(f(mb.Just));

    // foldl :: (a -> b -> a) -> a -> [b] -> a
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // gcd :: Int -> Int -> Int
    const gcd = (x, y) => {
        const
            _gcd = (a, b) => (0 === b ? a : _gcd(b, a % b)),
            abs = Math.abs;
        return _gcd(abs(x), abs(y));
    };

    // iterate :: (a -> a) -> a -> Gen [a]
    function* iterate(f, x) {
        let v = x;
        while (true) {
            yield(v);
            v = f(v);
        }
    }

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // mapMaybeGen :: (a -> Maybe b) -> Gen [a] -> [b]
    function* mapMaybeGen(mf, gen) {
        let v = take(1, gen);
        while (0 < v.length) {
            let mb = mf(v[0]);
            if (!mb.Nothing) yield mb.Just
            v = take(1, gen);
        }
    }

    // properFracRatio :: Ratio -> (Int, Ratio)
    const properFracRatio = nd => {
        const [q, r] = Array.from(quotRem(nd.n, nd.d));
        return Tuple(q, ratio(r, nd.d));
    };

    // quot :: Int -> Int -> Int
    const quot = (n, m) => Math.floor(n / m);

    // quotRem :: Int -> Int -> (Int, Int)
    const quotRem = (m, n) =>
        Tuple(Math.floor(m / n), m % n);

    // ratio :: Int -> Int -> Ratio Int
    const ratio = (n, d) =>
        0 !== d ? (() => {
            const g = gcd(n, d);
            return {
                type: 'Ratio',
                'n': quot(n, g), // numerator
                'd': quot(d, g) // denominator
            }
        })() : undefined;

    // read :: Read a => String -> a
    const read = JSON.parse;

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // splitOn :: [a] -> [a] -> [[a]]
    // splitOn :: String -> String -> [String]
    const splitOn = (pat, src) =>
        src.split(pat);

    // succ :: Int -> Int
    const succ = x =>
        1 + x;

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        xs.constructor.constructor.name !== 'GeneratorFunction' ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // takeWhileGen :: (a -> Bool) -> Gen [a] -> [a]
    const takeWhileGen = (p, xs) => {
        const ys = [];
        let
            nxt = xs.next(),
            v = nxt.value;
        while (!nxt.done && p(v)) {
            ys.push(v);
            nxt = xs.next();
            v = nxt.value
        }
        return ys;
    };

    // truncate :: Num -> Int
    const truncate = x =>
        'Ratio' === x.type ? (
            properFracRatio(x)[0]
        ) : properFraction(x)[0];

    // MAIN ---
    return main();
})();
