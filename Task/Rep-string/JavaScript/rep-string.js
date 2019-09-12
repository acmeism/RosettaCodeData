(() => {
    'use strict';

    const main = () => {

        // REP-CYCLES -------------------------------------

        // repCycles :: String -> [String]
        const repCycles = s => {
            const n = s.length;
            return filter(
                x => s === take(n, cycle(x)).join(''),
                tail(inits(take(quot(n, 2), s)))
            );
        };

        // TEST -------------------------------------------
        console.log(fTable(
            'Longest cycles:\n',
            str,
            xs => 0 < xs.length ? concat(last(xs)) : '(none)',
            repCycles,
            [
                '1001110011',
                '1110111011',
                '0010010010',
                '1010101010',
                '1111111111',
                '0100101101',
                '0100100',
                '101',
                '11',
                '00',
                '1'
            ]
        ));
    };

    // GENERIC FUNCTIONS ----------------------------------

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];

    // cycle :: [a] -> Generator [a]
    function* cycle(xs) {
        const lng = xs.length;
        let i = 0;
        while (true) {
            yield(xs[i])
            i = (1 + i) % lng;
        }
    }

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // fTable :: String -> (a -> String) ->
    //                     (b -> String) -> (a -> b) -> [a] -> String
    const fTable = (s, xShow, fxShow, f, xs) => {
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        const
            ys = xs.map(xShow),
            w = Math.max(...ys.map(length));
        return s + '\n' + zipWith(
            (a, b) => a.padStart(w, ' ') + ' -> ' + b,
            ys,
            xs.map(x => fxShow(f(x)))
        ).join('\n');
    };

    // inits([1, 2, 3]) -> [[], [1], [1, 2], [1, 2, 3]
    // inits('abc') -> ["", "a", "ab", "abc"]

    // inits :: [a] -> [[a]]
    // inits :: String -> [String]
    const inits = xs => [
            []
        ]
        .concat(('string' === typeof xs ? xs.split('') : xs)
            .map((_, i, lst) => lst.slice(0, 1 + i)));

    // last :: [a] -> a
    const last = xs =>
        0 < xs.length ? xs.slice(-1)[0] : undefined;

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // quot :: Int -> Int -> Int
    const quot = (n, m) => Math.floor(n / m);

    // str :: a -> String
    const str = x => x.toString();

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // Use of `take` and `length` here allows zipping with non-finite lists
    // i.e. generators like cycle, repeat, iterate.

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const
            lng = Math.min(length(xs), length(ys)),
            as = take(lng, xs),
            bs = take(lng, ys);
        return Array.from({
            length: lng
        }, (_, i) => f(as[i], bs[i], i));
    };

    // MAIN ---
    return main();
})();
