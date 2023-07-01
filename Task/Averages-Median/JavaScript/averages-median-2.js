(() => {
    'use strict';

    // median :: [Num] -> Num
    function median(xs) {
        // nth :: [Num] -> Int -> Maybe Num
        let nth = (xxs, n) => {
                if (xxs.length > 0) {
                    let [x, xs] = uncons(xxs),
                        [ys, zs] = partition(y => y < x, xs),
                        k = ys.length;

                    return k === n ? x : (
                        k > n ? nth(ys, n) : nth(zs, n - k - 1)
                    );
                } else return undefined;
            },
            n = xs.length;

        return even(n) ? (
            (nth(xs, div(n, 2)) + nth(xs, div(n, 2) - 1)) / 2
        ) : nth(xs, div(n, 2));
    }



    // GENERIC

    // partition :: (a -> Bool) -> [a] -> ([a], [a])
    let partition = (p, xs) =>
        xs.reduce((a, x) =>
            p(x) ? [a[0].concat(x), a[1]] : [a[0], a[1].concat(x)], [
                [],
                []
            ]),

        // uncons :: [a] -> Maybe (a, [a])
        uncons = xs => xs.length ? [xs[0], xs.slice(1)] : undefined,

        // even :: Integral a => a -> Bool
        even = n => n % 2 === 0,

        // div :: Num -> Num -> Int
        div = (x, y) => Math.floor(x / y);

    return [
        [],
        [5, 3, 4],
        [5, 4, 2, 3],
        [3, 4, 1, -8.4, 7.2, 4, 1, 1.2]
    ].map(median);
})();
