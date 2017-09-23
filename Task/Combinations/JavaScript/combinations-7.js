(() => {
    'use strict';

    // COMBINATIONS -----------------------------------------------------------

    // comb :: Int -> Int -> [[Int]]
    const comb = (m, n) => combinations(m, enumFromTo(0, n - 1));

    // combinations :: Int -> [a] -> [[a]]
    const combinations = (k, xs) =>
        sort(filter(xs => k === xs.length, subsequences(xs)));


    // GENERIC FUNCTIONS -----------------------------------------------------

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // foldr (a -> b -> b) -> b -> [a] -> b
    const foldr = (f, a, xs) => xs.reduceRight(f, a);

    // isNull :: [a] -> Bool
    const isNull = xs => (xs instanceof Array) ? xs.length < 1 : undefined;

    // show :: a -> String
    const show = x => JSON.stringify(x) //, null, 2);

    // sort :: Ord a => [a] -> [a]
    const sort = xs => xs.sort();

    // stringChars :: String -> [Char]
    const stringChars = s => s.split('');

    // subsequences :: [a] -> [[a]]
    const subsequences = xs => {

        // nonEmptySubsequences :: [a] -> [[a]]
        const nonEmptySubsequences = xxs => {
            if (isNull(xxs)) return [];
            const [x, xs] = uncons(xxs);
            const f = (r, ys) => cons(ys, cons(cons(x, ys), r));

            return cons([x], foldr(f, [], nonEmptySubsequences(xs)));
        };

        return nonEmptySubsequences(
            (typeof xs === 'string' ? stringChars(xs) : xs)
        );
    };

    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => xs.length ? [xs[0], xs.slice(1)] : undefined;


    // TEST -------------------------------------------------------------------
    return show(
        comb(3, 5)
    );
})();
