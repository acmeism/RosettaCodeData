(() => {
    "use strict";

    // -------------- CANTOR BOOL-INT PAIRS --------------

    // cantor :: [(Bool, Int)] -> [(Bool, Int)]
    const cantor = xs => {
        const go = ([bln, n]) =>
            bln && 1 < n ? (() => {
                const x = Math.floor(n / 3);

                return [
                    [true, x],
                    [false, x],
                    [true, x]
                ];
            })() : [
                [bln, n]
            ];

        return xs.flatMap(go);
    };

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        cantorLines(5);


    // --------------------- DISPLAY ---------------------

    // cantorLines :: Int -> String
    const cantorLines = n =>
        take(n)(
            iterate(cantor)([
                [true, 3 ** (n - 1)]
            ])
        )
        .map(showCantor)
        .join("\n");


    // showCantor :: [(Bool, Int)] -> String
    const showCantor = xs =>
        xs.map(
            ([bln, n]) => (
                bln ? (
                    "*"
                ) : " "
            ).repeat(n)
        )
        .join("");

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
