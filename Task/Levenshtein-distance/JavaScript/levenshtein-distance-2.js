(() => {
    "use strict";

    // ------------ LEVENSHTEIN EDIT DISTANCE ------------

    // levenshtein :: String -> String -> Int
    const levenshtein = sa =>
        // The Levenshtein edit distance
        // between two given strings.
        sb => {
            const cs = [...sa];
            const go = (ns, c) => {
                const calc = z => tpl => {
                    const [c1, x, y] = Array.from(tpl);

                    return Math.min(
                        1 + y,
                        1 + z,
                        x + (
                            c1 === c
                                ? 0
                                : 1
                        )
                    );
                };
                const [n, ...ns1] = ns;

                return scanl(calc)(1 + n)(
                    zip3(cs)(ns)(ns1)
                );
            };

            return last(
                [...sb].reduce(
                    go,
                    enumFromTo(0)(cs.length)
                )
            );
        };

    // ---------------------- TEST -----------------------
    const main = () => [
        ["kitten", "sitting"],
        ["sitting", "kitten"],
        ["rosettacode", "raisethysword"],
        ["raisethysword", "rosettacode"]
    ].map(uncurry(levenshtein));


    // ---------------- GENERIC FUNCTIONS ----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // last :: [a] -> a
    const last = xs => {
        // The last item of a list.
        const n = xs.length;

        return 0 < n
            ? xs[n - 1]
            : null;
    };


    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = f =>
        // The series of interim values arising
        // from a catamorphism. Parallel to foldl.
        startValue => xs =>
            xs.reduce(
                (a, x) => {
                    const v = f(a[0])(x);

                    return [v, a[1].concat(v)];
                }, [startValue, [startValue]]
            )[1];


    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        // A function over a pair, derived
        // from a curried function.
        (...args) => {
            const
                [x, y] = Boolean(args.length % 2)
                    ? args[0]
                    : args;

            return f(x)(y);
        };


    // zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
    const zip3 = xs =>
        ys => zs => xs.slice(
            0,
            Math.min(...[xs, ys, zs].map(x => x.length))
        )
        .map((x, i) => [x, ys[i], zs[i]]);


    // MAIN ---
    return JSON.stringify(main());
})();
