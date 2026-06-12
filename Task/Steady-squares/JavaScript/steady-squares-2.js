(() => {
    "use strict";

    // ----------------- STEADY SQUARES ------------------

    // isSteady :: Int -> Bool
    const isSteady = n =>
        Boolean(steadyPair(n).length);


    // steadyPair :: Int -> [(String, String)]
    const steadyPair = n => {
        // An empty list if n is not steady, otherwise a
        // list containing a tuple of (n, n^2) strings.
        const
            s = `${n}`,
            s2 = `${n ** 2}`;

        return s2.endsWith(s) ? [
            [s, s2]
        ] : [];
    };

    // ---------------------- TESTS ----------------------
    const main = () => {
        const
            range = enumFromTo(0)(1E4),
            pairs = range.flatMap(steadyPair),
            [w, w2] = pairs[pairs.length - 1]
            .map(x => x.length);

        return [
                range.filter(isSteady).join(", "),

                pairs.map(([n, n2]) => {
                    const
                        steady = n.padStart(w, " "),
                        square = n2.padStart(w2, " ");

                    return `${steady} -> ${square}`;
                })
                .join("\n")
            ]
            .join("\n\n");
    };

    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // MAIN ---
    return main();
})();
