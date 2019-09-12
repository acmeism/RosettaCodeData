(() => {
    'use strict';

    // permutations :: [a] -> [[a]]
    const permutations = xs => {
        const go = xs => xs.length ? (
            concatMap(
                x => concatMap(
                    ys => [[x].concat(ys)],
                    go(delete_(x, xs))), xs
                )
        ) : [[]];
        return go(xs);
    };

    // GENERIC FUNCTIONS ----------------------------------

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.reduce((a, x) => a.concat(f(x)), []);


    // delete :: Eq a => a -> [a] -> [a]
    const delete_ = (x, xs) => {
        const go = xs => {
            return 0 < xs.length ? (
                (x === xs[0]) ? (
                    xs.slice(1)
                ) : [xs[0]].concat(go(xs.slice(1)))
            ) : [];
        }
        return go(xs);
    };

    // TEST
    return JSON.stringify(
        permutations(['Aardvarks', 'eat', 'ants'])
    );
})();
