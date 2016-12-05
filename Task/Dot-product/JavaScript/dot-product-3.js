(() => {
    'use strict';

    // dotProduct :: [Int] -> [Int] -> Int
    const dotProduct = (xs, ys) => {
        const sum = xs => xs ? xs.reduce((a, b) => a + b, 0) : undefined;

        return xs.length === ys.length ? (
            sum(zipWith((a, b) => a * b, xs, ys))
        ) : undefined;
    }

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const ny = ys.length;
        return (xs.length <= ny ? xs : xs.slice(0, ny))
            .map((x, i) => f(x, ys[i]));
    }

    return dotProduct([1, 3, -5], [4, -2, -1]);
})();
