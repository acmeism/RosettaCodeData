(() => {
    "use strict";

    // ---------------------- TEST -----------------------
    const main = () => {

        // Concatenation of 3 stringifed values.
        const f = x => y => z => `${x}${y}${z}`;

        // Zip list applicative function.
        const apZip = zipWith(x => x);

        const
            xs = [1, 2, 3, 4, 5, 6, 7, 8, 9],
            ys = [10, 11, 12, 13, 14, 15, 16, 17, 18],
            zs = [19, 20, 21, 22, 23, 24, 25, 26, 27];

        return apZip(
            apZip(
                xs.map(f)
            )(ys)
        )(zs)
        .join("\n");
    };

    // --------------------- GENERIC ---------------------

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        )
            .slice(
                0, Math.min(xs.length, ys.length)
            );

    // MAIN ---
    return main();
})();
