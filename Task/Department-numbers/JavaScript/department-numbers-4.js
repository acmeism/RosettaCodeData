(() => {
    "use strict";

    // -------------- NUMBERING CONSTRAINTS --------------

    // options :: Int -> Int -> Int -> [(Int, Int, Int)]
    const options = lo => hi => total => {
        const
            bind = xs => f => xs.flatMap(f),
            ds = enumFromTo(lo)(hi);

        return bind(ds.filter(even))(
            x => bind(ds.filter(d => d !== x))(
                y => bind([total - (x + y)])(
                    z => (z !== y && lo <= z && z <= hi) ? [
                        [x, y, z]
                    ] : []
                )
            )
        );
    };

    // ---------------------- TEST -----------------------
    const main = () => {
        const
            label = "(Police, Sanitation, Fire)",
            solutions = options(1)(7)(12),
            n = solutions.length,
            list = solutions
            .map(JSON.stringify)
            .join("\n");

        return (
            `${label}\n\n${list}\n\nNumber of options: ${n}`
        );
    };

    // ---------------- GENERIC FUNCTIONS ----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // even :: Integral a => a -> Bool
    const even = n => n % 2 === 0;

    // MAIN ---
    return main();
})();
