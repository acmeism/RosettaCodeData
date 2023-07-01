(() => {

    // knuthShuffle :: [a] -> [a]
    const knuthShuffle = xs =>
        enumFromTo(0, xs.length - 1)
        .reduceRight((a, i) => {
            const iRand = randomRInt(0, i);
            return i !== iRand ? (
                swapped(i, iRand, a)
            ) : a;
        }, xs);

    const test = () => knuthShuffle(
        (`alpha beta gamma delta epsilon zeta
          eta theta iota kappa lambda mu`)
        .split(/\s+/)
    );

    // Non mutating version of swapped

    // swapped :: Int -> Int -> [a] -> [a]
    const swapped = (iFrom, iTo, xs) =>
        xs.map(
            (x, i) => iFrom !== i ? (
                iTo !== i ? (
                    x
                ) : xs[iFrom]
            ) : xs[iTo]
        );

    // GENERIC FUNCTIONS ----------------------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        n >= m ? (
            iterateUntil(x => x >= n, x => 1 + x, m)
        ) : [];

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        let vs = [x],
            h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // randomRInt :: Int -> Int -> Int
    const randomRInt = (low, high) =>
        low + Math.floor(
            (Math.random() * ((high - low) + 1))
        );

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) =>
        Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => f(xs[i], ys[i], i));

    // MAIN ---
    return test();
})();
