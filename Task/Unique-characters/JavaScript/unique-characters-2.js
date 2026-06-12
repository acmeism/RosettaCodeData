(() => {
    "use strict";

    // uniqueChars :: [String] -> [Char]
    const uniqueChars = ws =>
        Object.entries(
            ws.reduce(
                (dict, w) => [...w].reduce(
                    (a, c) => Object.assign({}, a, {
                        [c]: 1 + (a[c] || 0)
                    }),
                    dict
                ), {}
            )
        )
        .flatMap(
            ([k, v]) => 1 === v ? (
                [k]
            ) : []
        );

    // ---------------------- TEST -----------------------
    const main = () =>
        uniqueChars([
            "133252abcdeeffd", "a6789798st", "yxcdfgxcyz"
        ]);


    return JSON.stringify(main());
})();
