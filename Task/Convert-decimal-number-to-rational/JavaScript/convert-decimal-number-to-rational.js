(() => {
    "use strict";

    // ---------------- APPROXIMATE RATIO ----------------

    // approxRatio :: Real -> Real -> Ratio
    const approxRatio = epsilon =>
        n => {
            const
                c = gcdApprox(
                    0 < epsilon
                        ? epsilon
                        : (1 / 10000)
                )(1, n);

            return Ratio(
                Math.floor(n / c),
                Math.floor(1 / c)
            );
        };


    // gcdApprox :: Real -> (Real, Real) -> Real
    const gcdApprox = epsilon =>
        (x, y) => {
            const _gcd = (a, b) =>
                b < epsilon
                    ? a
                    : _gcd(b, a % b);

            return _gcd(Math.abs(x), Math.abs(y));
        };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        // Using a tolerance of 1/10000
        [0.9054054, 0.518518, 0.75]
        .map(
            compose(
                showRatio,
                approxRatio(0.0001)
            )
        )
        .join("\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
    // A function defined by the right-to-left
    // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // Ratio :: Int -> Int -> Ratio
    const Ratio = (n, d) => ({
        type: "Ratio",
        n,
        d
    });


    // showRatio :: Ratio -> String
    const showRatio = nd =>
        `${nd.n.toString()}/${nd.d.toString()}`;


    // MAIN ---
    return main();
})();
