(() => {
    "use strict";

    // ------------ ORDER DISJOINT LIST ITEMS ------------

    // disjointOrder :: [String] -> [String] -> [String]
    const disjointOrder = ms =>
        ns => zipWith(
            a => b => [...a, b]
        )(
            segments(ms)(ns)
        )(
            ns.concat("")
        )
        .flat();


    // segments :: [String] -> [String] -> [String]
    const segments = ms =>
        ns => {
            const dct = ms.reduce((a, x) => {
                const
                    wds = a.words,
                    found = wds.indexOf(x) !== -1;

                return {
                    parts: [
                        ...a.parts,
                        ...(found ? [a.current] : [])
                    ],
                    current: found ? [] : [...a.current, x],
                    words: found ? deleteFirst(x)(wds) : wds
                };
            }, {
                words: ns,
                parts: [],
                current: []
            });

            return [...dct.parts, dct.current];
        };


    // ---------------------- TEST -----------------------
    const main = () =>
        transpose(transpose([{
                M: "the cat sat on the mat",
                N: "mat cat"
            }, {
                M: "the cat sat on the mat",
                N: "cat mat"
            }, {
                M: "A B C A B C A B C",
                N: "C A C A"
            }, {
                M: "A B C A B D A B E",
                N: "E A D A"
            }, {
                M: "A B",
                N: "B"
            }, {
                M: "A B",
                N: "B A"
            }, {
                M: "A B B A",
                N: "B A"
            }].map(dct => [
                dct.M, dct.N,
                unwords(
                    disjointOrder(
                        words(dct.M)
                    )(
                        words(dct.N)
                    )
                )
            ]))
            .map(col => {
                const
                    w = maximumBy(
                        comparing(x => x.length)
                    )(col).length;

                return col.map(justifyLeft(w)(" "));
            }))
        .map(
            ([a, b, c]) => `${a}  ->  ${b}  ->  ${c}`
        )
        .join("\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        // The ordering of f(x) and f(y) as a value
        // drawn from {-1, 0, 1}, representing {LT, EQ, GT}.
        x => y => {
            const
                a = f(x),
                b = f(y);

            return a < b ? -1 : (a > b ? 1 : 0);
        };


    // deleteFirst :: a -> [a] -> [a]
    const deleteFirst = x => {
        const go = xs => Boolean(xs.length) ? (
            x === xs[0] ? (
                xs.slice(1)
            ) : [xs[0]].concat(go(xs.slice(1)))
        ) : [];

        return go;
    };


    // unwords :: [String] -> String
    const unwords = xs =>
        // A space-separated string derived
        // from a list of words.
        xs.join(" ");


    // words :: String -> [String]
    const words = s =>
        // List of space-delimited sub-strings.
        s.split(/\s+/u);


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

    // ---------------- FORMATTING OUTPUT ----------------

    // justifyLeft :: Int -> Char -> String -> String
    const justifyLeft = n =>
        // The string s, followed by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padEnd(n, c)
        ) : s;


    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = f =>
        xs => Boolean(xs.length) ? (
            xs.slice(1).reduce(
                (a, x) => 0 < f(x)(a) ? (
                    x
                ) : a,
                xs[0]
            )
        ) : undefined;


    // transpose :: [[a]] -> [[a]]
    const transpose = rows =>
        // The columns of a matrix of consistent row length,
        // transposed into corresponding rows.
        Boolean(rows.length) ? rows[0].map(
            (_, i) => rows.flatMap(
                v => v[i]
            )
        ) : [];


    // MAIN ---
    return main();
})();
