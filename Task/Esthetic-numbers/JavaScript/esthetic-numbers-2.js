(() => {
    "use strict";

    // -------- ESTHETIC NUMBERS IN A GIVEN BASE ---------

    // estheticNumbersInBase :: Int -> [Int]
    const estheticNumbersInBase = b =>
        // An infinite sequence of numbers which
        // are esthetic in the given base.

        tail(fmapGen(x => x[0])(
            iterate(([, queue]) => {
                const [num, lsd] = queue[0];
                const
                    newDigits = [lsd - 1, lsd + 1]
                    .flatMap(
                        d => (d < b && d >= 0) ? (
                            [d]
                        ) : []
                    );

                return Tuple(num)(
                    queue.slice(1).concat(
                        newDigits.flatMap(d => [
                            Tuple((num * b) + d)(d)
                        ])
                    )
                );
            })(
                Tuple()(
                    enumFromTo(1)(b - 1).flatMap(
                        d => [Tuple(d)(d)]
                    )
                )
            )
        ));

    // ---------------------- TESTS ----------------------
    const main = () => {

        const samples = b => {
            const
                i = b * 4,
                j = b * 6;

            return unlines([
                `Esthetics [${i}..${j}] for base ${b}:`,
                ...chunksOf(10)(
                    compose(drop(i - 1), take(j))(
                        estheticNumbersInBase(b)
                    ).map(n => n.toString(b))
                )
                .map(unwords)
            ]);
        };

        const takeInRange = ([a, b]) =>
            compose(
                dropWhile(x => x < a),
                takeWhileGen(x => x <= b)
            );

        return [
            enumFromTo(2)(16)
            .map(samples)
            .join("\n\n"),
            [
                Tuple(1000)(9999),
                Tuple(100000000)(130000000)
            ]
            .map(
                ([lo, hi]) => unlines([
                    `Base 10 Esthetics in range [${lo}..${hi}]:`,
                    unlines(
                        chunksOf(6)(
                            takeInRange([lo, hi])(
                                estheticNumbersInBase(10)
                            )
                        )
                        .map(unwords)
                    )
                ])
            ).join("\n\n")
        ].join("\n\n");
    };

    // --------------------- GENERIC ---------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
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


    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n => {
        // xs split into sublists of length n.
        // The last sublist will be short if n
        // does not evenly divide the length of xs .
        const go = xs => {
            const chunk = xs.slice(0, n);

            return 0 < chunk.length ? (
                [chunk].concat(
                    go(xs.slice(n))
                )
            ) : [];
        };

        return go;
    };


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // drop :: Int -> [a] -> [a]
    // drop :: Int -> Generator [a] -> Generator [a]
    // drop :: Int -> String -> String
    const drop = n =>
        xs => Infinity > length(xs) ? (
            xs.slice(n)
        ) : (take(n)(xs), xs);


    // dropWhile :: (a -> Bool) -> [a] -> [a]
    // dropWhile :: (Char -> Bool) -> String -> String
    const dropWhile = p =>
        // The suffix remaining after takeWhile p xs.
        xs => {
            const n = xs.length;

            return xs.slice(
                0 < n ? until(
                    i => n === i || !p(xs[i])
                )(i => 1 + i)(0) : 0
            );
        };


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
    const fmapGen = f =>
        // The map of f over a stream of generator values.
        function* (gen) {
            let v = gen.next();

            while (!v.done) {
                yield f(v.value);
                v = gen.next();
            }
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


    // tail :: [a] -> [a]
    const tail = xs =>
        // A new list consisting of all
        // items of xs except the first.
        "GeneratorFunction" !== xs.constructor
        .constructor.name ? (
            (ys => 0 < ys.length ? ys.slice(1) : [])(
                xs
            )
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


    // takeWhileGen :: (a -> Bool) -> Gen [a] -> [a]
    const takeWhileGen = p => xs => {
        const ys = [];
        let
            nxt = xs.next(),
            v = nxt.value;

        while (!nxt.done && p(v)) {
            ys.push(v);
            nxt = xs.next();
            v = nxt.value;
        }

        return ys;
    };


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join("\n");


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p =>
        // The value resulting from repeated applications
        // of f to the seed value x, terminating when
        // that result returns true for the predicate p.
        f => x => {
            let v = x;

            while (!p(v)) {
                v = f(v);
            }

            return v;
        };


    // unwords :: [String] -> String
    const unwords = xs =>
        // A space-separated string derived
        // from a list of words.
        xs.join(" ");

    // MAIN ---
    return main();
})();
