(() => {
    'use strict';

    // LINES OF SIERPINSKI TRIANGLE AT LEVEL N -------------------------------

    // sierpinski :: Int -> [String]
    const sierpTriangle = n =>
        // Previous triangle centered with left and right padding,
        (n > 0) ? concat(ap([
            map(xs => intercalate(xs, ap(
                [s => concat(replicate(Math.pow(2, (n - 1)), s))], [' ', '-']
            ))),

            // above a pair of duplicates, placed one character apart.
            map(xs => intercalate('+', [xs, xs]))
        ], [sierpTriangle(n - 1)])) : ['▲'];


    // GENERIC FUNCTIONS -----------------------------------------------------

    // replicate :: Int -> a -> [a]
    const replicate = (n, a) => {
        let v = [a],
            o = [];
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    };

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // map :: (a -> b) -> [a] -> [b]
    const map = curry((f, xs) => xs.map(f));

    // Apply a list of functions to a list of arguments
    // <*> :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        [].concat.apply([], fs.map(f => //
            [].concat.apply([], xs.map(x => [f(x)]))));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // concat :: [[a]] -> [a] || [String] -> String
    const concat = xs => {
        if (xs.length > 0) {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        } else return [];
    };

    // TEST ------------------------------------------------------------------
    return unlines(sierpTriangle(4));
})();
