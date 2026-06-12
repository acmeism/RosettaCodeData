(() => {
    "use strict";

    // --- ANY ALPHA DIGITS REQUIRED IN HEXADECIMAL ? ----

    // p :: Int -> Bool
    const p = n =>
        // True if a hexadecimal representation of the
        // integer n requires any digits above 9.
        9 < n && (
            9 < n % 16 || p(
                Math.trunc(n / 16)
            )
        );


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const
            upperLimit = 500,
            xs = enumFromTo(0)(upperLimit)
            .flatMap(
                x => p(x) ? [
                    `${x}`
                ] : []
            );

        return [
            `${xs.length} matches up to ${upperLimit}:\n`,
            table("  ")(justifyRight)(
                chunksOf(6)(xs)
            )
        ].join("\n");
    };


    // --------------------- DISPLAY ---------------------

    // table :: String ->
    // (Int -> Char -> String -> String) ->
    // [[String]] -> String
    const table = gap =>
        // A tabulation of rows of string values,
        // with a specified gap between columns,
        // and choice of cell alignment function
        // (justifyLeft | center | justifyRight)
        alignment => rows => {
            const
                colWidths = transpose(rows).map(
                    row => maximum(row.map(x => x.length))
                );

            return rows.map(
                compose(
                    intercalate(gap),
                    zipWith(
                        flip(alignment)(" ")
                    )(colWidths)
                )
            ).join("\n");
        };


    // --------------------- GENERIC ---------------------

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n => {
        // xs split into sublists of length n.
        // The last sublist will be short if n
        // does not evenly divide the length of xs .
        const go = xs => {
            const chunk = xs.slice(0, n);

            return 0 < chunk.length ? (
                [chunk].concat(
                    go(xs.slice(n))
                )
            ) : [];
        };

        return go;
    };


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = op =>
        // The binary function op with
        // its arguments reversed.
        1 < op.length ? (
            (a, b) => op(b, a)
        ) : (x => y => op(y)(x));


    // intercalateS :: String -> [String] -> String
    const intercalate = s =>
        // The concatenation of xs
        // interspersed with copies of s.
        xs => xs.join(s);


    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => Boolean(s) ? (
            s.padStart(n, c)
        ) : "";


    // maximum :: Ord a => [a] -> a
    const maximum = xs => (
        // The largest value in a non-empty list.
        ys => 0 < ys.length ? (
            ys.slice(1).reduce(
                (a, y) => y > a ? (
                    y
                ) : a, ys[0]
            )
        ) : undefined
    )(xs);


    // transpose :: [[a]] -> [[a]]
    const transpose = rows => {
        // If any rows are shorter than those that follow,
        // their elements are skipped:
        // > transpose [[10,11],[20],[],[30,31,32]]
        //             == [[10,20,30],[11,31],[32]]
        const go = xss =>
            0 < xss.length ? (() => {
                const
                    h = xss[0],
                    t = xss.slice(1);

                return 0 < h.length ? [
                    [h[0]].concat(t.reduce(
                        (a, xs) => a.concat(
                            0 < xs.length ? (
                                [xs[0]]
                            ) : []
                        ),
                        []
                    ))
                ].concat(go([h.slice(1)].concat(
                    t.map(xs => xs.slice(1))
                ))) : go(t);
            })() : [];

        return go(rows);
    };


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
