(() => {
    "use strict";

    // ----- MINIMUM LENGTH OF UNIQUE ABBREVIATIONS ------

    // minAbbrevnLength :: [String] -> Int
    const minAbbrevnLength = xs => {
        const n = xs.length;

        return 0 < n ? (() => {
            const
                abbrs = dropWhile(ks => n > ks.length)(
                    transpose(xs.map(inits))
                    .map(prefixes => Array.from(
                        new Set(
                            prefixes.map(ws => ws.join(""))
                        )
                    ))
                );

            return (abbrs.length && abbrs[0][0].length) || (
                maximum(xs.map(x => x.length))
            );
        })() : 0;
    };

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        readFile(
            "~/Desktop/weekDayNames.txt"
        )
        .split("\n")
        // Display of just the first few lines.
        .slice(0, 10)
        .map(s => {
            const
                ws = words(s),
                n = minAbbrevnLength(ws);

            return `${n}: ${ws.map(w => w.slice(0, n))}`;
        })
        .join("\n");


    // ----------- MACOS JS FOR AUTOMATION IO ------------

    // readFile :: FilePath -> IO String
    const readFile = fp => {
        // The contents of a text file at the
        // filepath fp.
        const
            e = $(),
            ns = $.NSString
            .stringWithContentsOfFileEncodingError(
                $(fp).stringByStandardizingPath,
                $.NSUTF8StringEncoding,
                e
            );

        return ObjC.unwrap(
            ns.isNil() ? (
                e.localizedDescription
            ) : ns
        );
    };

    // --------------------- GENERIC ---------------------

    // dropWhile :: (a -> Bool) -> [a] -> [a]
    // dropWhile :: (Char -> Bool) -> String -> String
    const dropWhile = p =>
        // The suffix remainining after takeWhile p xs.
        xs => {
            const n = xs.length;

            return xs.slice(
                0 < n ? until(
                    i => n === i || !p(xs[i])
                )(i => 1 + i)(0) : 0
            );
        };


    // inits :: [a] -> [[a]]
    // inits :: String -> [String]
    const inits = xs =>
        // All prefixes of the argument,
        // shortest first.
        [...xs].map(
            (_, i, ys) => ys.slice(0, 1 + i)
        );


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


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p =>
        // The value resulting from repeated applications
        // of f to the seed value x, terminating when
        // that result returns true for the predicate p.
        f => x => {
            let v = x;

            while (!p(v)) {
                v = f(v);
            }

            return v;
        };


    // words :: String -> [String]
    const words = s =>
        // List of space-delimited sub-strings.
        s.split(/\s+/u);

    // MAIN ---
    return main();
})();
