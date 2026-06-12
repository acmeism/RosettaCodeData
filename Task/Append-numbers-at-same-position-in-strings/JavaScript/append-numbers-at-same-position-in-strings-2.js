(() => {
    "use strict";

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with a
        // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        )
            .slice(
                0, Math.min(xs.length, ys.length)
            );


    // ---------------------- TEST -----------------------
    const
        list1 = [1, 2, 3, 4, 5, 6, 7, 8, 9],
        list2 = [10, 11, 12, 13, 14, 15, 16, 17, 18],
        list3 = [19, 20, 21, 22, 23, 24, 25, 26, 27];

    // append :: String -> String -> String
    const append = a => b => `${a}${b}`;

    return zipWith(append)(
        list1
    )(
        zipWith(append)(
            list2
        )(
            list3
        )
    )
        .join("\n");
})();
