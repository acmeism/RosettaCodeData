(() => {
    'use strict';

    // main :: IO ()
    const main = () =>
        console.log(
            fTable(
                'Narcissistic decimal numbers of lengths [1..7]:\n'
            )(show)(show)(
                narcissiOfLength
            )(enumFromTo(1)(7))
        );

    // narcissiOfLength :: Int -> [Int]
    const narcissiOfLength = n =>
        0 < n ? filter(isDaffodil(n))(
            digitPowerSums(n)
        ) : [0];


    // powerSum :: Int -> [Int] -> Int
    const powerSum = n =>
        xs => xs.reduce(
            (a, x) => a + pow(x, n), 0
        );


    // isDaffodil :: Int -> Int -> Bool
    const isDaffodil = e => n => {
        // True if the decimal digits of N,
        // each raised to the power E, sum to N.
        const ds = digitList(n);
        return e === ds.length && n === powerSum(e)(ds);
    };

    // The subset of integers of n digits that actually need daffodil checking:

    // (Flattened leaves of a tree of unique digit combinations, in which
    // order is not significant. Digit sequence doesn't affect power summing)

    // digitPowerSums :: Int -> [Int]
    const digitPowerSums = nDigits => {
        const
            digitPowers = map(x => [x, pow(x, nDigits)])(
                enumFromTo(0)(9)
            ),
            treeGrowth = (n, parentPairs) => 0 < n ? (
                treeGrowth(n - 1,
                    isNull(parentPairs) ? (
                        digitPowers
                    ) : concatMap(
                        ([parentDigit, parentSum]) =>
                        map(([leafDigit, leafSum]) => //
                            [leafDigit, parentSum + leafSum])(
                            take(parentDigit + 1)(digitPowers)
                        )
                    )(parentPairs)
                )
            ) : parentPairs;
        return map(snd)(treeGrowth(nDigits, []));
    };


    // ---------------------GENERIC FUNCTIONS---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m => n =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = f =>
        xs => xs.flatMap(f);

    // cons :: a -> [a] -> [a]
    const cons = x =>
        xs => [x].concat(xs);

    // digitList :: Int -> [Int]
    const digitList = n => {
        const go = x => 0 < x ? (
            cons(x % 10)(
                go(Math.floor(x / 10))
            )
        ) : [];
        return 0 < n ? go(n) : [0];
    }

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = f => xs => xs.filter(f);

    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        xs => xs.map(f);

    // isNull :: [a] -> Bool
    // isNull :: String -> Bool
    const isNull = xs =>
        1 > xs.length;

    // length :: [a] -> Int
    const length = xs => xs.length;

    // pow :: Int -> Int -> Int
    const pow = Math.pow;

    // take :: Int -> [a] -> [a]
    const take = n =>
        xs => xs.slice(0, n);

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // show :: a -> String
    const show = x => JSON.stringify(x)

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys =>
        xs.slice(
            0, Math.min(xs.length, ys.length)
        ).map((x, i) => f(x)(ys[i]));

    // ------------------------FORMATTING-------------------------

    // fTable :: String -> (a -> String) -> (b -> String)
    //                      -> (a -> b) -> [a] -> String
    const fTable = s => xShow => fxShow => f => xs => {
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        const
            ys = xs.map(xShow),
            w = Math.max(...ys.map(length));
        return s + '\n' + zipWith(
            a => b => a.padStart(w, ' ') + ' -> ' + b
        )(ys)(
            xs.map(x => fxShow(f(x)))
        ).join('\n');
    };

    // MAIN ---
    return main();
})();
