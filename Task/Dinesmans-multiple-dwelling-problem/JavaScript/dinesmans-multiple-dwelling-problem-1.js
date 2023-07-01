(() => {
    'use strict';

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // and :: [Bool] -> Bool
    const and = xs => {
        let i = xs.length;
        while (i--)
            if (!xs[i]) return false;
        return true;
    }

    // nubBy :: (a -> a -> Bool) -> [a] -> [a]
    const nubBy = (p, xs) => {
        const x = xs.length ? xs[0] : undefined;
        return x !== undefined ? [x].concat(
            nubBy(p, xs.slice(1)
                .filter(y => !p(x, y)))
        ) : [];
    }

    // PROBLEM DECLARATION

    const floors = range(1, 5);

    return  concatMap(b =>
            concatMap(c =>
            concatMap(f =>
            concatMap(m =>
            concatMap(s =>
                and([ // CONDITIONS
                    nubBy((a, b) => a === b, [b, c, f, m, s]) // all floors singly occupied
                    .length === 5,
                    b !== 5, c !== 1, f !== 1, f !== 5,
                    m > c, Math.abs(s - f) > 1, Math.abs(c - f) > 1
                ]) ? [{
                    Baker: b,
                    Cooper: c,
                    Fletcher: f,
                    Miller: m,
                    Smith: s
                }] : [],
                floors), floors), floors), floors), floors);

    // --> [{"Baker":3, "Cooper":2, "Fletcher":4, "Miller":5, "Smith":1}]
})();
