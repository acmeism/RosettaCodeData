(() => {
    'use strict';

    const main = () => {

        const src = `apples, pears # and bananas
apples, pears ; and bananas`;

        return unlines(
            map(preComment(chars(';#')),
                lines(src)
            )
        );
    };

    // preComment :: [Char] -> String -> String
    const preComment = cs => s =>
        strip(
            takeWhile(
                curry(flip(notElem))(cs),
                s
            )
        );

    // GENERIC FUNCTIONS ------------------------------

    // chars :: String -> [Char]
    const chars = s => s.split('');

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // lines :: String -> [String]
    const lines = s => s.split(/[\r\n]/);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // notElem :: Eq a => a -> [a] -> Bool
    const notElem = (x, xs) => -1 === xs.indexOf(x);

    // strip :: String -> String
    const strip = s => s.trim();

    // takeWhile :: (a -> Bool) -> [a] -> [a]
    // takeWhile :: (Char -> Bool) -> String -> String
    const takeWhile = (p, xs) => {
        let i = 0;
        const lng = xs.length;
        while ((i < lng) && p(xs[i]))(i = i + 1);
        return xs.slice(0, i);
    };

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // MAIN ---
    return main();
})();
