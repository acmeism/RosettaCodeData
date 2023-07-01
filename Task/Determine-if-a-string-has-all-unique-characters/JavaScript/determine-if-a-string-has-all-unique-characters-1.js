(() => {
    'use strict';

    // duplicatedCharIndices :: String -> Maybe (Char, [Int])
    const duplicatedCharIndices = s => {
        const
            duplicates = filter(g => 1 < g.length)(
                groupBy(on(eq)(snd))(
                    sortOn(snd)(
                        zip(enumFrom(0))(chars(s))
                    )
                )
            );
        return 0 < duplicates.length ? Just(
            fanArrow(compose(snd, fst))(map(fst))(
                sortOn(compose(fst, fst))(
                    duplicates
                )[0]
            )
        ) : Nothing();
    };

    // ------------------------TEST------------------------
    const main = () =>
        console.log(
            fTable('First duplicated character, if any:')(
                s => `'${s}' (${s.length})`
            )(maybe('None')(tpl => {
                const [c, ixs] = Array.from(tpl);
                return `'${c}' (0x${showHex(ord(c))}) at ${ixs.join(', ')}`
            }))(duplicatedCharIndices)([
                "", ".", "abcABC", "XYZ ZYX",
                "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"
            ])
        );


    // -----------------GENERIC FUNCTIONS------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a => b => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // chars :: String -> [Char]
    const chars = s => s.split('');

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);

    // enumFrom :: Enum a => a -> [a]
    function* enumFrom(x) {
        let v = x;
        while (true) {
            yield v;
            v = 1 + v;
        }
    }

    // eq (==) :: Eq a => a -> a -> Bool
    const eq = a => b => a === b;

    // fanArrow (&&&) :: (a -> b) -> (a -> c) -> (a -> (b, c))
    const fanArrow = f =>
        // Compose a function from a simple value to a tuple of
        // the separate outputs of two different functions.
        g => x => Tuple(f(x))(g(x));

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = f => xs => xs.filter(f);

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // fTable :: String -> (a -> String) -> (b -> String)
    //                      -> (a -> b) -> [a] -> String
    const fTable = s => xShow => fxShow => f => xs => {
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        const
            ys = xs.map(xShow),
            w = Math.max(...ys.map(length));
        return s + '\n' + zipWith(
            a => b => a.padStart(w, ' ') + ' -> ' + b
        )(ys)(
            xs.map(x => fxShow(f(x)))
        ).join('\n');
    };

    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = fEq =>
        // Typical usage: groupBy(on(eq)(f), xs)
        xs => 0 < xs.length ? (() => {
            const
                tpl = xs.slice(1).reduce(
                    (gw, x) => {
                        const
                            gps = gw[0],
                            wkg = gw[1];
                        return fEq(wkg[0])(x) ? (
                            Tuple(gps)(wkg.concat([x]))
                        ) : Tuple(gps.concat([wkg]))([x]);
                    },
                    Tuple([])([xs[0]])
                );
            return tpl[0].concat([tpl[1]])
        })() : [];

    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite length.
        // This enables zip and zipWith to choose the shorter
        // argument when one is non-finite, like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // maybe :: b -> (a -> b) -> Maybe a -> b
    const maybe = v =>
        // Default value (v) if m is Nothing, or f(m.Just)
        f => m => m.Nothing ? v : f(m.Just);

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = f =>
        g => a => b => f(g(a))(g(b));

    // ord :: Char -> Int
    const ord = c => c.codePointAt(0);

    // showHex :: Int -> String
    const showHex = n =>
        n.toString(16);

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // sortOn :: Ord b => (a -> b) -> [a] -> [a]
    const sortOn = f =>
        // Equivalent to sortBy(comparing(f)), but with f(x)
        // evaluated only once for each x in xs.
        // ('Schwartzian' decorate-sort-undecorate).
        xs => xs.map(
            x => [f(x), x]
        ).sort(
            (a, b) => a[0] < b[0] ? -1 : (a[0] > b[0] ? 1 : 0)
        ).map(x => x[1]);

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n => xs =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        (x, y) => f(x)(y)

    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs => ys => {
        const
            lng = Math.min(length(xs), length(ys)),
            vs = take(lng)(ys);
        return take(lng)(xs)
            .map((x, i) => Tuple(x)(vs[i]));
    };

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        xs => ys => {
            const
                lng = Math.min(length(xs), length(ys)),
                vs = take(lng)(ys);
            return take(lng)(xs)
                .map((x, i) => f(x)(vs[i]));
        };

    // MAIN ---
    return main();
})();
