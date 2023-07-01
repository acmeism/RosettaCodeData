(() => {
    'use strict';

    // populationCount :: Int -> Int
    const populationCount = n =>
        // The number of non-zero bits in the binary
        // representation of the integer n.
        sum(unfoldr(
            x => 0 < x ? (
                Just(Tuple(x % 2)(Math.floor(x / 2)))
            ) : Nothing()
        )(n));

    // ----------------------- TEST ------------------------
    // main :: IO ()
    const main = () => {
        const [evens, odds] = Array.from(
            partition(compose(even, populationCount))(
                enumFromTo(0)(59)
            )
        );
        return [
            'Population counts of the first 30 powers of three:',
            `    [${enumFromTo(0)(29).map(
                    compose(populationCount, raise(3))
                 ).join(',')}]`,
            "\nFirst thirty 'evil' numbers:",
            `    [${[evens.join(',')]}]`,
            "\nFirst thirty 'odious' numbers:",
            `    [${odds.join(',')}]`
        ].join('\n');
    };


    // ----------------- GENERIC FUNCTIONS -----------------

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


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => !isNaN(m) ? (
            Array.from({
                length: 1 + n - m
            }, (_, i) => m + i)
        ) : enumFromTo_(m)(n);


    // even :: Int -> Bool
    const even = n =>
        // True if n is an even number.
        0 === n % 2;


    // partition :: (a -> Bool) -> [a] -> ([a], [a])
    const partition = p =>
        // A tuple of two lists - those elements in
        // xs which match p, and those which don't.
        xs => ([...xs]).reduce(
            (a, x) =>
            p(x) ? (
                Tuple(a[0].concat(x))(a[1])
            ) : Tuple(a[0])(a[1].concat(x)),
            Tuple([])([])
        );


    // raise :: Num -> Int -> Num
    const raise = x =>
        // X to the power of n.
        n => Math.pow(x, n);


    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


    // unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
    const unfoldr = f =>
        v => {
            const xs = [];
            let xr = [v, v];
            while (true) {
                const mb = f(xr[1]);
                if (mb.Nothing) {
                    return xs
                } else {
                    xr = mb.Just;
                    xs.push(xr[0])
                }
            }
        };

    // ---
    return main();
})();
