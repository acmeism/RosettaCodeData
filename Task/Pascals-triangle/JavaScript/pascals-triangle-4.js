(() => {
    'use strict';

    // PASCAL'S TRIANGLE ------------------------------------------------------

    // pascal :: Int -> [[Int]]
    const pascal = n =>
        foldl(a => {
            const xs = a.slice(-1)[0]; // Previous row
            return append(a, [
                zipWith(
                    (a, b) => a + b,
                    append([0], xs),
                    append(xs, [0])
                )
            ]);
        }, [
            [1] // Initial seed row
        ], enumFromTo(1, n - 1));


    // GENERIC FUNCTIONS ------------------------------------------------------

    // (++) :: [a] -> [a] -> [a]
    const append = (xs, ys) => xs.concat(ys);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f(b, a);

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // foldr (a -> b -> b) -> b -> [a] -> b
    const foldr = (f, a, xs) => xs.reduceRight(flip(f), a);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // min :: Ord a => a -> a -> a
    const min = (a, b) => b < a ? b : a;

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) =>
        Array.from({
            length: min(xs.length, ys.length)
        }, (_, i) => f(xs[i], ys[i]));

    // TEST -------------------------------------------------------------------
    return foldr((x, a) => {
            const strIndent = a.indent;
            return {
                rows: strIndent + map(n => ('    ' + n)
                        .slice(-4), x)
                    .join('') + '\n' + a.rows,
                indent: strIndent + '  '
            };
        }, {
            rows: '',
            indent: ''
        }, pascal(7))
        .rows;
})();
