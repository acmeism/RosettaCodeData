(() => {
    "use strict";

    // ----------------- PADOVAN NUMBERS -----------------

    // padovans :: [Int]
    const padovans = () => {
        // Non-finite series of Padovan numbers,
        // defined in terms of recurrence relations.
        const f = ([a, b, c]) => [
            a,
            [b, c, a + b]
        ];

        return unfoldr(f)([1, 1, 1]);
    };


    // padovanFloor :: [Int]
    const padovanFloor = () => {
        // The Padovan series, defined in terms
        // of a floor function.
        const
            // NB JavaScript loses some of this
            // precision at run-time.
            p = 1.324717957244746025960908854,
            s = 1.0453567932525329623;

        const f = n => [
            Math.floor(((p ** (n - 1)) / s) + 0.5),
            1 + n
        ];

        return unfoldr(f)(0);
    };


    // padovanLSystem : [Int]
    const padovanLSystem = () => {
        // An L-system generating terms whose lengths
        // are the values of the Padovan integer series.
        const rule = c =>
            "A" === c ? (
                "B"
            ) : "B" === c ? (
                "C"
            ) : "AB";

        const f = s => [
            s,
            chars(s).flatMap(rule)
            .join("")
        ];

        return unfoldr(f)("A");
    };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        // prefixesMatch :: [a] -> [a] -> Bool
        const prefixesMatch = xs =>
            ys => n => and(
                zipWith(a => b => a === b)(
                    take(n)(xs)
                )(
                    take(n)(ys)
                )
            );

        return [
                "First 20 padovans:",
                take(20)(padovans()),

                "\nThe recurrence and floor-based functions",
                "match over the first 64 terms:\n",
                prefixesMatch(
                    padovans()
                )(
                    padovanFloor()
                )(64),

                "\nFirst 10 L-System strings:",
                take(10)(padovanLSystem()),

                "\nThe lengths of the first 32 L-System",
                "strings match the Padovan sequence:\n",
                prefixesMatch(
                    padovans()
                )(
                    fmap(length)(padovanLSystem())
                )(32)
            ]
            .map(str)
            .join("\n");
    };

    // --------------------- GENERIC ---------------------

    // and :: [Bool] -> Bool
    const and = xs =>
        // True unless any value in xs is false.
        [...xs].every(Boolean);


    // chars :: String -> [Char]
    const chars = s =>
        s.split("");


    // fmap <$> :: (a -> b) -> Gen [a] -> Gen [b]
    const fmap = f =>
        function* (gen) {
            let v = take(1)(gen);

            while (0 < v.length) {
                yield f(v[0]);
                v = take(1)(gen);
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


    // str :: a -> String
    const str = x =>
        "string" !== typeof x ? (
            JSON.stringify(x)
        ) : x;


    // unfoldr :: (b -> Maybe (a, b)) -> b -> Gen [a]
    const unfoldr = f =>
        // A lazy (generator) list unfolded from a seed value
        // by repeated application of f to a value until no
        // residue remains. Dual to fold/reduce.
        // f returns either Null or just (value, residue).
        // For a strict output list,
        // wrap with `list` or Array.from
        x => (
            function* () {
                let valueResidue = f(x);

                while (null !== valueResidue) {
                    yield valueResidue[0];
                    valueResidue = f(valueResidue[1]);
                }
            }()
        );


    // zipWithList :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => ((xs_, ys_) => {
            const lng = Math.min(length(xs_), length(ys_));

            return take(lng)(xs_).map(
                (x, i) => f(x)(ys_[i])
            );
        })([...xs], [...ys]);

    // MAIN ---
    return main();
})();
