(() => {
    "use strict";

    // ---------- PADOVAN N-STEP NUMBER SERIES -----------

    // padovans :: Int -> [Int]
    const padovans = n => {
        // Padovan number series of step N
        const recurrence = ns => [
            ns[0],
            ns.slice(1).concat(
                sum(take(n)(ns))
            )
        ];


        return 0 > n ? (
            []
        ) : unfoldr(recurrence)(
            take(1 + n)(
                3 > n ? (
                    repeat(1)
                ) : padovans(n - 1)
            )
        );
    };

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        fTable("Padovan N-step series:")(str)(
            xs => xs.map(
                compose(justifyRight(4)(" "), str)
            )
            .join("")
        )(
            compose(take(15), padovans)
        )(
            enumFromTo(2)(8)
        );


    // --------------------- GENERIC ---------------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // repeat :: a -> Generator [a]
    const repeat = function* (x) {
        while (true) {
            yield x;
        }
    };


    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


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


    // unfoldr :: (b -> Maybe (a, b)) -> b -> Gen [a]
    const unfoldr = f =>
        // A lazy (generator) list unfolded from a seed value
        // by repeated application of f to a value until no
        // residue remains. Dual to fold/reduce.
        // f returns either Nothing or Just (value, residue).
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

    // ------------------- FORMATTING --------------------

    // fTable :: String -> (a -> String) ->
    // (b -> String) -> (a -> b) -> [a] -> String
    const fTable = s =>
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        xShow => fxShow => f => xs => {
            const
                ys = xs.map(xShow),
                w = Math.max(...ys.map(y => [...y].length)),
                table = zipWith(
                    a => b => `${a.padStart(w, " ")} ->${b}`
                )(ys)(
                    xs.map(x => fxShow(f(x)))
                ).join("\n");

            return `${s}\n${table}`;
        };


    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padStart(n, c)
        ) : s;


    // str :: a -> String
    const str = x => `${x}`;


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => take(
            Math.min(xs.length, ys.length)
        )(
            xs.map((x, i) => f(x)(ys[i]))
        );

    // MAIN ---
    return main();
})();
