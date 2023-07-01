(() => {
    'use strict'

    // reverseString, reverseEachWord, reverseWordOrder :: String -> String
    const
        reverseString = s => reverse(s),

        reverseEachWord = s => wordLevel(map(reverse))(s),

        reverseWordOrder = s => wordLevel(reverse)(s);

    // wordLevel :: ([String] -> [String]) -> String -> String
    const wordLevel = f =>
        x => unwords(f(words(x)));


    // GENERIC FUNCTIONS -----------------------------------------------------

    // A list of functions applied to a list of arguments
    // <*> :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        [].concat.apply([], fs.map(f => //
            [].concat.apply([], xs.map(x => [f(x)]))));

    // 2 or more arguments
    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat(Array.from(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = curry((f, xs) => xs.map(f));

    // reverse :: [a] -> [a]
    const reverse = curry(xs =>
        typeof xs === 'string' ? (
            xs.split('')
            .reverse()
            .join('')
        ) : xs.slice(0)
        .reverse());

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // words :: String -> [String]
    const words = s => s.split(/\s+/);


    // TEST ------------------------------------------------------------------
    return unlines(
        ap([
            reverseString,
            reverseEachWord,
            reverseWordOrder
        ], ["rosetta code phrase reversal"])
    );
})();
