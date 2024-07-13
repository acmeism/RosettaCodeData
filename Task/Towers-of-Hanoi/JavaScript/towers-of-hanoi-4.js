(() => {
    "use strict";

    // ----------------- TOWERS OF HANOI -----------------

    // hanoi :: Int -> String -> String ->
    // String -> [[String, String]]
    const hanoi = n =>
        (a, b, c) => {
            const go = hanoi(n - 1);

            return n
                ? [
                    ...go(a, c, b),
                    [a, b],
                    ...go(c, b, a)
                ]
                : [];
        };


    // ---------------------- TEST -----------------------
    return hanoi(3)("left", "right", "mid")
    .map(d => `${d[0]} -> ${d[1]}`)
    .join("\n");
})();
