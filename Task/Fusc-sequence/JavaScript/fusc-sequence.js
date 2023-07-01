(() => {
    "use strict";

    // ---------------------- FUSC -----------------------

    // fusc :: Int -> Int
    const fusc = i => {
        const go = n =>
            0 === n ? [
                1, 0
            ] : (() => {
                const [x, y] = go(Math.floor(n / 2));

                return 0 === n % 2 ? (
                    [x + y, y]
                ) : [x, x + y];
            })();

        return 1 > i ? (
            0
        ) : go(i - 1)[0];
    };


    // ---------------------- TEST -----------------------
    const main = () => {
        const terms = enumFromTo(0)(60).map(fusc);

        return [
                "First 61 terms:",
                `[${terms.join(",")}]`,
                "",
                "(Index, Value):",
                firstWidths(5).reduce(
                    (a, x) => [x.slice(1), ...a],
                    []
                )
                .map(([i, x]) => `(${i}, ${x})`)
                .join("\n")
            ]
            .join("\n");
    };


    // firstWidths :: Int -> [(Int, Int)]
    const firstWidths = n => {
        const nxtWidth = xs => {
            const
                fi = fanArrow(fusc)(x => x),
                [w, i] = xs[0],
                [x, j] = Array.from(
                    until(
                        v => w <= `${v[0]}`.length
                    )(
                        v => fi(1 + v[1])
                    )(fi(i))
                );

            return [
                [1 + w, j, x],
                ...xs
            ];
        };

        return until(x => n < x[0][0])(
            nxtWidth
        )([
            [2, 0, 0]
        ]);
    };


    // ---------------- GENERIC FUNCTIONS ----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // fanArrow (&&&) ::
    // (a -> b) -> (a -> c) -> (a -> (b, c))
    const fanArrow = f =>
        // A combined function, given f and g,
        // from x to a tuple of (f(x), g(x))
        // ((,) . f <*> g)
        g => x => [f(x), g(x)];


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p =>
        // The value resulting from successive applications
        // of f to f(x), starting with a seed value x,
        // and terminating when the result returns true
        // for the predicate p.
        f => {
            const go = x =>
                p(x) ? x : go(f(x));

            return go;
        };

    // MAIN ---
    return main();
})();
