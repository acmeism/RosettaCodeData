(() => {
    'use strict';

    // main :: IO ()
    const main = () =>
        take(25, weirds());


    // weirds :: Gen [Int]
    function* weirds() {
        let
            x = 1,
            i = 1;
        while (true) {
            x = until(isWeird, succ, x)
            console.log(i.toString() + ' -> ' + x)
            yield x;
            x = 1 + x;
            i = 1 + i;
        }
    }


    // isWeird :: Int -> Bool
    const isWeird = n => {
        const
            ds = descProperDivisors(n),
            d = sum(ds) - n;
        return 0 < d && !hasSum(d, ds)
    };

    // hasSum :: Int -> [Int] -> Bool
    const hasSum = (n, xs) => {
        const go = (n, xs) =>
            0 < xs.length ? (() => {
                const
                    h = xs[0],
                    t = xs.slice(1);
                return n < h ? (
                    go(n, t)
                ) : (
                    n == h || hasSum(n - h, t) || hasSum(n, t)
                );
            })() : false;
        return go(n, xs);
    };


    // descProperDivisors :: Int -> [Int]
    const descProperDivisors = n => {
        const
            rRoot = Math.sqrt(n),
            intRoot = Math.floor(rRoot),
            blnPerfect = rRoot === intRoot,
            lows = enumFromThenTo(intRoot, intRoot - 1, 1)
            .filter(x => (n % x) === 0);
        return (
            reverse(lows)
            .slice(1)
            .map(x => n / x)
        ).concat((blnPerfect ? tail : id)(lows))
    };


    // GENERIC FUNCTIONS ----------------------------


    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = (x1, x2, y) => {
        const d = x2 - x1;
        return Array.from({
            length: Math.floor(y - x2) / d + 2
        }, (_, i) => x1 + (d * i));
    };

    // id :: a -> a
    const id = x => x;

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // succ :: Enum a => a -> a
    const succ = x => 1 + x;

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

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return main();
})();
