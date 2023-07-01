(() => {
    const main = () =>
        enumFromTo(1, 10000).filter(perfect);

    // perfect :: Int -> Bool
    const perfect = n => {
        const
            lows = enumFromTo(1, Math.floor(Math.sqrt(n)))
            .filter(x => (n % x) === 0);

        return n > 1 && lows.concat(lows.map(x => n / x))
            .reduce((a, x) => (a + x), 0) / 2 === n;
    };

    // GENERIC --------------------------------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: n - m + 1
        }, (_, i) => i + m)

    // MAIN ---
    return main();
})();
