(() => {
    'use strict';

    // main :: IO ()
    const main = () => {
        const xs = [
            'ABCD', 'CABD', 'ACDB', 'DACB', 'BCDA', 'ACBD',
            'ADCB', 'CDAB', 'DABC', 'BCAD', 'CADB', 'CDBA',
            'CBAD', 'ABDC', 'ADBC', 'BDCA', 'DCBA', 'BACD',
            'BADC', 'BDAC', 'CBDA', 'DBCA', 'DCAB'
        ];

        return xs.reduce(
            (a, x) => zipWith(xor)(a)(codes(x)),
            [0, 0, 0, 0]
        ).map(x => String.fromCodePoint(x)).join('')
    };

    // ---------------------- GENERIC ----------------------

    // codes :: String -> [Int]
    const codes = s =>
        s.split('').map(c => c.codePointAt(0));

    // xor :: Int -> Int -> Int
    const xor = a =>
        b => (a ^ b)

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => xs.slice(0).map(
            (x, i) => f(x)(ys[i])
        );

    return main()
})();
