(() => {
    'use strict';

    const main = () =>
        showJSON(
            map( // Using a tolerance epsilon of 1/10000
                n => showRatio(approxRatio(0.0001)(n)),
                [0.9054054, 0.518518, 0.75]
            )
        );

    // Epsilon -> Real -> Ratio

    // approxRatio :: Real -> Real -> Ratio
    const approxRatio = eps => n => {
        const
            gcde = (e, x, y) => {
                const _gcd = (a, b) => (b < e ? a : _gcd(b, a % b));
                return _gcd(Math.abs(x), Math.abs(y));
            },
            c = gcde(Boolean(eps) ? eps : (1 / 10000), 1, n);
        return Ratio(
            Math.floor(n / c), // numerator
            Math.floor(1 / c) // denominator
        );
    };

    // GENERIC FUNCTIONS ----------------------------------

    // Ratio :: Int -> Int -> Ratio
    const Ratio = (n, d) => ({
        type: 'Ratio',
        'n': n, // numerator
        'd': d // denominator
    });

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // showJSON :: a -> String
    const showJSON = x => JSON.stringify(x, null, 2);

    // showRatio :: Ratio -> String
    const showRatio = nd =>
        nd.n.toString() + '/' + nd.d.toString();

    // MAIN ---
    return main();
})();
