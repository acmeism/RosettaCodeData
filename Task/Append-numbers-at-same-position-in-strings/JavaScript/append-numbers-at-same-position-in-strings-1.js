(() => {
    "use strict";

    // -------------------- ZIPWITH3 ---------------------

    // zipWith3 :: (a -> b -> c -> d) ->
    // [a] -> [b] -> [c] -> [d]
    const zipWith3 = f =>
        xs => ys => zs => Array.from({
            length: Math.min(
                ...[xs, ys, zs].map(x => x.length)
            )
        }, (_, i) => f(xs[i])(ys[i])(zs[i]));

    // ---------------------- TEST -----------------------

    const
        list1 = [1, 2, 3, 4, 5, 6, 7, 8, 9],
        list2 = [10, 11, 12, 13, 14, 15, 16, 17, 18],
        list3 = [19, 20, 21, 22, 23, 24, 25, 26, 27];

    return zipWith3(x => y => z => `${x}${y}${z}`)(
        list1
    )(
        list2
    )(
        list3
    )
        .join("\n");
})();
