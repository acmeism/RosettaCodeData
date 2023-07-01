(() => {
    "use strict";

    // ------------- ALL EQUILIBRIUM INDICES -------------

    // equilibriumIndices :: [Int] -> [Int]
    const equilibriumIndices = xs =>
        zip(
            scanl1(add)(xs)
        )(
            scanr1(add)(xs)
        )
        .reduceRight(
            (a, xy, i) => xy[0] === xy[1] ? (
                [i, ...a]
            ) : a, []
        );


    // ---------------------- TEST -----------------------
    const main = () => [
            [-7, 1, 5, 2, -4, 3, 0],
            [2, 4, 6],
            [2, 9, 2],
            [1, -1, 1, -1, 1, -1, 1],
            [1],
            []
        ].map(compose(
            JSON.stringify,
            equilibriumIndices
        ))
        .join("\n");
    // -> [[3, 6], [], [1], [0, 1, 2, 3, 4, 5, 6], [0], []]


    // ---------------- GENERIC FUNCTIONS ----------------

    // add (+) :: Num a => a -> a -> a
    const add = a =>
        // Curried addition.
        b => a + b;


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = f => startValue => xs =>
        // The series of interim values arising
        // from a catamorphism. Parallel to foldl.
        xs.reduce((a, x) => {
            const v = f(a[0])(x);

            return [v, a[1].concat(v)];
        }, [startValue, [startValue]])[1];


    // scanl1 :: (a -> a -> a) -> [a] -> [a]
    const scanl1 = f =>
        // scanl1 is a variant of scanl that has no
        // starting value argument.
        xs => xs.length > 0 ? (
            scanl(f)(
                xs[0]
            )(xs.slice(1))
        ) : [];


    // scanr :: (a -> b -> b) -> b -> [a] -> [b]
    const scanr = f =>
        startValue => xs => xs.reduceRight(
            (a, x) => {
                const v = f(x)(a[0]);

                return [v, [v].concat(a[1])];
            }, [startValue, [startValue]]
        )[1];


    // scanr1 :: (a -> a -> a) -> [a] -> [a]
    const scanr1 = f =>
        // scanr1 is a variant of scanr that has no
        // seed-value argument, and assumes that
        // xs is not empty.
        xs => xs.length > 0 ? (
            scanr(f)(
                xs.slice(-1)[0]
            )(xs.slice(0, -1))
        ) : [];


    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs =>
        // The paired members of xs and ys, up to
        // the length of the shorter of the two lists.
        ys => Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => [xs[i], ys[i]]);

    // MAIN ---
    return main();
})();
