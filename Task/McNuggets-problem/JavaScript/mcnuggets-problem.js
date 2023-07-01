(() => {
    'use strict';

    // main :: IO ()
    const main = () => {
        const
            size = n => enumFromTo(0)(
                quot(100, n)
            ),
            nuggets = new Set(
                size(6).flatMap(
                    x => size(9).flatMap(
                        y => size(20).flatMap(
                            z => {
                                const v = sum([6 * x, 9 * y, 20 * z]);
                                return 101 > v ? (
                                    [v]
                                ) : [];
                            }
                        ),
                    )
                )
            ),
            xs = dropWhile(
                x => nuggets.has(x),
                enumFromThenTo(100, 99, 1)
            );

        return 0 < xs.length ? (
            xs[0]
        ) : 'No unreachable quantities found in this range';
    };


    // GENERIC FUNCTIONS ----------------------------------

    // dropWhile :: (a -> Bool) -> [a] -> [a]
    const dropWhile = (p, xs) => {
        const lng = xs.length;
        return 0 < lng ? xs.slice(
            until(
                i => i === lng || !p(xs[i]),
                i => 1 + i,
                0
            )
        ) : [];
    };

    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = (x1, x2, y) => {
        const d = x2 - x1;
        return Array.from({
            length: Math.floor(y - x2) / d + 2
        }, (_, i) => x1 + (d * i));
    };

    // ft :: Int -> Int -> [Int]
    const enumFromTo = m => n =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // quot :: Int -> Int -> Int
    const quot = (n, m) => Math.floor(n / m);

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return console.log(
        main()
    );
})();
