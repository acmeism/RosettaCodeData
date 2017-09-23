(() => {

    // showIntAtBase_ :: // Int -> Int -> String
    const showIntAtBase_ = (base, n) => (n)
        .toString(base);

    // showBin :: Int -> String
    const showBin = n => showIntAtBase_(2, n);

    // GENERIC FUNCTIONS FOR TEST ---------------------------------------------

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // show :: a -> String
    const show = x => JSON.stringify(x);

    // TEST -------------------------------------------------------------------

    return unlines(map(
        n => intercalate(' -> ', [show(n), showBin(n)]),
        [5, 50, 9000]
    ));
})();
