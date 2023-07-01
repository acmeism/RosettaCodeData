(() => {
    'use strict';

    // duplicatedCharIndices :: String -> Maybe (Char, [Int])
    const duplicatedCharIndices = s =>
        minimumByMay(
            comparing(compose(fst, snd))
        )(filter(x => 1 < x[1].length)(
            Object.entries(
                s.split('').reduce(
                    (a, c, i) => Object.assign(a, {
                        [c]: (a[c] || []).concat(i)
                    }), {}
                )
            )
        ));

    // ------------------------TEST------------------------
    const main = () =>
        console.log(
            fTable('First duplicated character, if any:')(
                s => `'${s}' (${s.length    })`
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

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        x => y => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

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

    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite length.
        // This enables zip and zipWith to choose the shorter
        // argument when one is non-finite, like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // maybe :: b -> (a -> b) -> Maybe a -> b
    const maybe = v =>
        // Default value (v) if m is Nothing, or f(m.Just)
        f => m => m.Nothing ? v : f(m.Just);

    // minimumByMay :: (a -> a -> Ordering) -> [a] -> Maybe a
    const minimumByMay = f =>
        xs => xs.reduce((a, x) =>
            a.Nothing ? Just(x) : (
                f(x)(a.Just) < 0 ? Just(x) : a
            ), Nothing());

    // ord :: Char -> Int
    const ord = c => c.codePointAt(0);

    // showHex :: Int -> String
    const showHex = n =>
        n.toString(16);

    // snd :: (a, b) -> b
    const snd = tpl =>
        tpl[1];

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        xs => 'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

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
