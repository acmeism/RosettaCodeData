(() => {
    'use strict';

    // levenshtein :: String -> String -> Int
    const levenshtein = (sa, sb) => {
        const [s1, s2] = [sa.split(''), sb.split('')];

        return last(s2.reduce((ns, c) => {
            const [n, ns1] = uncons(ns);

            return scanl(
                (z, [c1, x, y]) =>
                minimum(
                    [y + 1, z + 1, x + fromEnum(c1 != c)]
                ),
                n + 1,
                zip3(s1, ns, ns1)
            );
        }, range(0, s1.length)));
    };


    /*********************************************************************/
    // GENERIC FUNCTIONS

    // minimum :: [a] -> a
    const minimum = xs =>
        xs.reduce((a, x) => (x < a || a === undefined ? x : a), undefined);

    // fromEnum :: Enum a => a -> Int
    const fromEnum = x => {
        const type = typeof x;
        return type === 'boolean' ? (
            x ? 1 : 0
        ) : (type === 'string' ? x.charCodeAt(0) : undefined);
    };

    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => xs.length ? [xs[0], xs.slice(1)] : undefined;

    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = (f, a, xs) => {
        for (var lst = [a], lng = xs.length, i = 0; i < lng; i++) {
            a = f(a, xs[i], i, xs), lst.push(a);
        }
        return lst;
    };

    // zip3 :: [a] -> [b] -> [c] -> [(a,b,c)]
    const zip3 = (xs, ys, zs) =>
        xs.slice(0, Math.min(xs.length, ys.length, zs.length))
        .map((x, i) => [x, ys[i], zs[i]]);

    // last :: [a] -> a
    const last = xs => xs.length ? xs.slice(-1) : undefined;

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    /*********************************************************************/
    // TEST
    return [
        ["kitten", "sitting"],
        ["sitting", "kitten"],
        ["rosettacode", "raisethysword"],
        ["raisethysword", "rosettacode"]
    ].map(pair => levenshtein.apply(null, pair));

    // -> [3, 3, 8, 8]
})();
