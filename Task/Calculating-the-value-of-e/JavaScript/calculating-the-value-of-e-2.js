(() => {
    "use strict";

    // --------------- APPROXIMATION OF E ----------------

    const eApprox = n =>
        // Approximation of E obtained after Nth iteration.
        enumFromTo(1)(n).reduce(
            ([fl, e], x) => (
                flx => [flx, e + (1 / flx)]
            )(
                fl * x
            ),
            [1, 1]
        )[1];

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        eApprox(20);

    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // MAIN ---
    return main();
})();
