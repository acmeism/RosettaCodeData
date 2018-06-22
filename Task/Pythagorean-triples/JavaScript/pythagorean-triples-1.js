(() => {
    'use strict';

    // Arguments: predicate, maximum perimeter
    // pythTripleCount :: ((Int, Int, Int) -> Bool) -> Int -> Int
    const pythTripleCount = (p, maxPerim) => {
        const xs = enumFromTo(1, Math.floor(maxPerim / 2));

        return  concatMap(x =>
                concatMap(y =>
                concatMap(z =>
                    ((x + y + z <= maxPerim) &&
                        (x * x + y * y === z * z) &&
                        p(x, y, z)) ? [
                        [x, y, z]
                    ] : [], // (Empty lists disappear under concatenation)
                xs.slice(y)), xs.slice(x)), xs
            )
            .length;
    };

    // GENERIC FUNCTIONS --------------------------------------

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.length > 0 ? [].concat.apply([], xs.map(f)) : [];

    // enumFromTo :: Enum a => a -> a -> [a]
    const enumFromTo = (m, n) =>
        (typeof m !== 'number' ? (
            enumFromToChar
        ) : enumFromToInt)
        .apply(null, [m, n]);

    // enumFromToInt :: Int -> Int -> [Int]
    const enumFromToInt = (m, n) =>
        n >= m ? Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i) : [];

    // gcd :: Int -> Int -> Int
    const gcd = (x, y) => {
        const _gcd = (a, b) => (b === 0 ? a : _gcd(b, a % b));
        return _gcd(Math.abs(x), Math.abs(y));
    };

    // MAIN ---------------------------------------------------
    return [10, 100, 1000]
        .map(n => ({
            maxPerimeter: n,
            triples: pythTripleCount(x => true, n),
            primitives: pythTripleCount((x, y, _) => gcd(x, y) === 1, n)
        }));

})();
