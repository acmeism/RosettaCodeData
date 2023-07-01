(() => {
    'use strict';

    // longestCommon :: String -> String -> String
    const longestCommon = (s1, s2) => maximumBy(
        comparing(length),
        intersect(...apList(
            [s => map(
                concat,
                concatMap(tails, compose(tail, inits)(s))
            )],
            [s1, s2]
        ))
    );

    // main :: IO ()
    const main = () =>
        console.log(
            longestCommon(
                "testing123testing",
                "thisisatest"
            )
        );

    // GENERIC FUNCTIONS ----------------------------

    // Each member of a list of functions applied to each
    // of a list of arguments, deriving a list of new values.

    // apList (<*>) :: [(a -> b)] -> [a] -> [b]
    const apList = (fs, xs) => //
        fs.reduce((a, f) => a.concat(
            xs.reduce((a, x) => a.concat([f(x)]), [])
        ), []);

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (f, g) => x => f(g(x));

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.reduce((a, x) => a.concat(f(x)), []);

    // inits([1, 2, 3]) -> [[], [1], [1, 2], [1, 2, 3]
    // inits('abc') -> ["", "a", "ab", "abc"]

    // inits :: [a] -> [[a]]
    // inits :: String -> [String]
    const inits = xs => [
            []
        ]
        .concat(('string' === typeof xs ? xs.split('') : xs)
            .map((_, i, lst) => lst.slice(0, i + 1)));

    // intersect :: (Eq a) => [a] -> [a] -> [a]
    const intersect = (xs, ys) =>
        xs.filter(x => -1 !== ys.indexOf(x));

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        0 < xs.length ? (
            xs.slice(1)
            .reduce((a, x) => 0 < f(x, a) ? x : a, xs[0])
        ) : undefined;

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

    // tails :: [a] -> [[a]]
    const tails = xs => {
        const
            es = ('string' === typeof xs) ? (
                xs.split('')
            ) : xs;
        return es.map((_, i) => es.slice(i))
            .concat([
                []
            ]);
    };

    // MAIN ---
    return main();
})();
