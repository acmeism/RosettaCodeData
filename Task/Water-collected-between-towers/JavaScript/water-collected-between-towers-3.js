(() => {
    "use strict";

    // --------- WATER COLLECTED BETWEEN TOWERS ----------

    // waterCollected :: [Int] -> Int
    const waterCollected = xs =>
        sum(filter(lt(0))(
            zipWith(subtract)(xs)(
                zipWith(min)(
                    scanl1(max)(xs)
                )(
                    scanr1(max)(xs)
                )
            )
        ));


    // ---------------------- TEST -----------------------
    const main = () => [
        [1, 5, 3, 7, 2],
        [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
        [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
        [5, 5, 5, 5],
        [5, 6, 7, 8],
        [8, 7, 7, 6],
        [6, 7, 10, 7, 6]
    ].map(waterCollected);


    // --------------------- GENERIC ---------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: "Tuple",
            "0": a,
            "1": b,
            length: 2
        });


    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = p =>
        // The elements of xs which match
        // the predicate p.
        xs => [...xs].filter(p);


    // lt (<) :: Ord a => a -> a -> Bool
    const lt = a =>
        b => a < b;


    // max :: Ord a => a -> a -> a
    const max = a =>
        // b if its greater than a,
        // otherwise a.
        b => a > b ? a : b;


    // min :: Ord a => a -> a -> a
    const min = a =>
        b => b < a ? b : a;


    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = f => startValue => xs =>
        xs.reduce((a, x) => {
            const v = f(a[0])(x);

            return Tuple(v)(a[1].concat(v));
        }, Tuple(startValue)([startValue]))[1];


    // scanl1 :: (a -> a -> a) -> [a] -> [a]
    const scanl1 = f =>
        // scanl1 is a variant of scanl that
        // has no starting value argument.
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

                return Tuple(v)([v].concat(a[1]));
            }, Tuple(startValue)([startValue])
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


    // subtract :: Num -> Num -> Num
    const subtract = x =>
        y => y - x;


    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        ).slice(
            0, Math.min(xs.length, ys.length)
        );

    // MAIN ---
    return main();
})();
