(n => {
    'use strict';

    // GENERIC FUNCTIONS ------------------------------------------------------

    // bind (>>=) :: Monad m => m a -> (a -> m b) -> m b
    const bind = (m, mf) =>
        Array.isArray(m) ? (
            bindList(m, mf)
        ) : bindMay(m, mf);

    // bindList (>>=) :: [a] -> (a -> [b]) -> [b]
    const bindList = (xs, mf) => [].concat.apply([], xs.map(mf));

    // enumFromTo :: Enum a => a -> a -> [a]
    const enumFromTo = (m, n) =>
        (typeof m !== 'number' ? (
            enumFromToChar
        ) : enumFromToInt)
        .apply(null, [m, n]);

    // enumFromToInt :: Int -> Int -> [Int]
    const enumFromToInt = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);


    // EXAMPLE ----------------------------------------------------------------

    // [(x, y, z) | x <- [1..n], y <- [x..n], z <- [y..n], x ^ 2 + y ^ 2 == z ^ 2]

    return   bind(enumFromTo(1, n),
        x => bind(enumFromTo(x, n),
        y => bind(enumFromTo(y, n),
        z => x * x + y * y === z * z ? [
                    [x, y, z]
            ] : []
        )));

})(20);
