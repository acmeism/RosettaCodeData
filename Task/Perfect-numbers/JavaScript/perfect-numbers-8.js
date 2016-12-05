((nFrom, nTo) => {

    // perfect :: Int -> Bool
    let perfect = n => {
            let lows = range(1, Math.floor(Math.sqrt(n)))
                .filter(x => (n % x) === 0);

            return n > 1 && lows.concat(lows.map(x => n / x))
                .reduce((a, x) => (a + x), 0) / 2 === n;
        },

        // range :: Int -> Int -> Maybe Int -> [Int]
        range = (m, n, step) => {
            let d = (step || 1) * (n >= m ? 1 : -1);

            return Array.from({
                length: Math.floor((n - m) / d) + 1
            }, (_, i) => m + (i * d));
        };

    return range(nFrom, nTo)
        .filter(perfect);

})(1, 10000);
