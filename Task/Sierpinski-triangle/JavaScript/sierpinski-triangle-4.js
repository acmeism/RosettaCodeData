(() => {
    "use strict";

    // ----- LINES OF SIERPINSKI TRIANGLE AT LEVEL N -----

    // sierpinski :: Int -> [String]
    const sierpTriangle = n =>
        // Previous triangle centered with
        // left and right padding,
        0 < n ? (
            ap([
                map(
                    xs => ap([
                        compose(
                            ks => ks.join(""),
                            replicate(2 ** (n - 1))
                        )
                    ])([" ", "-"])
                    .join(xs)
                ),

                // above a pair of duplicates,
                // placed one character apart.
                map(s => `${s}+${s}`)
            ])([sierpTriangle(n - 1)])
            .flat()
        ) : ["▲"];


    // ---------------------- TEST -----------------------
    const main = () =>
        sierpTriangle(4)
        .join("\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // ap (<*>) :: [(a -> b)] -> [a] -> [b]
    const ap = fs =>
        // The sequential application of each of a list
        // of functions to each of a list of values.
        // apList([x => 2 * x, x => 20 + x])([1, 2, 3])
        //     -> [2, 4, 6, 21, 22, 23]
        xs => fs.flatMap(f => xs.map(f));


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs => xs.map(f);


    // replicate :: Int -> a -> [a]
    const replicate = n =>
        // A list of n copies of x.
        x => Array.from({
            length: n
        }, () => x);

    // ---------------------- TEST -----------------------
    return main();
})();
