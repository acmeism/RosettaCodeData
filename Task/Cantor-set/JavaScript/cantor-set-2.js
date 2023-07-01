(() => {
    "use strict";

    // ----------------- CANTOR STRINGS ------------------

    // cantor :: [String] -> [String]
    const cantor = xs => {
        const go = s => {
            const
                m = Math.floor(s.length / 3),
                blocks = take(m)(s);

            return "█" === s[0] ? (
                [blocks, " ".repeat(m), blocks]
            ) : [s];
        };

        return xs.flatMap(go);
    };

    // ---------------------- TEST -----------------------
    const main = () =>
        showCantor(5);


    // --------------------- DISPLAY ---------------------
    // showCantor :: Int -> String
    const showCantor = n =>
        take(n)(
            iterate(cantor)([
                "█".repeat(3 ** (n - 1))
            ])
        )
        .map(x => x.join(""))
        .join("\n");


    // ---------------- GENERIC FUNCTIONS ----------------

    // iterate :: (a -> a) -> a -> Gen [a]
    const iterate = f =>
        // An infinite list of repeated
        // applications of f to x.
        function* (x) {
            let v = x;

            while (true) {
                yield v;
                v = f(v);
            }
        };


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => "GeneratorFunction" !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat(...Array.from({
            length: n
        }, () => {
            const x = xs.next();

            return x.done ? [] : [x.value];
        }));

    // MAIN ---
    return main();
})();
