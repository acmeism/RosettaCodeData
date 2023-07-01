(() => {
    "use strict";

    // ---------------- PASCAL'S TRIANGLE ----------------

    // pascal :: Generator [[Int]]
    const pascal = () =>
        iterate(
            xs => zipWith(
                a => b => a + b
            )(
                [0, ...xs]
            )(
                [...xs, 0]
            )
        )([1]);


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        showPascal(
            take(10)(
                pascal()
            )
        );


    // showPascal :: [[Int]] -> String
    const showPascal = xs => {
        const w = last(xs).join("   ").length;

        return xs.map(
            ys => center(w)(" ")(ys.join("   "))
        )
        .join("\n");
    };


    // ---------------- GENERIC FUNCTIONS ----------------

    // center :: Int -> Char -> String -> String
    const center = n =>
        // Size of space -> filler Char ->
        // String -> Centered String
        c => s => {
            const gap = n - s.length;

            return 0 < gap ? (() => {
                const
                    margin = c.repeat(Math.floor(gap / 2)),
                    dust = c.repeat(gap % 2);

                return `${margin}${s}${margin}${dust}`;
            })() : s;
        };


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


    // last :: [a] -> a
    const last = xs =>
        0 < xs.length ? xs.slice(-1)[0] : undefined;


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => "GeneratorFunction" !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : Array.from({
            length: n
        }, () => {
            const x = xs.next();

            return x.done ? [] : [x.value];
        }).flat();


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
