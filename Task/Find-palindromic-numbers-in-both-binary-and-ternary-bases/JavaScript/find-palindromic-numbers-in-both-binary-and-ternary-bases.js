(() => {
    'use strict';

    // GENERIC FUNCTIONS

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // compose :: (b -> c) -> (a -> b) -> (a -> c)
    const compose = (f, g) => x => f(g(x));

    // listApply :: [(a -> b)] -> [a] -> [b]
    const listApply = (fs, xs) =>
        [].concat.apply([], fs.map(f =>
        [].concat.apply([], xs.map(x => [f(x)]))));

    // pure :: a -> [a]
    const pure = x => [x];

    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat([].slice.apply(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map(row => row[iCol]));

    // reverse :: [a] -> [a]
    const reverse = xs =>
        typeof xs === 'string' ? (
            xs.split('')
            .reverse()
            .join('')
        ) : xs.slice(0)
        .reverse();

    // take :: Int -> [a] -> [a]
    const take = (n, xs) => xs.slice(0, n);

    // drop :: Int -> [a] -> [a]
    const drop = (n, xs) => xs.slice(n);

    // maximum :: [a] -> a
    const maximum = xs =>
        xs.reduce((a, x) => (x > a || a === undefined ? x : a), undefined);

    // quotRem :: Integral a => a -> a -> (a, a)
    const quotRem = (m, n) => [Math.floor(m / n), m % n];

    // length :: [a] -> Int
    const length = xs => xs.length;

    // justifyLeft :: Int -> Char -> Text -> Text
    const justifyLeft = (n, cFiller, strText) =>
        n > strText.length ? (
            (strText + cFiller.repeat(n))
            .substr(0, n)
        ) : strText;

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');


    // BASES AND PALINDROMES

    // show, showBinary, showTernary :: Int -> String
    const show = n => n.toString(10);
    const showBinary = n => n.toString(2);
    const showTernary = n => n.toString(3);

    // readBase3 :: String -> Int
    const readBase3 = s => parseInt(s, 3);

    // base3Palindrome :: Int -> String
    const base3Palindrome = n => {
        const s = showTernary(n);
        return s + '1' + reverse(s);
    };

    // isBinPal :: Int -> Bool
    const isBinPal = n => {
        const
            s = showBinary(n),
            [q, r] = quotRem(s.length, 2);
        return (r !== 0) && drop(q + 1, s) === reverse(take(q, s));
    };

    // solutions :: [Int]
    const solutions = [0, 1].concat(range(1, 10E5)
        .map(compose(readBase3, base3Palindrome))
        .filter(isBinPal));

    // TABULATION

    // cols :: [[Int]]
    const cols = transpose(
        [
            ['Decimal', 'Ternary', 'Binary']
        ].concat(
            solutions.map(
                compose(
                    xs => listApply([show, showTernary, showBinary], xs),
                    pure
                )
            )
        )
    );

    return unlines(
        transpose(cols.map(col => col.map(
            curry(justifyLeft)(maximum(col.map(length)) + 1, ' ')
        )))
        .map(unwords));
})();
