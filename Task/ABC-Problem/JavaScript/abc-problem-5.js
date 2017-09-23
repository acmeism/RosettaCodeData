(() => {
    'use strict';

    // ABC BLOCKS -------------------------------------------------------------

    // spellWith :: [(Char, Char)] -> [Char] -> [[(Char, Char)]]
    const spellWith = (blocks, wordChars) =>
        (isNull(wordChars)) ? [
            []
        ] :
        (() => {
            const [x, xs] = uncons(wordChars);
            return concatMap(
                b => elem(x, b) ? concatMap(
                    bs => [cons(b, bs)],
                    spellWith(
                        deleteBy(
                            (p, q) => (p[0] === q[0]) && (p[1] === q[1]),
                            b, blocks
                        ),
                        xs
                    )
                ) : [],
                blocks
            );
        })();

    // GENERIC FUNCTIONS ------------------------------------------------------

    // compose :: [(a -> a)] -> (a -> a)
    const compose = fs => x => fs.reduceRight((a, f) => f(a), x);

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat([].slice.apply(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
    const deleteBy = (f, x, xs) =>
        xs.length > 0 ? (
            f(x, xs[0]) ? (
                xs.slice(1)
            ) : [xs[0]].concat(deleteBy(f, x, xs.slice(1)))
        ) : [];

    // elem :: Eq a => a -> [a] -> Bool
    const elem = (x, xs) => xs.indexOf(x) !== -1;

    // isNull :: [a] -> Bool
    const isNull = xs => (xs instanceof Array) ? xs.length < 1 : undefined;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // not :: Bool -> Bool
    const not = b => !b;

    // show :: a -> String
    const show = x => JSON.stringify(x); //, null, 2);

    // stringChars :: String -> [Char]
    const stringChars = s => s.split('');

    // toUpper :: Text -> Text
    const toUpper = s => s.toUpperCase();

    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => xs.length ? [xs[0], xs.slice(1)] : undefined;

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // words :: String -> [String]
    const words = s => s.split(/\s+/);

    // TEST -------------------------------------------------------------------
    // blocks :: [(Char, Char)]
    const blocks = words(
        "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM"
    );

    return unlines(map(
        x => show([x, compose(
            [not, isNull, curry(spellWith)(blocks), stringChars, toUpper]
        )(x)]), ["", "A", "BARK", "BoOK", "TrEAT", "COmMoN", "SQUAD", "conFUsE"]
    ));
})();
