(() => {
    "use strict";

    // -------- SHIFT LIST ELEMENTS TO LEFT BY 3 ---------

    // rotated :: Int -> [a] -> [a]
    const rotated = n =>
        // A rotation, n elements to the left,
        // of the input list.
        xs => 0 !== n ? (() => {
            const m = mod(n)(xs.length);

            return xs.slice(m).concat(
                xs.slice(0, m)
            );
        })() : Array.from(xs);


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const xs = [1, 2, 3, 4, 5, 6, 7, 8, 9];

        return [
                `    The input list: ${show(xs)}`,
                ` rotated 3 to left: ${show(rotated(3)(xs))}`,
                `     or 3 to right: ${show(rotated(-3)(xs))}`
            ]
            .join("\n");
    };

    // --------------------- GENERIC ---------------------

    // mod :: Int -> Int -> Int
    const mod = n =>
        // Inherits the sign of the *divisor* for non zero
        // results. Compare with `rem`, which inherits
        // the sign of the *dividend*.
        d => (n % d) + (
            signum(n) === signum(-d) ? (
                d
            ) : 0
        );


    // signum :: Num -> Num
    const signum = n =>
        0 > n ? (
            -1
        ) : (
            0 < n ? 1 : 0
        );


    // show :: a -> String
    const show = x =>
        JSON.stringify(x);

    // MAIN ---
    return main();
})();
