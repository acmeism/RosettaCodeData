(() => {
    'use strict';

    // digits :: Int -> [Int]
    const digits = n => n.toString()
        .split('')
        .map(x => parseInt(x, 10));

    // pow :: Int -> Int -> Int
    const pow = Math.pow;

    // isNarc :: Int -> Bool
    const isNarc = n => {
        const
            ds = digits(n),
            len = ds.length;

        return ds.reduce((a, x) =>
            a + pow(x, len), 0) === n;
    };

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    return until(
            x => x.narc.length > 24,
            x => ({
                n: x.n + 1,
                narc: (isNarc(x.n) ? x.narc.concat(x.n) : x.narc)
            }), {
                n: 0,
                narc: []
            }
        )
        .narc
})();
