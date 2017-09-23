(() => {
    'use strict';

    // forwardDifference :: [Int] -> [Int]
    const forwardDifference = (n, xs) => {
        const fd = xs => zipWith((a, b) => a - b, tail(xs), xs);
        return until(
                m => m.index < 1,
                m => ({
                    index: m.index - 1,
                    list: fd(m.list)
                }), {
                    index: n,
                    list: xs
                }
            )
            .list;
    };


    // GENERIC FUNCTIONS ---------------------------------------

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const ny = ys.length;
        return (xs.length <= ny ? xs : xs.slice(0, ny))
            .map((x, i) => f(x, ys[i]));
    };

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        const go = x => p(x) ? x : go(f(x));
        return go(x);
    };

    // tail :: [a] -> [a]
    const tail = xs => xs.length ? xs.slice(1) : undefined;


    // TEST ----------------------------------------------------

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // show :: a -> String
    const show = x => JSON.stringify(x);

    // Sample
    const test = [90, 47, 58, 29, 22, 32, 55, 5, 55, 73];

    return range(1, 9)
        .map(x => `${x}    ${show(forwardDifference(x, test))}`)
        .join('\n');
})();
