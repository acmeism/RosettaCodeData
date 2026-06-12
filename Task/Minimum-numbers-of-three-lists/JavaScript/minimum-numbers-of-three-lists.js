(() => {
    "use strict";

    const main = () => {
        const
            numbers1 = [5, 45, 23, 21, 67],
            numbers2 = [43, 22, 78, 46, 38],
            numbers3 = [9, 98, 12, 98, 53];

        return transpose([
            numbers1, numbers2, numbers3
        ]).map(minimum);
    };


    // --------------------- GENERIC ---------------------

    // min :: Ord a => (a, a) -> a
    const min = (a, b) =>
        // The lesser of a and b.
        b < a ? b : a;


    // minimum :: Ord a => [a] -> a
    const minimum = xs =>
        // The least value of xs.
        0 < xs.length ? (
            xs.slice(1).reduce(min, xs[0])
        ) : null;


    // transpose :: [[a]] -> [[a]]
    const transpose = rows =>
        // The columns of the input transposed
        // into new rows.
        // Simpler version of transpose, assuming input
        // rows of even length.
        0 < rows.length ? rows[0].map(
            (_, i) => rows.flatMap(
                v => v[i]
            )
        ) : [];

    // MAIN ---
    return JSON.stringify(main());
})();
