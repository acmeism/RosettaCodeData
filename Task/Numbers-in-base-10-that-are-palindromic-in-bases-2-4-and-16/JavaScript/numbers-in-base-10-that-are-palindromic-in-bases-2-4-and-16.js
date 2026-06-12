(() => {
    "use strict";

    // -------------------- PREDICATE --------------------

    // p :: Int -> Bool
    const p = n =>
        [2, 4, 16].every(base => {
            const s = n.toString(base);

            return s === Array.from(s).toReversed().join("");
        });


    // ---------------------- TEST -----------------------
    const main = () =>
        JSON.stringify(
            enumFromTo(1)(24999).filter(p)
        );


    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        // Enumeration of the integers from m to n.
        n => Array.from(
            { length: 1 + n - m },
            (_, i) => m + i
        );


    // MAIN ---
    return main();
})();
