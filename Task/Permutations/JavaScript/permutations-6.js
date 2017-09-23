(() => {
    'use strict';

    // permutations :: [a] -> [[a]]
    const permutations = xs =>
        xs.length ? concatMap(x => concatMap(ys => [
                [x].concat(ys)
            ],
            permutations(delete_(x, xs))), xs) : [
            []
        ];

    // GENERIC FUNCTIONS

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));
    //
    // // delete :: Eq a => a -> [a] -> [a]
    // const delete_ = (x, xs) =>
    //     deleteBy((a, b) => a === b, x, xs);

    // delete_ :: Eq a => a -> [a] -> [a]
    const delete_ = (x, xs) =>
        xs.length > 0 ? (
            (x === xs[0]) ? (
                xs.slice(1)
            ) : [xs[0]].concat(delete_(x, xs.slice(1)))
        ) : [];

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // TEST
    return permutations(['Aardvarks', 'eat', 'ants']);
})();
