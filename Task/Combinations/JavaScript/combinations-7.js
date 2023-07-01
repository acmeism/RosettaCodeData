(() => {
    'use strict';

    // ------------------ COMBINATIONS -------------------

    // comb :: Int -> Int -> [[Int]]
    const comb = m =>
        n => combinations(m)(
            enumFromTo(0)(n - 1)
        );

    // combinations :: Int -> [a] -> [[a]]
    const combinations = k =>
        xs => sort(
            filter(xs => k === xs.length)(
                subsequences(xs)
            )
        );

    // --------------------- TEST ---------------------
    const main = () =>
        show(
            comb(3)(5)
        );

    // ---------------- GENERIC FUNCTIONS ----------------

    // cons :: a -> [a] -> [a]
    const cons = x =>
        // A list constructed from the item x,
        // followed by the existing list xs.
        xs => [x].concat(xs);


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => !isNaN(m) ? (
            Array.from({
                length: 1 + n - m
            }, (_, i) => m + i)
        ) : enumFromTo_(m)(n);


    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = p =>
        // The elements of xs which match
        // the predicate p.
        xs => [...xs].filter(p);


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // show :: a -> String
    const show = x =>
        // JSON stringification of a JS value.
        JSON.stringify(x)


    // sort :: Ord a => [a] -> [a]
    const sort = xs => list(xs).slice()
        .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));


    // subsequences :: [a] -> [[a]]
    // subsequences :: String -> [String]
    const subsequences = xs => {
        const
            // nonEmptySubsequences :: [a] -> [[a]]
            nonEmptySubsequences = xxs => {
                if (xxs.length < 1) return [];
                const [x, xs] = [xxs[0], xxs.slice(1)];
                const f = (r, ys) => cons(ys)(cons(cons(x)(ys))(r));
                return cons([x])(nonEmptySubsequences(xs)
                    .reduceRight(f, []));
            };
        return ('string' === typeof xs) ? (
            cons('')(nonEmptySubsequences(xs.split(''))
                .map(x => ''.concat.apply('', x)))
        ) : cons([])(nonEmptySubsequences(xs));
    };

    // MAIN ---
    return main();
})();
