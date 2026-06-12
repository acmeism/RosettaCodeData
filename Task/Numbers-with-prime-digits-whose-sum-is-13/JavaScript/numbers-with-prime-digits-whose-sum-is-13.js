(() => {
    'use strict';

    // ---- NUMBERS WITH PRIME DIGITS WHOSE SUM IS 13 ----

    // primeDigitsSummingToN :: Int -> [Int]
    const primeDigitsSummingToN = n => {
        const primeDigits = [2, 3, 5, 7];
        const go = xs =>
            fanArrow(
                concatMap( // Harvested,
                    nv => n === nv[1] ? (
                        [unDigits(nv[0])]
                    ) : []
                )
            )(
                concatMap( // Pruned.
                    nv => pred(n) > nv[1] ? (
                        [nv[0]]
                    ) : []
                )
            )(
                // Existing numbers with prime digits appended,
                // tupled with the resulting digit sums.
                xs.flatMap(
                    ds => primeDigits.flatMap(d => [
                        fanArrow(identity)(sum)(
                            ds.concat(d)
                        )
                    ])
                )
            );
        return concat(
            unfoldr(
                xs => 0 < xs.length ? (
                    Just(go(xs))
                ) : Nothing()
            )(
                primeDigits.map(pureList)
            )
        );
    }

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        chunksOf(6)(
            primeDigitsSummingToN(13)
        ).forEach(
            x => console.log(x)
        )


    // ---------------- GENERIC FUNCTIONS ----------------

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

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n =>
        xs => enumFromThenTo(0)(n)(
            xs.length - 1
        ).reduce(
            (a, i) => a.concat([xs.slice(i, (n + i))]),
            []
        );


    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs => (
        ys => 0 < ys.length ? (
            ys.every(Array.isArray) ? (
                []
            ) : ''
        ).concat(...ys) : ys
    )(list(xs));


    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = f =>
        xs => xs.flatMap(f)


    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = x1 =>
        x2 => y => {
            const d = x2 - x1;
            return Array.from({
                length: Math.floor(y - x2) / d + 2
            }, (_, i) => x1 + (d * i));
        };


    // fanArrow (&&&) :: (a -> b) -> (a -> c) -> (a -> (b, c))
    const fanArrow = f =>
        // A function from x to a tuple of (f(x), g(x))
        // ((,) . f <*> g)
        g => x => Tuple(f(x))(
            g(x)
        );


    // identity :: a -> a
    const identity = x =>
        // The identity function.
        x;


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // pred :: Enum a => a -> a
    const pred = x =>
        x - 1;


    // pureList :: a -> [a]
    const pureList = x => [x];

    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


    // unDigits :: [Int] -> Int
    const unDigits = ds =>
        // The integer with the given digits.
        ds.reduce((a, x) => 10 * a + x, 0);


    // The 'unfoldr' function is a *dual* to 'foldr':
    // while 'foldr' reduces a list to a summary value,
    // 'unfoldr' builds a list from a seed value.

    // unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
    const unfoldr = f =>
        v => {
            const xs = [];
            let xr = [v, v];
            while (true) {
                const mb = f(xr[1]);
                if (mb.Nothing) {
                    return xs;
                } else {
                    xr = mb.Just;
                    xs.push(xr[0]);
                }
            }
        };

    return main();
})();
