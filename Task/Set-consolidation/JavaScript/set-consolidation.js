(() => {
    'use strict';

    // consolidated :: Ord a => [Set a] -> [Set a]
    const consolidated = xs => {
        const go = (s, xs) =>
            0 !== xs.length ? (() => {
                const h = xs[0];
                return 0 === intersection(h, s).size ? (
                    [h].concat(go(s, tail(xs)))
                ) : go(union(h, s), tail(xs));
            })() : [s];
        return foldr(go, [], xs);
    };


    // TESTS ----------------------------------------------
    const main = () =>
        map(xs => intercalate(
                ', and ',
                map(showSet, consolidated(xs))
            ),
            map(x => map(
                    s => new Set(chars(s)),
                    x
                ),
                [
                    ['ab', 'cd'],
                    ['ab', 'bd'],
                    ['ab', 'cd', 'db'],
                    ['hik', 'ab', 'cd', 'db', 'fgh']
                ]
            )
        ).join('\n');


    // GENERIC FUNCTIONS ----------------------------------

    // chars :: String -> [Char]
    const chars = s => s.split('');

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];

    // elems :: Dict -> [a]
    // elems :: Set -> [a]
    const elems = x =>
        'Set' !== x.constructor.name ? (
            Object.values(x)
        ) : Array.from(x.values());

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));

    // Note that that the Haskell signature of foldr differs from that of
    // foldl - the positions of accumulator and current value are reversed

    // foldr :: (a -> b -> b) -> b -> [a] -> b
    const foldr = (f, a, xs) => xs.reduceRight(flip(f), a);

    // intercalate :: [a] -> [[a]] -> [a]
    // intercalate :: String -> [String] -> String
    const intercalate = (sep, xs) =>
        0 < xs.length && 'string' === typeof sep &&
        'string' === typeof xs[0] ? (
            xs.join(sep)
        ) : concat(intersperse(sep, xs));

    // intersection :: Ord a => Set a -> Set a -> Set a
    const intersection = (s, s1) =>
        new Set([...s].filter(x => s1.has(x)));

    // intersperse :: a -> [a] -> [a]
    // intersperse :: Char -> String -> String
    const intersperse = (sep, xs) => {
        const bln = 'string' === typeof xs;
        return xs.length > 1 ? (
            (bln ? concat : x => x)(
                (bln ? (
                    xs.split('')
                ) : xs)
                .slice(1)
                .reduce((a, x) => a.concat([sep, x]), [xs[0]])
            )) : xs;
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // showSet :: Set -> String
    const showSet = s =>
        intercalate(elems(s), ['{', '}']);

    // sort :: Ord a => [a] -> [a]
    const sort = xs => xs.slice()
        .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

    // union :: Ord a => Set a -> Set a -> Set a
    const union = (s, s1) =>
        Array.from(s1.values())
        .reduce(
            (a, x) => (a.add(x), a),
            new Set(s)
        );

    // MAIN ---
    return main();
})();
