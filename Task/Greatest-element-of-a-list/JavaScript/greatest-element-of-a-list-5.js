(() => {
    'use strict';

    // MAXIMUM BY ... --------------------------------------------------------

    // Ordering: (LT|EQ|GT):
    //  GT: 1 (or other positive n)
    //  EQ: 0
    //  LT: -1 (or other negative n)
    // maximumByMay :: (a -> a -> Ordering) -> [a] -> Maybe a
    const maximumByMay = (f, xs) =>
        xs.length > 0 ? (
            just(xs.slice(1)
                .reduce((a, x) => f(x, a) > 0 ? x : a, xs[0]))
        ) : nothing('Empty list');


    // GENERIC FUNCTIONS -----------------------------------------------------

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : a > b ? 1 : 0
        };

    // catMaybes :: [Maybe a] -> [a]
    const catMaybes = mbs =>
        concatMap(m => m.nothing ? [] : [m.just], mbs);

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.length > 0 ? [].concat.apply([], xs.map(f)) : [];

    // just :: a -> Just a
    const just = x => ({
        nothing: false,
        just: x
    });

    // nothing :: () -> Nothing
    const nothing = (optionalMsg) => ({
        nothing: true,
        msg: optionalMsg
    });

    // show :: Int -> a -> Indented String
    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[1], null, x[0]] : x
        );

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
    }, {
        k: 'Tokyo',
        n: 13.2
    }];

    // length :: [a] -> Int
    const length = xs => xs.length;

    // population :: {k: String, n: Float}
    const population = dct => dct.n;

    // OUTPUT ----------------------------------------------------------------
    const maxima = ([
        maximumByMay(comparing(length), words),
        maximumByMay(comparing(length), []),
        maximumByMay(comparing(population), cities)
    ]);

    return show(2,
        catMaybes(maxima)
    );
})();
