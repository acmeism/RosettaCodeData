(() => {
    "use strict";

// ---- COUNTS OF VOWEL AND CONSONANT OCCURRENCES ----

    // vowelConsonantOccurrenceTotals :: String -> (Int, Int)
    const vowelConsonantOccurrenceTotals = s =>
        Array.from(s).reduce(
            (ab, c) => (
                isAlpha(c) ? (
                    isVowel(c) ? (
                        first(succ)
                    ) : second(succ)
                ) : identity
            )(ab),
            Tuple(0)(0)
        );

    // ---------------------- TEST -----------------------
    const main = () => {
        const vc =
            vowelConsonantOccurrenceTotals(
                "Forever Fortran 2018 programming language"
            );

        return [
            `Vowel occurrences: ${vc[0]}`,
            `Consonent occurrences: ${vc[1]}`
        ].join("\n\n");
    };


    // --------------------- GENERIC ---------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: "Tuple",
            "0": a,
            "1": b,
            length: 2
        });

    // first :: (a -> b) -> ((a, c) -> (b, c))
    const first = f =>
        // A simple function lifted to one which applies
        // to a tuple, transforming only its first item.
        xy => {
            const tpl = Tuple(f(xy[0]))(xy[1]);

            return Array.isArray(xy) ? (
                Array.from(tpl)
            ) : tpl;
        };

    // identity :: a -> a
    const identity = x =>
        // The identity function.
        x;

    // isAlpha :: Char -> Bool
    const isAlpha = c =>
        (/[A-Za-z\u00C0-\u00FF]/u).test(c);

    // isVowel :: Char -> Bool
    const isVowel = c =>
        (/[AEIOUaeiou]/u).test(c);

    // second :: (a -> b) -> ((c, a) -> (c, b))
    const second = f =>
        // A function over a simple value lifted
        // to a function over a tuple.
        // f (a, b) -> (a, f(b))
        xy => {
            const tpl = Tuple(xy[0])(f(xy[1]));

            return Array.isArray(xy) ? (
                Array.from(tpl)
            ) : tpl;
        };

    // succ :: Int -> Int
    const succ = x =>
        1 + x;

    return main();
})();
