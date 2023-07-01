(() => {
    'use strict';

    // ---------- FIRST INCONSISTENT CHARACTER -----------

    // inconsistentChar :: String -> Maybe (Char, Int)
    const inconsistentChar = s =>
        // Just the first inconsistent character in a
        // string, paired with the index of its position,
        // or Nothing if all of the characters in a string
        // are the same.
        2 > s.length ? (
            Nothing()
        ) : (() => {
            const [h, ...t] = s;
            const i = t.findIndex(c => h !== c);
            return -1 !== i ? (
                Just([t[i], 1 + i])
            ) : Nothing();
        })();


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        fTable(
            'First inconsistent character:\n'
        )(
            s => `${quoted("'")(s)} (${[...s].length} chars)`
        )(
            maybe('None')(pair => {
                const c = pair[0];
                return `${quoted("'")(c)} at index ` + (
                    `${pair[1]} (${showHex(ord(c))})`
                );
            })
        )(
            inconsistentChar
        )([
            '', '   ', '2', '333', '.55',
            'tttTTT', '4444 444k',
            '🐶🐶🐺🐶', '🎄🎄🎄🎄'
        ]);


    // ----------- REUSABLE GENERIC FUNCTIONS ------------

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


    // fTable :: String -> (a -> String) ->
    // (b -> String) -> (a -> b) -> [a] -> String
    const fTable = s =>
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        xShow => fxShow => f => xs => {
            const
                ys = xs.map(xShow),
                w = Math.max(...ys.map(length));
            return s + '\n' + zipWith(
                a => b => a.padStart(w, ' ') + ' -> ' + b
            )(ys)(
                xs.map(x => fxShow(f(x)))
            ).join('\n');
        };


    // maybe :: b -> (a -> b) -> Maybe a -> b
    const maybe = v =>
        // Default value (v) if m is Nothing, or f(m.Just)
        f => m => m.Nothing ? (
            v
        ) : f(m.Just);


    // showHex :: Int -> String
    const showHex = n =>
        // Hexadecimal string for a given integer.
        '0x' + n.toString(16);


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        'GeneratorFunction' !== xs.constructor
        .constructor.name ? (
            xs.length
        ) : Infinity;


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // ord :: Char -> Int
    const ord = c =>
        // Unicode ordinal value of the character.
        c.codePointAt(0);


    // quoted :: Char -> String -> String
    const quoted = c =>
        // A string flanked on both sides
        // by a specified quote character.
        s => c + s + c;


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => 'GeneratorFunction' !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A map of f over each stepwise pair in
        // xs and ys, up to the length of the shorter
        // of those lists.
        xs => ys => {
            const
                n = Math.min(length(xs), length(ys)),
                vs = take(n)(list(ys));
            return take(n)(list(xs))
                .map((x, i) => f(x)(vs[i]));
        };

    // MAIN ---
    return main()
})();
