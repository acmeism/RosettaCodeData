(() => {
    "use strict";

    // -- MINIMUM NUMBER OF COINS TO MAKE A GIVEN VALUE --

    // change :: [Int] -> Int -> [(Int, Int)]
    const change = denominations =>
        // A minimum list of (quantity, value) pairs for n.
        // Unused denominations are excluded from the list.
        n => {
            const m = Math.abs(n);

            return 0 < denominations.length && 0 < m
                ? (() => {
                    const
                        [h, ...t] = denominations,
                        q = Math.trunc(m / h);

                    return (
                        0 < q
                            ? [[q, h]]
                            : []
                    )
                        .concat(change(t)(m % h));
                })()
                : [];
        };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        // Two sums tested with a set of denominations.
        const f = change([200, 100, 50, 20, 10, 5, 2, 1]);

        return [1024, 988].reduce(
            (acc, n) => {
                const
                    report = f(n).reduce(
                        (a, [q, u]) => `${a}${q} * ${u}\n`,
                        ""
                    );

                return `${acc}Summing to ${Math.abs(n)}:\n` + (
                    `${report}\n`
                );
            },
            ""
        );
    };


    // MAIN ---
    return main();
})();
