(() => {

    /// Delimiter list -> String -> list of parts, delimiters, offsets

    // multiSplit :: [String] -> String ->
    //      [{part::String, delim::String, offset::Int}]
    const multiSplit = (ds, s) => {
        const
            dcs = map(chars, ds),
            xs = chars(s),
            dct = foldl(
                (a, c, i, s) => {
                    const
                        inDelim = a.offset > i,
                        mb = inDelim ? (
                            nothing('')
                        ) : find(d => isPrefixOf(d, drop(i, xs)), dcs);
                    return mb.nothing ? {
                        tokens: a.tokens.concat(inDelim ? (
                            []
                        ) : [c]),
                        parts: a.parts,
                        offset: a.offset
                    } : {
                        tokens: [],
                        parts: append(a.parts, [{
                            part: intercalate('', a.tokens),
                            delim: intercalate('', mb.just),
                            offset: i
                        }]),
                        offset: i + length(mb.just)
                    };
                }, {
                    tokens: [],
                    parts: [],
                    offset: 0
                }, xs
            );
        return append(dct.parts, [{
            part: intercalate('', dct.tokens),
            delim: "",
            offset: length(s)
        }]);
    };

    // GENERIC FUNCTIONS -----------------------------------------------------

    // append (++) :: [a] -> [a] -> [a]
    const append = (xs, ys) => xs.concat(ys);

    // chars :: String -> [Char]
    const chars = s => s.split('');

    // drop :: Int -> [a] -> [a]
    // drop :: Int -> String -> String
    const drop = (n, xs) => xs.slice(n);

    // find :: (a -> Bool) -> [a] -> Maybe a
    const find = (p, xs) => {
        for (var i = 0, lng = xs.length; i < lng; i++) {
            var x = xs[i];
            if (p(x)) return just(x);
        }
        return nothing('Not found');
    };

    // foldl :: (a -> b -> a) -> a -> [b] -> a
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // intercalate :: String -> [String] -> String
    const intercalate = (s, xs) => xs.join(s);

    // isPrefixOf takes two lists or strings and returns
    // true iff the first is a prefix of the second.
    // isPrefixOf :: [a] -> [a] -> Bool
    // isPrefixOf :: String -> String -> Bool
    const isPrefixOf = (xs, ys) => {
        const pfx = (xs, ys) => xs.length ? (
            ys.length ? xs[0] === ys[0] && pfx(
                xs.slice(1), ys.slice(1)
            ) : false
        ) : true;
        return typeof xs !== 'string' ? pfx(xs, ys) : ys.startsWith(xs);
    };

    // just :: a -> Just a
    const just = x => ({
        nothing: false,
        just: x
    });

    // length :: [a] -> Int
    const length = xs => xs.length;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // nothing :: () -> Nothing
    const nothing = (optionalMsg) => ({
        nothing: true,
        msg: optionalMsg
    });

    // show :: Int -> a -> Indented String
    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[1], null, x[0]] : x
        );

    // TEST ------------------------------------------------------------------
    const
        strTest = 'a!===b=!=c',
        delims = ['==', '!=', '='];

    return show(2,
        multiSplit(delims, strTest)
    );
})();
