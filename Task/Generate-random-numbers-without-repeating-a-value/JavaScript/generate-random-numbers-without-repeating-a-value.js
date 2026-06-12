(() => {
    "use strict";

    // ---------- NON-REPEATING RANDOM NUMBERS -----------

    // main :: IO ()
    const main = () =>
        sortOn(Math.random)(
            enumFromTo(1)(20)
        );


    // --------------------- GENERIC ---------------------

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        // The ordering of f(x) and f(y) as a value
        // drawn from {-1, 0, 1}, representing {LT, EQ, GT}.
        x => y => {
            const
                a = f(x),
                b = f(y);

            return a < b ? -1 : (a > b ? 1 : 0);
        };


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = f =>
        // A copy of xs sorted by the comparator function f.
        xs => xs.slice()
        .sort((a, b) => f(a)(b));


    // sortOn :: Ord b => (a -> b) -> [a] -> [a]
    const sortOn = f =>
        // Equivalent to sortBy(comparing(f)), but with f(x)
        // evaluated only once for each x in xs.
        // ('Schwartzian' decorate-sort-undecorate).
        xs => sortBy(
            comparing(x => x[0])
        )(
            xs.map(x => [f(x), x])
        )
        .map(x => x[1]);

    // MAIN ---
    return JSON.stringify(main());
})();
