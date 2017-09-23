(() => {
    'use strict';

    // MAXIMUM BY ... --------------------------------------------------------

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        xs.reduce((a, x) => a === undefined ? x : (
            f(x, a) > 0 ? x : a
        ), undefined);

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : a > b ? 1 : 0
        };


    // TEST ------------------------------------------------------------------
    const words = ["alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta"];
    const cities = [{
        k: 'Bejing',
        n: 21.5
    }, {
        k: 'Delhi',
        n: 16.7
    }, {
        k: 'Karachi',
        n: 23.5
    }, {
        k: 'Lagos',
        n: 16.0
    }, {
        k: 'Shanghai',
        n: 24.3
    }];

    // length :: [a] -> Int
    const length = xs => xs.length;

    // population :: {k: String, n: Float}
    const population = dct => dct.n;

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    // OUTPUT ----------------------------------------------------------------
    return show({
        byWordLength: maximumBy(comparing(length), words),
        byCityPopulation: maximumBy(comparing(population), cities)
    });
})();
