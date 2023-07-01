(() => {
    "use strict";

    // ------------------- DOT PRODUCT -------------------

    // dotProduct :: [Num] -> [Num] -> Either Null Num
    const dotProduct = xs =>
        ys => xs.length === ys.length
            ? sum(zipWith(mul)(xs)(ys))
            : null;


    // ---------------------- TEST -----------------------

    // main :: IO ()
    const main = () =>
        dotProduct([1, 3, -5])([4, -2, -1]);


    // --------------------- GENERIC ---------------------

    // mul :: Num -> Num -> Num
    const mul = x =>
        y => x * y;


    // sum :: [Num] -> Num
    const sum = xs =>
    // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
    // A list constructed by zipping with a
    // custom function, rather than with the
    // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        ).slice(
            0, Math.min(xs.length, ys.length)
        );

    // MAIN ---
    return main();
})();
