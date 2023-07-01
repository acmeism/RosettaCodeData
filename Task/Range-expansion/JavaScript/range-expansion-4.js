(() => {
    "use strict";

    // ----------------- RANGE EXPANSION -----------------

    // rangeExpansion :: String -> [Int]
    const rangeExpansion = rangeString =>
        // A list of integers parsed from a
        // comma-delimited string which may include
        // (rising) hyphenated ranges.
        rangeString.split(",")
        .flatMap(x => {
            const ns = x.split("-")
                .reduce((a, s, i, xs) =>
                    Boolean(s) ? (
                        0 < i ? a.concat(
                            parseInt(
                                xs[i - 1].length ? (
                                    s
                                ) : `-${s}`,
                                10
                            )
                        ) : [Number(s)]
                    ) : a,
                    []
                );

            return 2 === ns.length ? (
                uncurry(enumFromTo)(ns)
            ) : ns;
        });


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        rangeExpansion("-6,-3--1,3-5,7-11,14,15,17-20");


    // --------------------- GENERIC ---------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        // A function over a pair, derived
        // from a curried function.
        (...args) => {
            const [x, y] = Boolean(args.length % 2) ? (
                args[0]
            ) : args;

            return f(x)(y);
        };


    // MAIN ---
    return JSON.stringify(main());
})();
