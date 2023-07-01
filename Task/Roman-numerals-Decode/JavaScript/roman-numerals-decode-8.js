(() => {

    // -------------- ROMAN NUMERALS DECODED ---------------

    // Folding from right to left,
    // lower leftward characters are subtracted,
    // others are added.

    // fromRoman :: String -> Int
    const fromRoman = s =>
        foldr(l => ([r, n]) => [
            l,
            l >= r ? (
                n + l
            ) : n - l
        ])([0, 0])(
            [...s].map(charVal)
        )[1];

    // charVal :: Char -> Maybe Int
    const charVal = k => {
        const v = {
            I: 1,
            V: 5,
            X: 10,
            L: 50,
            C: 100,
            D: 500,
            M: 1000
        } [k];
        return v !== undefined ? v : 0;
    };

    // ----------------------- TEST ------------------------
    const main = () => [
            'MDCLXVI', 'MCMXC', 'MMVIII', 'MMXVI', 'MMXVII'
        ]
        .map(fromRoman)
        .join('\n');


    // ----------------- GENERIC FUNCTIONS -----------------

    // foldr :: (a -> b -> b) -> b -> [a] -> b
    const foldr = f =>
        // Note that that the Haskell signature of foldr
        // differs from that of foldl - the positions of
        // accumulator and current value are reversed.
        a => xs => [...xs].reduceRight(
            (a, x) => f(x)(a),
            a
        );

    // MAIN ---
    return main();
})();
