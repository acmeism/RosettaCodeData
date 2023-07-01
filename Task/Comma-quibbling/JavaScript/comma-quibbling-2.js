(() => {
    'use strict';

    // ----------------- COMMA QUIBBLING -----------------

    // quibble :: [String] -> String
    const quibble = xs =>
        1 < xs.length ? (
            intercalate(' and ')(
                ap([
                    compose(
                        intercalate(', '),
                        reverse,
                        tail
                    ),
                    head
                ])([reverse(xs)])
            )
        ) : concat(xs);


    // ---------------------- TEST -----------------------
    const main = () =>
        unlines(
            map(compose(x => '{' + x + '}', quibble))(
                append([
                    [],
                    ["ABC"],
                    ["ABC", "DEF"],
                    ["ABC", "DEF", "G", "H"]
                ])(
                    map(words)([
                        "One two three four",
                        "Me myself I",
                        "Jack Jill",
                        "Loner"
                    ])
                )
            ));


    // ---------------- GENERIC FUNCTIONS ----------------

    // ap (<*>) :: [(a -> b)] -> [a] -> [b]
    const ap = fs =>
        // The sequential application of each of a list
        // of functions to each of a list of values.
        // apList([x => 2 * x, x => 20 + x])([1, 2, 3])
        //     -> [2, 4, 6, 21, 22, 23]
        xs => fs.flatMap(f => xs.map(f));


    // append (++) :: [a] -> [a] -> [a]
    const append = xs =>
        // A list defined by the
        // concatenation of two others.
        ys => xs.concat(ys);


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs => (
        ys => 0 < ys.length ? (
            ys.every(Array.isArray) ? (
                []
            ) : ''
        ).concat(...ys) : ys
    )(xs);


    // head :: [a] -> a
    const head = xs => (
        ys => ys.length ? (
            ys[0]
        ) : undefined
    )(list(xs));


    // intercalate :: String -> [String] -> String
    const intercalate = s =>
        // The concatenation of xs
        // interspersed with copies of s.
        xs => xs.join(s);


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => [...xs].map(f);


    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');


    // tail :: [a] -> [a]
    const tail = xs =>
        // A new list consisting of all
        // items of xs except the first.
        xs.slice(1);


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join('\n');


    // words :: String -> [String]
    const words = s =>
        // List of space-delimited sub-strings.
        s.split(/\s+/);

    // MAIN ---
    return main();
})();
