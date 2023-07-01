(() => {
    "use strict";

    // ------- SHOELACE FORMULA FOR POLYGONAL AREA -------

    // shoelaceArea :: [(Float, Float)] -> Float
    const shoeLaceArea = vertices => abs(
        uncurry(subtract)(
            ap(zip)(compose(tail, cycle))(
                vertices
            )
            .reduce(
                (a, x) => [0, 1].map(b => {
                    const n = Number(b);

                    return a[n] + (
                        x[0][n] * x[1][Number(!b)]
                    );
                }),
                [0, 0]
            )
        )
    ) / 2;


    // ----------------------- TEST -----------------------
    const main = () => {
        const ps = [
            [3, 4],
            [5, 11],
            [12, 8],
            [9, 5],
            [5, 6]
        ];

        return [
                "Polygonal area by shoelace formula:",
                `${JSON.stringify(ps)} -> ${shoeLaceArea(ps)}`
            ]
            .join("\n");
    };


    // ---------------- GENERIC FUNCTIONS -----------------

    // abs :: Num -> Num
    const abs = x =>
        // Absolute value of a given number
        // without the sign.
        0 > x ? -x : x;


    // ap :: (a -> b -> c) -> (a -> b) -> (a -> c)
    const ap = f =>
        // Applicative instance for functions.
        // f(x) applied to g(x).
        g => x => f(x)(
            g(x)
        );


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // cycle :: [a] -> Generator [a]
    const cycle = function* (xs) {
        // An infinite repetition of xs,
        // from which an arbitrary prefix
        // may be taken.
        const lng = xs.length;
        let i = 0;

        while (true) {
            yield xs[i];
            i = (1 + i) % lng;
        }
    };


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        "GeneratorFunction" !== xs.constructor
        .constructor.name ? (
            xs.length
        ) : Infinity;


    // subtract :: Num -> Num -> Num
    const subtract = x =>
        y => y - x;


    // tail :: [a] -> [a]
    const tail = xs =>
        // A new list consisting of all
        // items of xs except the first.
        "GeneratorFunction" !== xs.constructor
        .constructor.name ? (
            Boolean(xs.length) ? (
                xs.slice(1)
            ) : undefined
        ) : (take(1)(xs), xs);


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


    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        // A function over a pair, derived
        // from a curried function.
        (...args) => {
            const [x, y] = Boolean(args.length % 2) ? (
                args[0]
            ) : args;

            return f(x)(y);
        };


    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs => ys => {
        const
            n = Math.min(length(xs), length(ys)),
            vs = take(n)(ys);

        return take(n)(xs)
            .map((x, i) => [x, vs[i]]);
    };


    // MAIN ---
    return main();
})();
