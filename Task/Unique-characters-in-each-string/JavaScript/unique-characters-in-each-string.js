(() => {
    "use strict";

    // --- CHARACTERS SEEN EXACTLY ONCE IN EACH STRING ---

    // onceInEach :: [String] -> String
    const onceInEach = ws =>
        // Characters which occur exactly once
        // in each word in a given list.
        0 < ws.length ? (() => {
            const
                charFreqs = charCounts(ws.join("")),
                charSet = s => new Set([...s]),
                wordCount = ws.length;

            return [
                ...ws.slice(1).reduceRight(
                    (a, x) => intersect(x)(
                        charSet(a)
                    ),
                    charSet(ws[0])
                )
            ]
            .filter(c => wordCount === charFreqs[c])
            .slice()
            .sort()
            .join("");
        })() : "";


    // ---------------------- TEST -----------------------
    const main = () =>
        onceInEach([
            "1a3c52debeffd",
            "2b6178c97a938stf",
            "3ycxdb1fgxa2yz"
        ]);


    // --------------------- GENERIC ---------------------

    // charCounts :: String -> Dict Char Int
    const charCounts = cs =>
        // Dictionary of chars, with the
        // frequency of each in cs.
        [...cs].reduce(
            (a, c) => Object.assign(
                a, {
                    [c]: 1 + (a[c] || 0)
                }
            ), {}
        );


    // intersect :: Set -> Set -> Set
    const intersect = a =>
        // The intersection of two sets.
        b => new Set([...a].filter(i => b.has(i)));


    // MAIN ---
    return main();
})();
