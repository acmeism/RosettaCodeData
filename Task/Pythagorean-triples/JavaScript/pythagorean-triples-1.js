(() => {

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // gcd :: Integral a => a -> a -> a
    const gcd = (x, y) => {
        const _gcd = (a, b) => (b === 0 ? a : _gcd(b, a % b)),
            abs = Math.abs;
        return _gcd(abs(x), abs(y));
    }

    // Arguments: predicate, maximum perimeter
    // pythTripleCount :: ((Int, Int, Int) -> Bool) -> Int -> Int
    const pythTripleCount = (p, maxPerim) => {
        const xs = range(1, Math.floor(maxPerim / 2));

        return  concatMap(x =>
                concatMap(y =>
                concatMap(z =>
                (   (x + y + z     <=  maxPerim ) &&
                    (x * x + y * y === z * z    ) &&
                   p(x,  y,  z)                 ) ? [
                                [x, y, z]
                    ] :         [       ], // concatMap eliminates empty lists
                    xs.slice(y)), xs.slice(x)), xs
                )
                .length;
    };

    return [10, 100, 1000]
        .map(n => ({
            maxPerimeter: n,
            triples: pythTripleCount(x => true, n),
            primitives: pythTripleCount((x, y, _) => gcd(x, y) === 1, n)
        }));
})();
