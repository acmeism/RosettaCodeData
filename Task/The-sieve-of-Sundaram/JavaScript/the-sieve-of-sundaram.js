(() => {
    "use strict";

    // ----------------- SUNDARAM PRIMES -----------------

    // sundaramsUpTo :: Int -> [Int]
    const sundaramsUpTo = n => {
        const
            m = Math.floor(n - 1) / 2,
            excluded = new Set(
                enumFromTo(1)(
                    Math.floor(Math.sqrt(m / 2))
                )
                .flatMap(
                    i => enumFromTo(i)(
                        Math.floor((m - i) / (1 + (2 * i)))
                    )
                    .flatMap(
                        j => [(2 * i * j) + i + j]
                    )
                )
            );

        return enumFromTo(1)(m).flatMap(
            x => excluded.has(x) ? (
                []
            ) : [1 + (2 * x)]
        );
    };


    // nSundaramsPrimes :: Int -> [Int]
    const nSundaramPrimes = n =>
        sundaramsUpTo(
            // Probable limit
            Math.floor((2.4 * n * Math.log(n)) / 2)
        )
        .slice(0, n);


    // ---------------------- TEST -----------------------
    const main = () => [
        "First 100 Sundaram primes",
        "(starting at 3):\n",
        table(10)(" ")(
            nSundaramPrimes(100)
            .map(n => `${n}`)
        )
    ].join("\n");


    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // --------------------- DISPLAY ---------------------

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n => {
        // xs split into sublists of length n.
        // The last sublist will be short if n
        // does not evenly divide the length of xs.
        const go = xs => {
            const chunk = xs.slice(0, n);

            return 0 < chunk.length ? (
                [chunk].concat(
                    go(xs.slice(n))
                )
            ) : [];
        };

        return go;
    };


    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => Boolean(s) ? (
            s.padStart(n, c)
        ) : "";


    // table :: Int -> String -> [String] -> String
    const table = nCols =>
        // A tabulation of a list of values into a given
        // number of columns, using a specified gap
        // between those columns.
        gap => xs => {
            const w = xs[xs.length - 1].length;

            return chunksOf(nCols)(xs)
                .map(
                    row => row.map(
                        justifyRight(w)(" ")
                    ).join(gap)
                )
                .join("\n");
        };

    return main();
})();
