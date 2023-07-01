(() => {
    'use strict';

    // babbageNumbers :: Int -> [Int]
    const babbageNumbers = n =>
        // Take the first n Babbage numbers,
        take(n)(
            // from the concatenation of outputs of
            // a function which constructs the next number
            // ending in 269696, and returns it wrapped
            // in a list if it is a perfect square,
            // or just returns an empty list if it
            // is not a perfect square.
            // The concatenation of the map output eliminates
            // all empty lists, leaving a sequence of perfect
            // squares which end in 269696.
            concatMap(x => {
                const
                    fx = 269696 + (1000000 * x),
                    root = Math.sqrt(fx);
                return root === Math.floor(root) ? (
                    [Tuple(root)(fx)]
                ) : [];
                // Mapped over non-finite integer series
                // starting with 1.
            })(enumFrom(1))
        );


    // TEST -----------------------------------------------
    const main = () =>
        // List of the first 10 positive integers
        // whose squares end in 269696.
        unlines(
            map(pair => fst(pair) + '^2 -> ' + snd(pair))(
                babbageNumbers(10)
            ));


    // GENERIC FUNCTIONS ----------------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a => b => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // concatMap :: (a -> [b]) -> Gen [a] -> Gen [b]
    const concatMap = f =>
        // Instance of concatMap for non-finite streams.
        function*(xs) {
            let
                x = xs.next(),
                v = undefined;
            while (!x.done) {
                v = f(x.value);
                if (0 < v.length) {
                    yield v[0];
                }
                x = xs.next();
            }
        };

    // enumFrom :: Enum a => a -> [a]
    function* enumFrom(x) {
        let v = x;
        while (true) {
            yield v;
            v = succ(v);
        }
    }

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // root :: Tree a -> a
    const root = tree => tree.root;

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // succ :: Enum a => a -> a
    const succ = x =>
        1 + x;

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n => xs =>
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

    // MAIN ---
    return main();
})();
