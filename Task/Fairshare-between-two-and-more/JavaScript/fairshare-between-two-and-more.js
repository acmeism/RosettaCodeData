(() => {
    'use strict';

    // thueMorse :: Int -> [Int]
    const thueMorse = base =>
        // Thue-Morse sequence for a given base
        fmapGen(baseDigitsSumModBase(base))(
            enumFrom(0)
        )

    // baseDigitsSumModBase :: Int -> Int -> Int
    const baseDigitsSumModBase = base =>
        // For any integer n, the sum of its digits
        // in a given base, modulo that base.
        n => sum(unfoldl(
            x => 0 < x ? (
                Just(quotRem(x)(base))
            ) : Nothing()
        )(n)) % base


    // ------------------------TEST------------------------
    const main = () =>
        console.log(
            fTable(
                'First 25 fairshare terms for a given number of players:'
            )(str)(
                xs => '[' + map(
                    compose(justifyRight(2)(' '), str)
                )(xs) + ' ]'
            )(
                compose(take(25), thueMorse)
            )([2, 3, 5, 11])
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

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);

    // enumFrom :: Enum a => a -> [a]
    function* enumFrom(x) {
        // A non-finite succession of enumerable
        // values, starting with the value x.
        let v = x;
        while (true) {
            yield v;
            v = 1 + v;
        }
    }

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

    // fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
    const fmapGen = f =>
        function*(gen) {
            let v = take(1)(gen);
            while (0 < v.length) {
                yield(f(v[0]))
                v = take(1)(gen)
            }
        };

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padStart(n, c)
        ) : s;

    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f to each element of xs.
        // (The image of xs under f).
        xs => (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // quotRem :: Int -> Int -> (Int, Int)
    const quotRem = m => n =>
        Tuple(Math.floor(m / n))(
            m % n
        );

    // str :: a -> String
    const str = x => x.toString();

    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);

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


    // unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
    const unfoldl = f => v => {
        // Dual to reduce or foldl.
        // Where these reduce a list to a summary value, unfoldl
        // builds a list from a seed value.
        // Where f returns Just(a, b), a is appended to the list,
        // and the residual b is used as the argument for the next
        // application of f.
        // Where f returns Nothing, the completed list is returned.
        let
            xr = [v, v],
            xs = [];
        while (true) {
            const mb = f(xr[0]);
            if (mb.Nothing) {
                return xs
            } else {
                xr = mb.Just;
                xs = [xr[1]].concat(xs);
            }
        }
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
