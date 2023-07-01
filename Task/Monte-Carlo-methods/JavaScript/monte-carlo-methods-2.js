(() => {
    "use strict";

    // --- APPROXIMATION OF PI BY A MONTE CARLO METHOD ---

    // monteCarloPi :: Int -> Float
    const monteCarloPi = n =>
        4 * enumFromTo(1)(n).reduce(a => {
            const [x, y] = [rnd(), rnd()];

            return (x ** 2) + (y ** 2) < 1 ? (
                1 + a
            ) : a;
        }, 0) / n;


    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // rnd :: () -> Float
    const rnd = Math.random;


    // ---------------------- TEST -----------------------
    // From 1000 samples to 10E7 samples
    return enumFromTo(3)(7).forEach(x => {
        const nSamples = 10 ** x;

        console.log(
            `${nSamples} samples: ${monteCarloPi(nSamples)}`
        );
    });
})();
