(() => {
    "use strict";

    // ---------------- UNIQUE CHARACTERS ----------------

    // uniques :: [String] -> [Char]
    const uniques = xs =>
        group(
            xs.flatMap(x => [...x])
            .sort()
        )
        .flatMap(
            x => 1 === x.length ? (
                x
            ) : []
        );

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        uniques([
            "133252abcdeeffd",
            "a6789798st",
            "yxcdfgxcyz"
        ]);


    // --------------------- GENERIC ---------------------

    // group :: Eq a => [a] -> [[a]]
    const group = xs => {
        // A list of lists, each containing only equal elements,
        // such that the concatenation of these lists is xs.
        const go = ys =>
            0 < ys.length ? (() => {
                const
                    h = ys[0],
                    i = ys.findIndex(y => h !== y);

                return i !== -1 ? (
                    [ys.slice(0, i)].concat(go(ys.slice(i)))
                ) : [ys];
            })() : [];

        return go(xs);
    };


    // MAIN ---
    return JSON.stringify(main());
})();
