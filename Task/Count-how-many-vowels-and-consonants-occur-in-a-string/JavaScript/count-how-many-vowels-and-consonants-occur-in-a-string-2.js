(() => {
    "use strict";

    //  NUMBERS OF DISTINCT VOWELS, AND DISTINCT CONSONANTS

    // distinctVowelsAndConsonants ::
    // String -> ([Char], [Char])
    const distinctVowelsAndConsonants = s =>
        both(
            cs => sort(Array.from(new Set(cs)))
        )(
            partition(isVowel)(
                Array.from(s).filter(isAlpha)
            )
        );

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const vc = both(
            cs => `(${cs.join("")}, ${cs.length})`
        )(
            distinctVowelsAndConsonants(
                "Forever Fortran 2018 programming language"
            )
        );

        return [
            `Distinct vowels: ${vc[0]}`,
            `Distict consonants: ${vc[1]}`
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


    // both :: (a -> b) -> (a, a) -> (b, b)
    const both = f =>
        ab => Tuple(
            f(ab[0])
        )(
            f(ab[1])
        );


    // isAlpha :: Char -> Bool
    const isAlpha = c =>
        (/[A-Za-z\u00C0-\u00FF]/u).test(c);


    // isVowel :: Char -> Bool
    const isVowel = c =>
        (/[AEIOUaeiou]/u).test(c);


    // partition :: (a -> Bool) -> [a] -> ([a], [a])
    const partition = p =>
        // A tuple of two lists - those elements in
        // xs which match p, and those which do not.
        xs => xs.reduce(
            (a, x) => p(x) ? (
                Tuple(a[0].concat(x))(a[1])
            ) : Tuple(a[0])(a[1].concat(x)),
            Tuple([])([])
        );

    // sort :: Ord a => [a] -> [a]
    const sort = xs =>
        // An A-Z sorted copy of xs.
        xs.slice()
        .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));


    // MAIN ---
    return main();
})();
