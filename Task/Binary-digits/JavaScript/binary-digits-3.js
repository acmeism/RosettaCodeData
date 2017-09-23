(() => {

    // showBin :: Int -> String
    const showBin = n => {
        const binaryChar = n => n !== 0 ? '一' : '〇';

        return showIntAtBase(2, binaryChar, n, '');
    };

    // showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
    const showIntAtBase = (base, toChr, n, rs) => {
        const showIt = ([n, d], r) => {
            const r_ = toChr(d) + r;
            return n !== 0 ? (
                showIt(quotRem(n, base), r_)
            ) : r_;
        };
        return base <= 1 ? (
            'error: showIntAtBase applied to unsupported base'
        ) : n < 0 ? (
            'error: showIntAtBase applied to negative number'
        ) : showIt(quotRem(n, base), rs);
    };

    // quotRem :: Integral a => a -> a -> (a, a)
    const quotRem = (m, n) => [Math.floor(m / n), m % n];

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
        n => intercalate(' -> ', [show(n), showBin(n)]), [5, 50, 9000]
    ));
})();
