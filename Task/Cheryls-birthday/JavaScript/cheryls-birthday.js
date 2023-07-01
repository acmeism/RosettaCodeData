(() => {
    'use strict';

    // main :: IO ()
    const main = () => {
        const
            month = fst,
            day = snd;
        showLog(
            map(x => Array.from(x), (

                // The month with only one remaining day,

                // (A's month contains only one remaining day)
                // (3 :: A "Then I also know")
                uniquePairing(month)(

                    // among the days with unique months,

                    // (B's day is paired with only one remaining month)
                    // (2 :: B "I know now")
                    uniquePairing(day)(

                        // excluding months with unique days,

                        // (A's month is not among those with unique days)
                        // (1 :: A "I know that Bernard does not know")
                        monthsWithUniqueDays(false)(

                            // from the given month-day pairs:

                            // (0 :: Cheryl's list)
                            map(x => tupleFromList(words(strip(x))),
                                splitOn(/,\s+/,
                                    `May 15, May 16, May 19,
                                        June 17, June 18, July 14, July 16,
                                        Aug 14, Aug 15, Aug 17`
                                )
                            )
                        )
                    )
                )
            ))
        );
    };

    // monthsWithUniqueDays :: Bool -> [(Month, Day)] -> [(Month, Day)]
    const monthsWithUniqueDays = blnInclude => xs => {
        const months = map(fst, uniquePairing(snd)(xs));
        return filter(
            md => (blnInclude ? id : not)(
                elem(fst(md), months)
            ),
            xs
        );
    };

    // uniquePairing :: ((a, a) -> a) ->
    //      -> [(Month, Day)] -> [(Month, Day)]
    const uniquePairing = f => xs =>
        bindPairs(xs,
            md => {
                const
                    dct = f(md),
                    matches = filter(
                        k => 1 === length(dct[k]),
                        Object.keys(dct)
                    );
                return filter(tpl => elem(f(tpl), matches), xs);
            }
        );

    // bindPairs :: [(Month, Day)] -> (Dict, Dict) -> [(Month, Day)]
    const bindPairs = (xs, f) => f(
        Tuple(
            dictFromPairs(fst)(snd)(xs),
            dictFromPairs(snd)(fst)(xs)
        )
    );

    // dictFromPairs :: ((a, a) -> a) -> ((a, a) -> a) -> [(a, a)] -> Dict
    const dictFromPairs = f => g => xs =>
        foldl((a, tpl) => Object.assign(
            a, {
                [f(tpl)]: (a[f(tpl)] || []).concat(g(tpl).toString())
            }
        ), {}, xs);


    // GENERIC ABSTRACTIONS -------------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // elem :: Eq a => a -> [a] -> Bool
    const elem = (x, xs) => xs.includes(x);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // foldl :: (a -> b -> a) -> a -> [b] -> a
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // id :: a -> a
    const id = x => x;

    // intersect :: (Eq a) => [a] -> [a] -> [a]
    const intersect = (xs, ys) =>
        xs.filter(x => -1 !== ys.indexOf(x));

    // Returns Infinity over objects without finite length
    // this enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // not :: Bool -> Bool
    const not = b => !b;

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // splitOn :: String -> String -> [String]
    const splitOn = (pat, src) =>
        src.split(pat);

    // strip :: String -> String
    const strip = s => s.trim();

    // tupleFromList :: [a] -> (a, a ...)
    const tupleFromList = xs =>
        TupleN.apply(null, xs);

    // TupleN :: a -> b ...  -> (a, b ... )
    function TupleN() {
        const
            args = Array.from(arguments),
            lng = args.length;
        return lng > 1 ? Object.assign(
            args.reduce((a, x, i) => Object.assign(a, {
                [i]: x
            }), {
                type: 'Tuple' + (2 < lng ? lng.toString() : ''),
                length: lng
            })
        ) : args[0];
    };

    // words :: String -> [String]
    const words = s => s.split(/\s+/);

    // MAIN ---
    return main();
})();
