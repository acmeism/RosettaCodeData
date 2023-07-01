(() => {

    // magicSquare :: Int -> [[Int]]
    const magicSquare = n =>
        n % 2 !== 0 ? (
            compose([transpose, cycled, transpose, cycled, enumSquare])(n)
        ) : [];

    // Size of square -> rows containing integers [1..]
    // enumSquare :: Int -> [[Int]]
    const enumSquare = n =>
        chunksOf(n, enumFromTo(1, n * n));

    // Table of integers -> Table with rows rotated by descending deltas
    // cycled :: [[Int]] -> [[Int]]
    const cycled = rows => {
        const d = Math.floor(rows.length / 2);
        return zipWith(listCycle, enumFromTo(d, -d), rows)
    };

    // Number of positions to shift to right -> List -> Wrap-cycled list
    // listCycle :: Int -> [a] -> [a]
    const listCycle = (n, xs) => {
        const d = -(n % xs.length);
        return (d !== 0 ? xs.slice(d)
            .concat(xs.slice(0, d)) : xs);
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = (n, xs) =>
        xs.reduce((a, _, i, xs) =>
            i % n ? a : a.concat([xs.slice(i, i + n)]), []);

    // compose :: [(a -> a)] -> (a -> a)
    const compose = fs => x => fs.reduceRight((a, f) => f(a), x);

    // enumFromTo :: Int -> Int -> Maybe Int -> [Int]
    const enumFromTo = (m, n, step) => {
        const d = (step || 1) * (n >= m ? 1 : -1);
        return Array.from({
            length: Math.floor((n - m) / d) + 1
        }, (_, i) => m + (i * d));
    };

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // min :: Ord a => a -> a -> a
    const min = (a, b) => b < a ? b : a;

    // show :: a -> String
    const show = JSON.stringify;

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map(row => row[iCol]));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) =>
        Array.from({
            length: min(xs.length, ys.length)
        }, (_, i) => f(xs[i], ys[i]));

    // TEST -------------------------------------------------------------------
    return intercalate('\n\n', [3, 5, 7]
        .map(magicSquare)
        .map(xs => unlines(xs.map(show))));
})();
