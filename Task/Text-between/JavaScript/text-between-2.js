(() => {
    'use strict';

    // TEXT BETWEEN ----------------------------------------------------------

    // Delimiter pair -> Haystack -> Any enclosed text
    // textBetween :: (Either String String, Either String String) ->
    //                      String -> String
    const textBetween = ([start, end], txt) => {
        const
            retain = (post, part, delim, t) =>
            either(
                d => just(const_(t, d)), // 'start' or 'end'. No clipping.
                d => post(part(flip(breakOnDef)(t, d))), // One side of break
                delim
            ),
            mbResidue = bindMay(
                retain( // Start token stripped from text after any break
                    curry(stripPrefix)(start.Right),
                    snd, start, txt
                ), // Left side of any break retained.
                curry(retain)(just, fst, end)
            );
        return mbResidue.nothing ? (
            ""
        ) : mbResidue.just;
    }

    // GENERIC FUNCTIONS -----------------------------------------------------

    // append (++) :: [a] -> [a] -> [a]
    const append = (xs, ys) => xs.concat(ys);

    // bindMay (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
    const bindMay = (mb, mf) =>
        mb.nothing ? mb : mf(mb.just);

    // Needle -> Haystack -> (prefix before match, match + rest)
    // breakOnDef :: String -> String -> (String, String)
    const breakOnDef = (pat, src) =>
        Boolean(pat) ? (() => {
            const xs = src.split(pat);
            return xs.length > 1 ? [
                xs[0], src.slice(xs[0].length)
            ] : [src, ''];
        })() : undefined;

    // const_ :: a -> b -> a
    const const_ = (k, _) => k;

    // Handles two or more arguments
    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat(Array.from(arguments)));
            };
        return go([].slice.call(args));
    };

    // drop :: Int -> [a] -> [a]
    // drop :: Int -> String -> String
    const drop = (n, xs) => xs.slice(n);

    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = (lf, rf, e) => {
        const ks = Object.keys(e);
        return elem('Left', ks) ? (
            lf(e.Left)
        ) : elem('Right', ks) ? (
            rf(e.Right)
        ) : undefined;
    };

    // elem :: Eq a => a -> [a] -> Bool
    const elem = (x, xs) => xs.includes(x);

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // fst :: (a, b) -> a
    const fst = pair => pair.length === 2 ? pair[0] : undefined;

    // just :: a -> Just a
    const just = x => ({
        nothing: false,
        just: x
    });

    // Left :: a -> Either a b
    const Left = x => ({
        Left: x
    });

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // min :: Ord a => a -> a -> a
    const min = (a, b) => b < a ? b : a;

    // nothing :: () -> Nothing
    const nothing = (optionalMsg) => ({
        nothing: true,
        msg: optionalMsg
    });

    // Right :: b -> Either a b
    const Right = x => ({
        Right: x
    });

    // show :: Int -> a -> Indented String
    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[1], null, x[0]] : x
        );

    // snd :: (a, b) -> b
    const snd = tpl => Array.isArray(tpl) ? tpl[1] : undefined;

    // stripPrefix :: Eq a => [a] -> [a] -> Maybe [a]
    const stripPrefix = (pfx, s) => {
        const
            blnString = typeof pfx === 'string',
            [xs, ys] = blnString ? (
                [pfx.split(''), s.split('')]
            ) : [pfx, s];
        const
            sp_ = (xs, ys) => xs.length === 0 ? (
                just(blnString ? ys.join('') : ys)
            ) : (ys.length === 0 || xs[0] !== ys[0]) ? (
                nothing()
            ) : sp_(xs.slice(1), ys.slice(1));
        return sp_(xs, ys);
    };

    // tailDef :: [a] -> [a]
    const tailDef = xs => xs.length > 0 ? xs.slice(1) : [];

    // take :: Int -> [a] -> [a]
    const take = (n, xs) => xs.slice(0, n);

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) =>
        Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => f(xs[i], ys[i], i));


    // TESTS -----------------------------------------------------------------

    // samples :: [String]
    const samples = [
        'Hello Rosetta Code world',
        '</div><div style=\'chinese\'>你好吗</div>',
        '<text>Hello <span>Rosetta Code</span> world</text><table style=\'myTable\'>',
        '<table style=\'myTable\'><tr><td>hello world</td></tr></table>'
    ];

    // delims :: [(Either String String, Either String String)]
    const delims = map(
        curry(map)(x =>
            elem(x, ['start', 'end']) ? (
                Left(x) // Marker token
            ) : Right(x) // Literal text
        ), [
            ['Hello ', ' world'],
            ['start', ' world'],
            ['Hello', 'end'],
            ['<div style=\'chinese\'>', '</div>'],
            ['<text>', '<table>'],
            ['<text>', '</table>']
        ]);

    return show(2,
        append(
            map(
                fromTo => textBetween(fromTo, samples[0]),
                take(3, delims)
            ), zipWith(
                textBetween,
                drop(3, delims),
                tailDef(samples)
            )
        )
    );
})();
