(() => {
    "use strict";

    // - APPROXIMATION OF E OBTAINED AFTER N ITERATIONS --

    // eApprox : Int -> Float
    const eApprox = n =>
        sum(
            scanl(mul)(1)(
                enumFromTo(1)(n)
            )
            .map(x => 1 / x)
        );


    // ---------------------- TEST -----------------------
    const main = () =>
        eApprox(20);


    // ---------------- GENERIC FUNCTIONS ----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // mul (*) :: Num a => a -> a -> a
    const mul = a =>
        // The arithmetic product of a and b.
        b => a * b;


    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = f => startValue => xs =>
        // The series of interim values arising
        // from a catamorphism. Parallel to foldl.
        xs.reduce((a, x) => {
            const v = f(a[0])(x);

            return [v, a[1].concat(v)];
        }, [startValue, [startValue]])[1];


    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


    // MAIN ---
    return main();
})();
