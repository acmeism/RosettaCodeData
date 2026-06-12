(() => {
    "use strict";

    const main = () => [
        "(dec, hex)",
        ...enumFromTo(1)(100000).flatMap(n => {
            const
                d = n.toString(10),
                h = n.toString(16);

            return eqSet(new Set(d))(
                new Set(h)
            ) ? [
                `(${d}, ${h})`
            ] : [];
        })
    ].join("\n");


    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // eqSet :: Set a -> Set a -> Bool
    const eqSet = a =>
        // True if the two sets have
        // the same size and members.
        b => a.size === b.size && (
            Array.from(a).every(x => b.has(x))
        );

    // MAIN ---
    return main();
})();
