(() => {
    'use strict';

    const main = () => {

        // findRecursive :: a -> [a] -> Either String Int
        const findRecursive = (x, xs) => {
            const go = (lo, hi) => {
                if (hi < lo) {
                    return Left('not found');
                } else {
                    const
                        mid = div(lo + hi, 2),
                        v = xs[mid];
                    return v > x ? (
                        go(lo, mid - 1)
                    ) : v < x ? (
                        go(mid + 1, hi)
                    ) : Right(mid);
                }
            };
            return go(0, xs.length);
        };


        // findRecursive :: a -> [a] -> Either String Int
        const findIter = (x, xs) => {
            const [m, l, h] = until(
                ([mid, lo, hi]) => lo > hi || lo === mid,
                ([mid, lo, hi]) => {
                    const
                        m = div(lo + hi, 2),
                        v = xs[m];
                    return v > x ? [
                        m, lo, m - 1
                    ] : v < x ? [
                        m, m + 1, hi
                    ] : [m, m, hi];
                },
                [div(xs.length / 2), 0, xs.length - 1]
            );
            return l > h ? (
                Left('not found')
            ) : Right(m);
        };

        // TESTS ------------------------------------------

        const
            // (pre-sorted AZ)
            xs = ["alpha", "beta", "delta", "epsilon", "eta", "gamma",
                "iota", "kappa", "lambda", "mu", "nu", "theta", "zeta"
            ];
        return JSON.stringify([
            'Recursive',
            map(x => either(
                    l => "'" + x + "' " + l,
                    r => "'" + x + "' found at index " + r,
                    findRecursive(x, xs)
                ),
                knuthShuffle(['cape'].concat(xs).concat('cairo'))
            ),
            '',
            'Iterative:',
            map(x => either(
                    l => "'" + x + "' " + l,
                    r => "'" + x + "' found at index " + r,
                    findIter(x, xs)
                ),
                knuthShuffle(['cape'].concat(xs).concat('cairo'))
            )
        ], null, 2);
    };

    // GENERIC FUNCTIONS ----------------------------------

    // Left :: a -> Either a b
    const Left = x => ({
        type: 'Either',
        Left: x
    });

    // Right :: b -> Either a b
    const Right = x => ({
        type: 'Either',
        Right: x
    });

    // div :: Int -> Int -> Int
    const div = (x, y) => Math.floor(x / y);

    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = (fl, fr, e) =>
        'Either' === e.type ? (
            undefined !== e.Left ? (
                fl(e.Left)
            ) : fr(e.Right)
        ) : undefined;

    // Abbreviation for quick testing

    // enumFromTo :: (Int, Int) -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // FOR TESTS

    // knuthShuffle :: [a] -> [a]
    const knuthShuffle = xs => {
        const swapped = (iFrom, iTo, xs) =>
            xs.map(
                (x, i) => iFrom !== i ? (
                    iTo !== i ? x : xs[iFrom]
                ) : xs[iTo]
            );
        return enumFromTo(0, xs.length - 1)
            .reduceRight((a, i) => {
                const iRand = randomRInt(0, i)();
                return i !== iRand ? (
                    swapped(i, iRand, a)
                ) : a;
            }, xs);
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);


    // FOR TESTS

    // randomRInt :: Int -> Int -> IO () -> Int
    const randomRInt = (low, high) => () =>
        low + Math.floor(
            (Math.random() * ((high - low) + 1))
        );

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return main();
})();
