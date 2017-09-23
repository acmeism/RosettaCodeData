(() => {
    const dctMemo = {};

    // Length only of hailstone sequence
    // collatzLength :: Int -> Int
    const collatzLength = n => {
        let i = 1;
        let a = n;
        let lng;

        while (a !== 1) {
            lng = dctMemo[a];
            if ('u' === (typeof lng)[0]) {
                a = (a % 2 ? 3 * a + 1 : a / 2);
                i++;
            } else return lng + i - 1;
        }
        return i;
    };

    // range :: Int -> Int -> Maybe Int -> [Int]
    const range = (m, n, delta) => {
        const blnUp = n > m,
            d = blnUp ? (delta || 1) : -(delta || 1),
            lng = Math.abs(Math.floor((blnUp ? n - m : m - n) / d) + 1),
            a = Array(lng);
        let i = lng;

        while (i--) a[i] = (d * i) + m;
        return a;
    };

    // longestBelow :: Int -> {Number::Int, Length:Int}
    const longestBelow = n =>
        range(1, n)
        .reduce(
            (a, x) => {
                const lng = dctMemo[x] || (dctMemo[x] = collatzLength(x));

                return lng > a.l ? {
                    n: x,
                    l: lng
                } : a

            }, {
                n: 0,
                l: 0
            }
        );

    // TEST
    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    return show(
        [100000, 1000000, 10000000].map(longestBelow)
    );
})();
