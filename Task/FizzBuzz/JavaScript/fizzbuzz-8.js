(() => {
    'use strict';

    // main :: IO ()
    const main = () => {

        // FIZZBUZZ ---------------------------------------

        // fizzBuzz :: Generator [String]
        const fizzBuzz = () => {
            const fb = n => k => cycle(
                replicate(n - 1)('').concat(k)
            );
            return zipWith(
                liftA2(flip)(bool)(isNull)
            )(
                zipWith(append)(fb(3)('fizz'))(fb(5)('buzz'))
            )(fmap(str)(enumFrom(1)));
        };

        // TEST -------------------------------------------
        console.log(
            unlines(
                take(100)(
                    fizzBuzz()
                )
            )
        );
    };

    // GENERIC FUNCTIONS ----------------------------------

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
    const Tuple = a => b => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = xs => ys => xs.concat(ys);

    // bool :: a -> a -> Bool -> a
    const bool = f => t => p =>
        p ? t : f;

    // cycle :: [a] -> Generator [a]
    function* cycle(xs) {
        const lng = xs.length;
        let i = 0;
        while (true) {
            yield(xs[i])
            i = (1 + i) % lng;
        }
    }

    // enumFrom :: Int => Int -> [Int]
    function* enumFrom(x) {
        let v = x;
        while (true) {
            yield v;
            v = 1 + v;
        }
    }

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        x => y => f(y)(x);

    // fmap <$> :: (a -> b) -> Gen [a] -> Gen [b]
    const fmap = f =>
        function*(gen) {
            let v = take(1)(gen);
            while (0 < v.length) {
                yield(f(v[0]))
                v = take(1)(gen)
            }
        };

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // isNull :: [a] -> Bool
    // isNull :: String -> Bool
    const isNull = xs =>
        1 > xs.length;

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // liftA2 :: (a0 -> b -> c) -> (a -> a0) -> (a -> b) -> a -> c
    const liftA2 = op => f => g =>
        // Lift a binary function to a composition
        // over two other functions.
        // liftA2 (*) (+ 2) (+ 3) 7 == 90
        x => op(f(x))(g(x));

    // replicate :: Int -> a -> [a]
    const replicate = n => x =>
        Array.from({
            length: n
        }, () => x);

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // str :: a -> String
    const str = x => x.toString();

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

    // The first argument is a sample of the type
    // allowing the function to make the right mapping

    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => {
        const lng = length(xs);
        return (0 < lng) ? (
            lng < Infinity ? (
                Just(Tuple(xs[0])(xs.slice(1))) // Finite list
            ) : (() => {
                const nxt = take(1)(xs);
                return 0 < nxt.length ? (
                    Just(Tuple(nxt[0])(xs))
                ) : Nothing();
            })() // Lazy generator
        ) : Nothing();
    };

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // zipWith :: (a -> b -> c) Gen [a] -> Gen [b] -> Gen [c]
    const zipWith = f => ga => gb => {
        function* go(ma, mb) {
            let
                a = ma,
                b = mb;
            while (!a.Nothing && !b.Nothing) {
                let
                    ta = a.Just,
                    tb = b.Just
                yield(f(fst(ta))(fst(tb)));
                a = uncons(snd(ta));
                b = uncons(snd(tb));
            }
        }
        return go(uncons(ga), uncons(gb));
    };

    // MAIN ---
    return main();
})();
