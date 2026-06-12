(() => {
    "use strict";

    //  COUNTS OF OCCURRENCE FOR EACH VOWEL AND CONSONANT

    // countsOfEachVowelAndConsonant ::
    // String -> ([(Char, Int)], [(Char, Int)])
    const countsOfEachVowelAndConsonant = s =>
        partition(
            cn => isVowel(cn[0])
        )(
            sort(
                Object.entries(
                    charCounts(
                        Array.from(s).filter(isAlpha)
                    )
                )
            )
            .map(([c, n]) => Tuple(c)(n))
        );

    // ---------------------- TEST -----------------------
    const main = () => {
        const report = label =>
            cns => {
                const
                    total = cns.reduce(
                        (a, cn) => a + cn[1],
                        0
                    ),
                    rows = cns.map(
                        compose(s => `\t${s}`, showTuple)
                    ).join("\n");

                return [
                    `${label} counts:\n${rows}`,
                    `\ttotal: ${total}`
                ].join("\n\n");
            };

        const counts = countsOfEachVowelAndConsonant(
            "Forever Fortran 2018 programming language"
        );

        return Array.from(
            bimap(
                report("Vowel")
            )(
                report("Consonant")
            )(
                counts
            )
        ).join("\n\n");
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


    // bimap :: (a -> b) -> (c -> d) -> (a, c) -> (b, d)
    const bimap = f =>
        // Tuple instance of bimap.
        // A tuple of the application of f and g to the
        // first and second values respectively.
        g => tpl => Tuple(f(tpl[0]))(
            g(tpl[1])
        );


    // charCounts :: String -> Dict
    const charCounts = s => {
        // A dictionary of characters seen,
        // with their frequencies.
        const go = (dct, c) =>
            Object.assign(dct, {
                [c]: 1 + (dct[c] || 0)
            });

        return Array.from(s).reduce(go, {});
    };


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
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


    // showTuple :: Tuple -> String
    const showTuple = tpl =>
        `(${tpl[0]}, ${tpl[1]})`;


    // MAIN ---
    return main();
})();
