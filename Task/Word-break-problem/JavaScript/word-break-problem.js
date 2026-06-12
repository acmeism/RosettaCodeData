(() => {
    'use strict';

    const main = () => {
        const
            wds = words('a bc abc cd b'),
            texts = words('abcd abbc abcbcd acdbc abcdd');

        return unlines(
            map(wordBreaks(wds),
                texts
            )
        );
    };

    // WORD BREAKS ----------------------------------------

    // tokenTrees :: [String] -> String -> [Tree String]
    const tokenTrees = (wds, s) => {
        const go = s =>
            wds.includes(s) ? (
                [Node(s, [])]
            ) : bindList(wds, next(s));
        const next = s => w =>
            s.startsWith(w) ? (
                parse(w, go(s.slice(w.length)))
            ) : [];
        const parse = (w, xs) =>
            0 < xs.length ? [Node(w, xs)] : xs;
        return go(s);
    };

    // wordBreaks :: [String] -> String -> String
    const wordBreaks = wds => s => {
        const
            // go :: Tree a -> [a]
            go = t => isNull(t.nest) ? [
                t.root
            ] : bindList(
                t.nest,
                compose(cons(t.root), go),
            ),
            parses = map(go, tokenTrees(wds, s));
        return `${s}:\n` + (
            0 < parses.length ? unlines(
                map(x => '\t' + intercalateS(' -> ', x),
                    parses
                )
            ) : '\t(Not parseable with these words)'
        );
    };

    // GENERIC FUNCTIONS ----------------------------------

    // Node :: a -> [Tree a] -> Tree a
    const Node = (v, xs) => ({
        type: 'Node',
        root: v,
        nest: xs || []
    });

    // bindList (>>=) :: [a] -> (a -> [b]) -> [b]
    const bindList = (xs, mf) => [].concat.apply([], xs.map(mf));

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (f, g) => x => f(g(x));

    // cons :: a -> [a] -> [a]
    const cons = x => xs => [x].concat(xs);

    // intercalateS :: String -> [String] -> String
    const intercalateS = (s, xs) =>
        xs.join(s);

    // isNull :: [a] -> Bool
    // isNull :: String -> Bool
    const isNull = xs =>
        Array.isArray(xs) || ('string' === typeof xs) ? (
            1 > xs.length
        ) : undefined;

    // isPrefixOf takes two lists or strings and returns
    // true iff the first is a prefix of the second.

    // isPrefixOf :: [a] -> [a] -> Bool
    // isPrefixOf :: String -> String -> Bool
    const isPrefixOf = (xs, ys) => {
        const pfx = (xs, ys) => {
            const intX = xs.length;
            return 0 < intX ? (
                ys.length >= intX ? xs[0] === ys[0] && pfx(
                    xs.slice(1), ys.slice(1)
                ) : false
            ) : true;
        };
        return 'string' !== typeof xs ? (
            pfx(xs, ys)
        ) : ys.startsWith(xs);
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // words :: String -> [String]
    const words = s => s.split(/\s+/);

    // MAIN ---
    return main();
})();
