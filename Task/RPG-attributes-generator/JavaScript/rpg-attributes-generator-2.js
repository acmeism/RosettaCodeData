(() => {
    'use strict';

    // main :: IO ()
    const main = () =>
        // 10 random heroes drawn from
        // a non-finite series.
        unlines(map(
            xs => show(sum(xs)) +
            ' -> [' + show(xs) + ']',

            take(10, heroes(
                seventyFivePlusWithTwo15s
            ))
        ));

    // seventyFivePlusWithTwo15s :: [Int] -> Bool
    const seventyFivePlusWithTwo15s = xs =>
        // Total score over 75,
        // with two or more qualities scoring 15.
        75 < sum(xs) && 1 < length(filter(
            x => 15 === x, xs
        ));

    // heroes :: Gen IO [(Int, Int, Int, Int, Int, Int)]
    function* heroes(p) {
        // Non-finite list of heroes matching
        // the requirements of predicate p.
        while (true) {
            yield hero(p)
        }
    }

    // hero :: (Int -> Bool) -> IO (Int, Int, Int, Int, Int, Int)
    const hero = p =>
        // A random character matching the
        // requirements of predicate p.
        until(p, character, []);

    // character :: () -> IO [Int]
    const character = () =>
        // A random character with six
        // integral attributes.
        map(() => sum(tail(sort(map(
                randomRInt(1, 6),
                enumFromTo(1, 4)
            )))),
            enumFromTo(1, 6)
        );


    // GENERIC FUNCTIONS ----------------------------------

    // enumFromTo :: (Int, Int) -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // e.g. map(randomRInt(1, 10), enumFromTo(1, 20))

    // randomRInt :: Int -> Int -> IO () -> Int
    const randomRInt = (low, high) => () =>
        low + Math.floor(
            (Math.random() * ((high - low) + 1))
        );

    // show :: a -> String
    const show = x => x.toString()

    // sort :: Ord a => [a] -> [a]
    const sort = xs => xs.slice()
        .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return main();
})();
