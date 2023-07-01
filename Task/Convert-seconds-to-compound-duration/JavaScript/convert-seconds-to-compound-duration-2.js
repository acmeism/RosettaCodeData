(() => {
    "use strict";

    // ---------------- COMPOUND DURATION ----------------

    // compoundDuration :: [String] -> Int -> String
    const compoundDuration = labels =>
        nSeconds => weekParts(nSeconds)
        .map((v, i) => [v, labels[i]])
        .reduce((a, x) =>
            a.concat(
                x[0] ? [
                    `${x[0]} ${x[1] || "?"}`
                ] : []
            ), []
        )
        .join(", ");


    // weekParts :: Int -> [Int]
    const weekParts = nSeconds => [0, 7, 24, 60, 60]
        .reduceRight((a, x) => {
            const
                r = a[0],
                mod = x !== 0 ? r % x : r;

            return [
                (r - mod) / (x || 1),
                [mod, ...a[1]]
            ];
        }, [nSeconds, []])[1];


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const localNames = ["wk", "d", "hr", "min", "sec"];

        return [7259, 86400, 6E6]
            .map(nSeconds =>
                `${nSeconds} -> ${
                compoundDuration(localNames)(nSeconds)
            }`).join("\n");
    };

    // MAIN ---
    return main();
})();
