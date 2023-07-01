(() => {
    "use strict";

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        0 < xs.length ? (
            xs[0].map(
                (_, iCol) => xs.map(
                    row => row[iCol]
                )
            )
        ) : [];


    // ---------------------- TEST -----------------------
    const main = () =>
        JSON.stringify(
            transpose([
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 9]
            ])
        );


    // MAIN ---
    return main();
})();
