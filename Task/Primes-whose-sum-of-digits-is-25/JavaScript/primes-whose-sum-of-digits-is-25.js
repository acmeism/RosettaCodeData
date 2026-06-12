(() => {
    "use strict";

    // ---- PRIMES WITH DECIMAL DIGITS SUMMING TO 25 -----

    // digitSum :: Int -> Int
    const digitSum = n =>
        `${n}`.split("").reduce(
            (a, c) => a + (c.codePointAt(0) - 48),
            0
        );


    // primes :: [Int]
    const primes = function* () {
        // Non finite sequence of prime numbers.
        const dct = {};
        let n = 2;

        while (true) {
            if (n in dct) {
                dct[n].forEach(p => {
                    const np = n + p;

                    dct[np] = (dct[np] || []).concat(p);
                    delete dct[n];
                });
            } else {
                yield n;
                dct[n * n] = [n];
            }
            n = 1 + n;
        }
    };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        unlines(
            chunksOf(5)(
                takeWhileGen(n => 5000 > n)(
                    filterGen(n => 25 === digitSum(n))(
                        primes()
                    )
                ).map(str)
            ).map(unwords)
        );


    // --------------------- GENERIC ---------------------

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


    // filterGen :: (a -> Bool) -> Gen [a] -> Gen [a]
    const filterGen = p => xs => {
        // Non-finite stream of values which are
        // drawn from gen, and satisfy p
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


    // str :: a -> String
    const str = x =>
        x.toString();


    // takeWhileGen :: (a -> Bool) -> Gen [a] -> [a]
    const takeWhileGen = p =>
        // Values drawn from xs until p matches.
        xs => {
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


    // unwords :: [String] -> String
    const unwords = xs =>
        // A space-separated string derived
        // from a list of words.
        xs.join(" ");

    return main();
})();
