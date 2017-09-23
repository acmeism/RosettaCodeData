(() => {

    // Folding from right to left,
    // lower leftward characters are subtracted,
    // others are added.

    // fromRoman :: String -> Int
    const fromRoman = s =>
        snd(foldr(
            ([r, n], l) => [l, l >= r ? n + l : n - l], [0, 0],
            map(charVal, stringChars(s))
        ));

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
        }[k];
        return v !== undefined ? v : 0;
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // foldr (a -> b -> b) -> b -> [a] -> b
    const foldr = (f, a, xs) => xs.reduceRight(f, a);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // snd :: (a, b) -> b
    const snd = tpl => Array.isArray(tpl) ? tpl[1] : undefined;

    // stringChars :: String -> [Char]
    const stringChars = s => s.split('');

    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[1], null, x[0]] : x
        );

    // TEST -------------------------------------------------------------------
    return show(
        map(fromRoman, ["MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVII"])
    );
})();
