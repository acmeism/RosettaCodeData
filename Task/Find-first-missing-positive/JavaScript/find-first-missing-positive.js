(() => {
    "use strict";

    // ---------- FIRST MISSING NATURAL NUMBER -----------

    // firstGap :: [Int] -> Int
    const firstGap = xs => {
        const seen = new Set(xs);

        return filterGen(
            x => !seen.has(x)
        )(
            enumFrom(1)
        )
        .next()
        .value;
    };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => [
            [1, 2, 0],
            [3, 4, -1, 1],
            [7, 8, 9, 11, 12]
        ]
        .map(xs => `${show(xs)} -> ${firstGap(xs)}`)
        .join("\n");


    // --------------------- GENERIC ---------------------

    // enumFrom :: Int -> [Int]
    const enumFrom = function* (x) {
        // A non-finite succession of
        // integers, starting with n.
        let v = x;

        while (true) {
            yield v;
            v = 1 + v;
        }
    };


    // filterGen :: (a -> Bool) -> Gen [a] -> Gen [a]
    const filterGen = p =>
        // A stream of values which are drawn
        // from a generator, and satisfy p.
        xs => {
            const go = function* () {
                let x = xs.next();

                while (!x.done) {
                    const v = x.value;

                    if (p(v)) {
                        yield v;
                    }
                    x = xs.next();
                }
            };

            return go(xs);
        };


    // show :: a -> String
    const show = x => JSON.stringify(x);

    // MAIN ---
    return main();
})();
