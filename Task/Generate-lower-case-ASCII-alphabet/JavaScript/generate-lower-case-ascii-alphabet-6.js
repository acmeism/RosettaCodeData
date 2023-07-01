(() => {
    // enumFromTo :: Enum a => a -> a -> [a]
    const enumFromTo = (m, n) => {
        const [intM, intN] = [m, n].map(fromEnum),
            f = typeof m === 'string' ? (
                (_, i) => chr(intM + i)
            ) : (_, i) => intM + i;
        return Array.from({
            length: Math.floor(intN - intM) + 1
        }, f);
    };


    // GENERIC FUNCTIONS ------------------------------------------------------

    // compose :: (b -> c) -> (a -> b) -> (a -> c)
    const compose = (f, g) => x => f(g(x));

    // chr :: Int -> Char
    const chr = x => String.fromCodePoint(x);

    // ord :: Char -> Int
    const ord = c => c.codePointAt(0);

    // fromEnum :: Enum a => a -> Int
    const fromEnum = x => {
        const type = typeof x;
        return type === 'boolean' ? (
            x ? 1 : 0
        ) : type === 'string' ? ord(x) : x;
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // show :: a -> String
    const show = x => JSON.stringify(x);

    // uncurry :: Function -> Function
    const uncurry = f => args => f.apply(null, args);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // TEST -------------------------------------------------------------------
    return unlines(map(compose(unwords, uncurry(enumFromTo)), [
        ['a', 'z'],
        ['α', 'ω'],
        ['א', 'ת'],
        ['🐐', '🐟']
    ]));
})();
