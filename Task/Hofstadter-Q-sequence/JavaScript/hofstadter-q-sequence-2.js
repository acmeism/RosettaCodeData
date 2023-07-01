(() => {
    'use strict';

    // hofQSeq :: Int -> [Int]
    const hofQSeq = x =>
        x > 2 ? tail(foldl((Q, n) =>
            n < 3 ? Q : Q.concat(
                Q[n - Q[n - 1]] + Q[n - Q[n - 2]]
            ), [0, 1, 1],
            range(1, x))) : (x > 0 ? take(x, [1, 1]) : undefined);


    // GENERIC FUNCTIONS -------------------------------------------

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a),

        // range :: Int -> Int -> [Int]
        range = (m, n) =>
            Array.from({
                length: Math.floor(n - m) + 1
            }, (_, i) => m + i),

        // tail :: [a] -> [a]
        tail = xs => xs.length ? xs.slice(1) : undefined,

        // last :: [a] -> a
        last = xs => xs.length ? xs.slice(-1)[0] : undefined,

        // Int -> [a] -> [a]
        take = (n, xs) => xs.slice(0, n);

    // TEST --------------------------------------------------------
    return {
        firstTen: hofQSeq(10),
        thousandth: last(hofQSeq(1000)),
        'Q<Q-1UpTo10E5': hofQSeq(100000)
            .reduce((a, x, i, xs) => x < xs[i - 1] ? a + 1 : a, 0)
    };
})();
