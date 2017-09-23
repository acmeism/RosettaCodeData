(() => {
    'use strict';

    // COMMA QUIBBLING -------------------------------------------------------

    // quibble :: [String] -> String
    const quibble = xs =>
        (xs.length > 1) ? (
            intercalate(
                " and ",
                ap(
                    [compose([intercalate(", "), reverse, tail]), head], //
                    [reverse(xs)]
                )
            )
        ) : concat(xs);


    // GENERIC FUNCTIONS -----------------------------------------------------

    // A list of functions applied to a list of arguments
    // <*> :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        [].concat.apply([], fs.map(f => //
            [].concat.apply([], xs.map(x => [f(x)]))));

    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat([].slice.apply(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // intercalate :: String -> [a] -> String
    const intercalate = curry((s, xs) => xs.join(s));

    // concat :: [[a]] -> [a] | [String] -> String
    const concat = xs => {
        if (xs.length > 0) {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        } else return [];
    };

    // compose :: [(a -> a)] -> (a -> a)
    const compose = fs => x => fs.reduceRight((a, f) => f(a), x);

    // map :: (a -> b) -> [a] -> [b]
    const map = curry((f, xs) => xs.map(f));

    // reverse :: [a] -> [a]
    const reverse = xs =>
        typeof xs === 'string' ? (
            xs.split('')
            .reverse()
            .join('')
        ) : xs.slice(0)
        .reverse();

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // tail :: [a] -> [a]
    const tail = xs => xs.length ? xs.slice(1) : undefined;

    // (++) :: [a] -> [a] -> [a]
    const append = (xs, ys) => xs.concat(ys);

    // words :: String -> [String]
    const words = s => s.split(/\s+/);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');


    // TEST ------------------------------------------------------------------
    return unlines(
        map(
            compose([x => '{' + x + '}', quibble]),
            append([
                [],
                ["ABC"],
                ["ABC", "DEF"],
                ["ABC", "DEF", "G", "H"]
            ], map(
                words, [
                    "One two three four", "Me myself I", "Jack Jill", "Loner"
                ]
            ))
        ));
})();
