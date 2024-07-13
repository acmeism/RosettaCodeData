(() => {
    "use strict";

    // ------------- ROMAN NUMERALS DECODED --------------

    // Folding from right to left,
    // lower leftward characters are subtracted,
    // others are added.

    // fromRoman :: String -> Int
    const fromRoman = s =>
        [...s]
        .map(glyphValue)
        .reduceRight(
            ([r, n], l) => [
                l,
                l >= r
                    ? n + l
                    : n - l
            ],
            [0, 0]
        )[1];


    // glyphValue :: Char -> Maybe Int
    const glyphValue = k => ({
        I: 1,
        V: 5,
        X: 10,
        L: 50,
        C: 100,
        D: 500,
        M: 1000
    }) [k] || 0;

    // ---------------------- TEST -----------------------
    return [
        "MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVII"
    ]
    .map(fromRoman)
    .join("\n");
})();
