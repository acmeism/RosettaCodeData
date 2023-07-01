(() => {
    "use strict";

    // ------------------ MAX PATH SUM -------------------

    // Working from the bottom of the triangle upwards,
    // summing each number with the larger of the two below
    // until the maximum emerges at the top.

    // maxPathSum ::[[Int]] -> Int
    const maxPathSum = xss =>
        // A list of lists folded down to a list of just one
        // remaining integer.
        foldr1(
            // The accumulator, zipped with the tail of the
            // accumulator, yields pairs of adjacent sums.
            (ys, xs) => zipWith3(

                // Plus greater of two below
                (a, b, c) => a + Math.max(b, c)
            )(xs)(ys)(ys.slice(1))
        )(xss)[0];


    // ---------------- GENERIC FUNCTIONS ----------------

    // foldr1 :: (a -> a -> a) -> [a] -> a
    const foldr1 = f =>
        xs => 0 < xs.length ? (
            xs.slice(0, -1).reduceRight(
                f, xs.slice(-1)[0]
            )
        ) : [];


    // zipWith3 :: (a -> b -> c -> d) ->
    // [a] -> [b] -> [c] -> [d]
    const zipWith3 = f =>
        xs => ys => zs => Array.from({
            length: Math.min(
                ...[xs, ys, zs].map(x => x.length)
            )
        }, (_, i) => f(xs[i], ys[i], zs[i]));


    // ---------------------- TEST -----------------------
    return maxPathSum([
        [55],
        [94, 48],
        [95, 30, 96],
        [77, 71, 26, 67],
        [97, 13, 76, 38, 45],
        [7, 36, 79, 16, 37, 68],
        [48, 7, 9, 18, 70, 26, 6],
        [18, 72, 79, 46, 59, 79, 29, 90],
        [20, 76, 87, 11, 32, 7, 7, 49, 18],
        [27, 83, 58, 35, 71, 11, 25, 57, 29, 85],
        [14, 64, 36, 96, 27, 11, 58, 56, 92, 18, 55],
        [2, 90, 3, 60, 48, 49, 41, 46, 33, 36, 47, 23],
        [92, 50, 48, 2, 36, 59, 42, 79, 72, 20, 82, 77, 42],
        [56, 78, 38, 80, 39, 75, 2, 71, 66, 66, 1, 3, 55, 72],
        [44, 25, 67, 84, 71, 67, 11, 61, 40, 57, 58, 89, 40, 56, 36],
        [85, 32, 25, 85, 57, 48, 84, 35, 47, 62, 17, 1, 1, 99, 89, 52],
        [6, 71, 28, 75, 94, 48, 37, 10, 23, 51, 6, 48, 53, 18, 74, 98, 15],
        [27, 2, 92, 23, 8, 71, 76, 84, 15, 52, 92, 63, 81, 10, 44, 10, 69, 93]
    ]);
})();
