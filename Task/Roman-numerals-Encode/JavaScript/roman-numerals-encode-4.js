(() => {
    "use strict";

    // -------------- ROMAN INTEGER STRINGS --------------

    // roman :: Int -> String
    const roman = n =>
        mapAccumL(residue =>
            ([k, v]) => second(
                q => 0 < q
                    ? k.repeat(q)
                    : ""
            )(remQuot(residue)(v))
        )(n)(
            zip([
                "M", "CM", "D", "CD", "C", "XC",
                "L", "XL", "X", "IX", "V", "IV", "I"
            ])([
                1000, 900, 500, 400, 100, 90,
                50, 40, 10, 9, 5, 4, 1
            ])
        )[1]
        .join("");


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => (
        [2016, 1990, 2008, 2000, 2020, 1666].map(roman)
    )
    .join("\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        // A pair of values, possibly of
        // different types.
        b => ({
            type: "Tuple",
            "0": a,
            "1": b,
            length: 2,
            *[Symbol.iterator]() {
                for (const k in this) {
                    if (!isNaN(k)) {
                        yield this[k];
                    }
                }
            }
        });


    // mapAccumL :: (acc -> x -> (acc, y)) -> acc ->
    // [x] -> (acc, [y])
    const mapAccumL = f =>
        // A tuple of an accumulation and a list
        // obtained by a combined map and fold,
        // with accumulation from left to right.
        acc => xs => [...xs].reduce(
            ([a, bs], x) => second(
                v => [...bs, v]
            )(
                f(a)(x)
            ),
            [acc, []]
        );


    // remQuot :: Int -> Int -> (Int, Int)
    const remQuot = m =>
        n => [m % n, Math.trunc(m / n)];


    // second :: (a -> b) -> ((c, a) -> (c, b))
    const second = f =>
        // A function over a simple value lifted
        // to a function over a tuple.
        // f (a, b) -> (a, f(b))
        xy => Tuple(
            xy[0]
        )(
            f(xy[1])
        );


    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs =>
        // The paired members of xs and ys, up to
        // the length of the shorter of the two lists.
        ys => Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => [xs[i], ys[i]]);


    // MAIN --
    return main();
})();
