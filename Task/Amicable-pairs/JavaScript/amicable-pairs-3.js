(() => {
    'use strict';

    // amicablePairsUpTo :: Int -> [(Int, Int)]
    const amicablePairsUpTo = n => {
        const sigma = compose(sum, properDivisors);
        return enumFromTo(1)(n).flatMap(x => {
            const y = sigma(x);
            return x < y && x === sigma(y) ? ([
                [x, y]
            ]) : [];
        });
    };

    // properDivisors :: Int -> [Int]
    const properDivisors = n => {
        const
            rRoot = Math.sqrt(n),
            intRoot = Math.floor(rRoot),
            lows = enumFromTo(1)(intRoot)
            .filter(x => 0 === (n % x));
        return lows.concat(lows.map(x => n / x)
            .reverse()
            .slice((rRoot === intRoot) | 0, -1));
    };


    // TEST -----------------------------------------------

    // main :: IO ()
    const main = () =>
        console.log(unlines(
            amicablePairsUpTo(20000).map(JSON.stringify)
        ));


    // GENERIC FUNCTIONS ----------------------------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m => n =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);


    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');


    // MAIN ---
    return main();
})();
