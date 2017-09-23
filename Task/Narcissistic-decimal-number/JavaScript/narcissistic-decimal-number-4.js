(() => {
    'use strict';

    // DAFFODILS --------------------------------------------------------------

    // narcissiOfLength :: Int -> [Int]
    const narcissiOfLength = n =>
        n > 0 ? filter(curry(isDaffodil)(n), digitPowerSums(n)) : [0];

    // Do the decimal digits of N, each raised to the power E, sum to N itself ?

// isDaffodil :: Int -> Int -> Bool
const isDaffodil = (e, n) => {
    const
        powerSum = (n, xs) => xs.reduce((a, x) => a + Math.pow(x, n), 0),
        digitList = n => (n > 0) ? (
            cons((n % 10), digitList(Math.floor(n / 10)))
        ) : [],
        ds = digitList(n);
    return e === ds.length && n === powerSum(e, ds);
};

    // The subset of integers of n digits that actually need daffodil checking:

    // (Flattened leaves of a tree of unique digit combinations, in which
    // order is not significant. Digit sequence doesn't affect power summing)

    // digitPowerSums :: Int -> [Int]
    const digitPowerSums = nDigits => {
        const
            digitPowers = map(x => [x, pow(x, nDigits)], enumFromTo(0, 9)),
            treeGrowth = (n, parentPairs) => (n > 0) ? (
                treeGrowth(n - 1,
                    isNull(parentPairs) ? (
                        digitPowers
                    ) : concatMap(([parentDigit, parentSum]) =>
                        map(([leafDigit, leafSum]) => //
                            [leafDigit, parentSum + leafSum],
                            take(parentDigit + 1, digitPowers)
                        ),
                        parentPairs
                    ))
            ) : parentPairs;
        return map(snd, treeGrowth(nDigits, []));
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // enumFromTo :: Int -> Int -> Maybe Int -> [Int]
    const enumFromTo = (m, n, step) => {
        const d = (step || 1) * (n >= m ? 1 : -1);
        return Array.from({
            length: Math.floor((n - m) / d) + 1
        }, (_, i) => m + (i * d));
    };
    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // 2 or more arguments
    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat([].slice.apply(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // map :: (a -> b) -> [a] -> [b]
    const map = curry((f, xs) => xs.map(f));

    // isNull :: [a] -> Bool
    const isNull = xs => (xs instanceof Array) ? xs.length < 1 : undefined;

    // length :: [a] -> Int
    const length = xs => xs.length;

    // pow :: Int -> Int -> Int
    const pow = Math.pow

    // take :: Int -> [a] -> [a]
    const take = (n, xs) => xs.slice(0, n);

    // show ::
    // (a -> String) f,  Num n =>
    // a -> maybe f -> maybe n -> String
    const show = JSON.stringify;

    // snd :: (a, b) -> b
    const snd = tpl => Array.isArray(tpl) ? tpl[1] : undefined;


    // TEST -------------------------------------------------------------------

    // return length(concatMap(digitPowerSums, enumFromTo(0, 7)));

    return show(
        //digitPowerSums(3)
        concatMap(narcissiOfLength, enumFromTo(0, 7))
    );
})();
