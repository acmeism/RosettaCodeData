(max => {

    // amicablePairsUpTo :: Int -> [(Int, Int)]
    let amicablePairsUpTo = max =>
        range(1, max)
        .map(x => properDivisors(x)
            .reduce((a, b) => a + b, 0))
        .reduce((a, m, i, lst) => {
            let n = i + 1;

            return (m > n) && lst[m - 1] === n ?
                a.concat([[n, m]]) : a;
        }, []),


        // properDivisors :: Int -> [Int]
        properDivisors = n => {
            if (n < 2) return [];
            else {
                let rRoot = Math.sqrt(n),
                    intRoot = Math.floor(rRoot),
                    blnPerfectSquare = rRoot === intRoot,

                    lows = range(1, intRoot)
                    .filter(x => (n % x) === 0);

                return lows.concat(lows.slice(1)
                    .map(x => n / x)
                    .reverse()
                    .slice(blnPerfectSquare | 0));
            }
        },

        // Int -> Int -> Maybe Int -> [Int]
        range = (m, n, step) => {
            let d = (step || 1) * (n >= m ? 1 : -1);

            return Array.from({
                length: Math.floor((n - m) / d) + 1
            }, (_, i) => m + (i * d));
        }


    return amicablePairsUpTo(max);

})(20000);
