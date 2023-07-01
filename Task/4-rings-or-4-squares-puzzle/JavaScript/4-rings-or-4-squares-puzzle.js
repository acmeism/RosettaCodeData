(() => {
    "use strict";

    // ----------- 4-RINGS OR 4-SQUARES PUZZLE -----------

    // rings :: noRepeatedDigits -> DigitList -> solutions
    // rings :: Bool -> [Int] -> [[Int]]
    const rings = uniq =>
        digits => Boolean(digits.length) ? (
            () => {
                const ns = digits.sort(flip(compare));

                // CENTRAL DIGIT :: d
                return ns.flatMap(
                    ringTriage(uniq)(ns)
                );
            })() : [];


    const ringTriage = uniq => ns => d => {
        const
            h = head(ns),
            ts = ns.filter(x => (x + d) <= h);

        // LEFT OF CENTRE :: c and a
        return (
            uniq ? (delete_(d)(ts)) : ns
        )
        .flatMap(c => {
            const a = c + d;

            // RIGHT OF CENTRE :: e and g
            return a > h ? (
                []
            ) : (
                uniq ? (
                    difference(ts)([d, c, a])
                ) : ns
            )
            .flatMap(subTriage(uniq)([ns, h, a, c, d]));
        });
    };


    const subTriage = uniq =>
        ([ns, h, a, c, d]) => e => {
            const g = d + e;

            return ((g > h) || (
                uniq && (g === c))
            ) ? (
                    []
                ) : (() => {
                    const
                        agDelta = a - g,
                        bfs = uniq ? (
                            difference(ns)([
                                d, c, e, g, a
                            ])
                        ) : ns;

                    // MID LEFT, MID RIGHT :: b and f
                    return bfs.flatMap(b => {
                        const f = b + agDelta;

                        return (bfs).includes(f) && (
                            !uniq || ![
                                a, b, c, d, e, g
                            ].includes(f)
                        ) ? ([
                                [a, b, c, d, e, f, g]
                            ]) : [];
                    });
                })();
        };

    // ---------------------- TEST -----------------------
    const main = () => unlines([
        "rings(true, enumFromTo(1,7))\n",
        unlines(
            rings(true)(
                enumFromTo(1)(7)
            ).map(show)
        ),

        "\nrings(true, enumFromTo(3, 9))\n",
        unlines(
            rings(true)(
                enumFromTo(3)(9)
            ).map(show)
        ),

        "\nlength(rings(false, enumFromTo(0, 9)))\n",
        rings(false)(
            enumFromTo(0)(9)
        )
        .length
        .toString(),
        ""
    ]);


    // ---------------- GENERIC FUNCTIONS ----------------

    // compare :: a -> a -> Ordering
    const compare = (a, b) =>
        a < b ? -1 : (a > b ? 1 : 0);


    // delete :: Eq a => a -> [a] -> [a]
    const delete_ = x => {
        // xs with first instance of x (if any) removed.
        const go = xs =>
            Boolean(xs.length) ? (
                (x === xs[0]) ? (
                    xs.slice(1)
                ) : [xs[0]].concat(go(xs.slice(1)))
            ) : [];

        return go;
    };


    // difference :: Eq a => [a] -> [a] -> [a]
    const difference = xs =>
        ys => {
            const s = new Set(ys);

            return xs.filter(x => !s.has(x));
        };


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = op =>
        // The binary function op with
        // its arguments reversed.
        1 !== op.length ? (
            (a, b) => op(b, a)
        ) : (a => b => op(b)(a));


    // head :: [a] -> a
    const head = xs =>
        // The first item (if any) in a list.
        Boolean(xs.length) ? (
            xs[0]
        ) : null;


    // show :: a -> String
    const show = x =>
        JSON.stringify(x);


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join("\n");


    // MAIN ---
    return main();
})();
