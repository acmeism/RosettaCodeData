(() => {
    "use strict";

    // ------------------- ABC BLOCKS --------------------

    // spellWith :: [(Char, Char)] -> [Char] -> [[(Char, Char)]]
    const spellWith = blocks =>
        wordChars => !Boolean(wordChars.length) ? [
            []
        ] : (() => {
            const [x, ...xs] = wordChars;

            return blocks.flatMap(
                b => b.includes(x) ? (
                    spellWith(
                        deleteBy(
                            p => q => (p[0] === q[0]) && (
                                p[1] === q[1]
                            )
                        )(b)(blocks)
                    )(xs)
                    .flatMap(bs => [b, ...bs])
                ) : []
            );
        })();


    // ---------------------- TEST -----------------------
    const main = () => {
        const blocks = (
            "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM"
        ).split(" ");

        return [
                "", "A", "BARK", "BoOK", "TrEAT",
                "COmMoN", "SQUAD", "conFUsE"
            ]
            .map(
                x => JSON.stringify([
                    x, !Boolean(
                        spellWith(blocks)(
                            [...x.toLocaleUpperCase()]
                        )
                        .length
                    )
                ])
            )
            .join("\n");
    };

    // ---------------- GENERIC FUNCTIONS ----------------

    // deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
    const deleteBy = fEq =>
        x => {
            const go = xs => Boolean(xs.length) ? (
                fEq(x)(xs[0]) ? (
                    xs.slice(1)
                ) : [xs[0], ...go(xs.slice(1))]
            ) : [];

            return go;
        };

    // MAIN ---
    return main();
})();
