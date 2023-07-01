(() => {
    "use strict";

    // -------- STRING SPLIT ON CHARACTER CHANGES --------

    // charGroups :: String -> [String]
    const charGroups = s =>
        // The characters of s split at each point where
        // consecutive characters differ.
        0 < s.length ? (() => {
            const
                c = s[0],
                [xs, ys] = span(x => c === x)([
                    ...s.slice(1)
                ]);

            return [
                    [c, ...xs], ...charGroups(ys)
                ]
                .map(zs => [...zs].join(""));
        })() : "";


    // ---------------------- TEST -----------------------
    // main :: IO()
    const main = () =>
        charGroups("gHHH5YY++///\\")
        .join(", ");


    // --------------------- GENERIC ---------------------

    // span :: (a -> Bool) -> [a] -> ([a], [a])
    const span = p =>
        // Longest prefix of xs consisting of elements which
        // all satisfy p, tupled with the remainder of xs.
        xs => {
            const i = xs.findIndex(x => !p(x));

            return -1 !== i ? [
                xs.slice(0, i),
                xs.slice(i)
            ] : [xs, []];
        };

    // MAIN ---
    return main();
})();
