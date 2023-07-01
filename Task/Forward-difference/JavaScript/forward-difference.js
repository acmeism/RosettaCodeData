(() => {
    'use strict';

    // forwardDifference :: Num a => [a] -> [a]
    const forwardDifference = xs =>
        zipWith(subtract)(xs)(tail(xs));


    // nthForwardDifference :: Num a => [a] -> Int -> [a]
    const nthForwardDifference = xs =>
        index(iterate(forwardDifference)(xs)).Just;


    //----------------------- TEST ------------------------
    // main :: IO ()
    const main = () =>
        unlines(
            take(10)(
                iterate(forwardDifference)(
                    [90, 47, 58, 29, 22, 32, 55, 5, 55, 73]
                )
            ).map((x, i) => justifyRight(2)('x')(i) + (
                ' -> '
            ) + JSON.stringify(x))
        );


    //----------------- GENERIC FUNCTIONS -----------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });


    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });


    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });


    // index (!!) :: [a] -> Int -> Maybe a
    // index (!!) :: Generator (Int, a) -> Int -> Maybe a
    // index (!!) :: String -> Int -> Maybe Char
    const index = xs => i => {
        const s = xs.constructor.constructor.name;
        return 'GeneratorFunction' !== s ? (() => {
            const v = xs[i];
            return undefined !== v ? Just(v) : Nothing();
        })() : Just(take(i)(xs), xs.next().value);
    };


    // iterate :: (a -> a) -> a -> Gen [a]
    const iterate = f =>
        function*(x) {
            let v = x;
            while (true) {
                yield(v);
                v = f(v);
            }
        };

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padStart(n, c)
        ) : s;

    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => (
            Array.isArray(xs) ? (
                xs
            ) : xs.split('')
        ).map(f);


    // subtract :: Num -> Num -> Num
    const subtract = x =>
        y => y - x;


    // tail :: [a] -> [a]
    const tail = xs =>
        // A new list consisting of all
        // items of xs except the first.
        0 < xs.length ? xs.slice(1) : [];


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => 'GeneratorFunction' !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join('\n');


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys => {
        const
            lng = Math.min(length(xs), length(ys)),
            [as, bs] = [xs, ys].map(take(lng));
        return Array.from({
            length: lng
        }, (_, i) => f(as[i])(
            bs[i]
        ));
    };

    // MAIN ---
    return main();
})();
