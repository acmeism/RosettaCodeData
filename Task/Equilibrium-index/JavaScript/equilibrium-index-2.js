(() => {
    // EQUILIBRIUM INDICES ----------------------------------------------------

    // equilibriumIndices :: [Int] -> [Int]
    const equilibriumIndices = xs =>
        foldr((a, [x, y], i) =>
            x === y ? cons(i, a) : a,
            [],
            zip(
                scanl1(plus, xs), // Sums from the left
                scanr1(plus, xs)  // Sums from the right
            )
        );

    // GENERIC FUNCTIONS ------------------------------------------------------

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // foldr (a -> b -> a) -> a -> [b] -> a
    const foldr = (f, a, xs) => xs.reduceRight(f, a);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // plus :: Num a => a -> a -> a
    const plus = (a, b) => a + b;

    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = (f, startValue, xs) =>
        xs.reduce((a, x) => {
            const v = f(a.acc, x);
            return {
                acc: v,
                scan: a.scan.concat(v)
            };
        }, {
            acc: startValue,
            scan: [startValue]
        })
        .scan;

    // scanl1 :: (a -> a -> a) -> [a] -> [a]
    const scanl1 = (f, xs) =>
        xs.length > 0 ? scanl(f, xs[0], xs.slice(1)) : [];

    // scanr :: (b -> a -> b) -> b -> [a] -> [b]
    const scanr = (f, startValue, xs) =>
        xs.reduceRight((a, x) => {
            const v = f(a.acc, x);
            return {
                acc: v,
                scan: [v].concat(a.scan)
            };
        }, {
            acc: startValue,
            scan: [startValue]
        })
        .scan;

    // scanr1 :: (a -> a -> a) -> [a] -> [a]
    const scanr1 = (f, xs) =>
        xs.length > 0 ? scanr(f, xs.slice(-1)[0], xs.slice(0, -1)) : [];

    // Any value -> optional number of indents -> String
    // show :: a -> String
    // show :: a -> Int -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[0], null, x[1]] : x
        );

    // tail :: [a] -> [a]
    const tail = xs => xs.length ? xs.slice(1) : undefined;

    // zip :: [a] -> [b] -> [(a,b)]
    const zip = (xs, ys) =>
        xs.slice(0, Math.min(xs.length, ys.length))
        .map((x, i) => [x, ys[i]]);

    // TEST -------------------------------------------------------------------
    return show(
        map(equilibriumIndices, [
            [-7, 1, 5, 2, -4, 3, 0],
            [2, 4, 6],
            [2, 9, 2],
            [1, -1, 1, -1, 1, -1, 1],
            [1],
            []
        ])
    );
    // -> [[3, 6], [], [1], [0, 1, 2, 3, 4, 5, 6], [0], []]
})();
