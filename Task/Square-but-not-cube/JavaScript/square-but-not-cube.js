(() => {
    'use strict';

    const main = () =>
        unlines(map(
            x => x.toString() + (
                isCube(x) ? (
                    ` (cube of ${cubeRootInt(x)} and square of ${
                            Math.pow(x, 1/2)
                    })`
                ) : ''
            ),
            map(x => x * x, enumFromTo(1, 33))
        ));

    // isCube :: Int -> Bool
    const isCube = n =>
        n === Math.pow(cubeRootInt(n), 3);

    // cubeRootInt :: Int -> Int
    const cubeRootInt = n => Math.round(Math.pow(n, 1 / 3));


    // GENERIC FUNCTIONS ----------------------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        m <= n ? iterateUntil(
            x => n <= x,
            x => 1 + x,
            m
        ) : [];

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        const vs = [x];
        let h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // MAIN ---
    return main();
})();
