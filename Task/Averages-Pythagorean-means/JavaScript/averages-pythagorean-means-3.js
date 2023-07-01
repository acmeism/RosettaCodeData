(() => {

    // arithmeticMean :: [Number] -> Number
    const arithmeticMean = xs =>
        foldl((sum, n) => sum + n, 0, xs) / length(xs);

    // geometricMean :: [Number] -> Number
    const geometricMean = xs =>
        raise(foldl((product, x) => product * x, 1, xs), 1 / length(xs));

    // harmonicMean :: [Number] -> Number
    const harmonicMean = xs =>
        length(xs) / foldl((invSum, n) => invSum + (1 / n), 0, xs);

    // GENERIC FUNCTIONS ------------------------------------------------------

    // A list of functions applied to a list of arguments
    // <*> :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        [].concat.apply([], fs.map(f => //
            [].concat.apply([], xs.map(x => [f(x)]))));

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // length :: [a] -> Int
    const length = xs => xs.length;

    // mapFromList :: [(k, v)] -> Dictionary
    const mapFromList = kvs =>
        foldl((a, [k, v]) =>
            (a[(typeof k === 'string' && k) || show(k)] = v, a), {}, kvs);

    // raise :: Num -> Int -> Num
    const raise = (n, e) => Math.pow(n, e);

    // show :: a -> String
    // show :: a -> Int -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[0], null, x[1]] : x
        );

    // zip :: [a] -> [b] -> [(a,b)]
    const zip = (xs, ys) =>
        xs.slice(0, Math.min(xs.length, ys.length))
        .map((x, i) => [x, ys[i]]);

    // TEST -------------------------------------------------------------------
    // mean :: Dictionary
    const mean = mapFromList(zip(
        ['Arithmetic', 'Geometric', 'Harmonic'],
        ap([arithmeticMean, geometricMean, harmonicMean], [
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        ])
    ));

    return show({
        values: mean,
        test: `is A >= G >= H ? ${mean.Arithmetic >= mean.Geometric &&
            mean.Geometric >= mean.Harmonic ? "yes" : "no"}`
    }, 2);
})();
