(() => {
    'use strict';

    // main :: IO ()
    const main = () =>
        showLog(
            take(20, perfectTotients())
        );

    // perfectTotients :: Generator [Int]
    function* perfectTotients() {
        const
            phi = memoized(
                n => length(
                    filter(
                        k => 1 === gcd(n, k),
                        enumFromTo(1, n)
                    )
                )
            ),
            imperfect = n => n !== sum(
                tail(iterateUntil(
                    x => 1 === x,
                    phi,
                    n
                ))
            );
        let ys = dropWhileGen(imperfect, enumFrom(1))
        while (true) {
            yield ys.next().value - 1;
            ys = dropWhileGen(imperfect, ys)
        }
    }

    // GENERIC FUNCTIONS ----------------------------

    // abs :: Num -> Num
    const abs = Math.abs;

    // dropWhileGen :: (a -> Bool) -> Gen [a] -> [a]
    const dropWhileGen = (p, xs) => {
        let
            nxt = xs.next(),
            v = nxt.value;
        while (!nxt.done && p(v)) {
            nxt = xs.next();
            v = nxt.value;
        }
        return xs;
    };

    // enumFrom :: Int -> [Int]
    function* enumFrom(x) {
        let v = x;
        while (true) {
            yield v;
            v = 1 + v;
        }
    }

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        m <= n ? iterateUntil(
            x => n <= x,
            x => 1 + x,
            m
        ) : [];

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // gcd :: Int -> Int -> Int
    const gcd = (x, y) => {
        const
            _gcd = (a, b) => (0 === b ? a : _gcd(b, a % b)),
            abs = Math.abs;
        return _gcd(abs(x), abs(y));
    };

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        const vs = [x];
        let h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // memoized :: (a -> b) -> (a -> b)
    const memoized = f => {
        const dctMemo = {};
        return x => {
            const v = dctMemo[x];
            return undefined !== v ? v : (dctMemo[x] = f(x));
        };
    };

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

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

    // MAIN ---
    main();
})();
