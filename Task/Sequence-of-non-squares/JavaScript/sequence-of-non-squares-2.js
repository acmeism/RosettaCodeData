(() => {
    'use strict';

    // ------------------ OEIS A000037 -------------------

    // nonSquare :: Int -> Int
    const nonSquare = n =>
        // Nth term in the OEIS A000037 series.
        n + Math.floor(1 / 2 + Math.sqrt(n));


    // isPerfectSquare :: Int -> Bool
    const isPerfectSquare = n => {
        const root = Math.sqrt(n);
        return root === Math.floor(root);
    };

    // ---------------------- TEST -----------------------
    const main = () =>
        // First 22 terms, and test of first million.
        [
            Tuple('First 22 terms:')(
                take(22)(
                    fmapGen(nonSquare)(
                        enumFrom(1)
                    )
                )
            ),
            Tuple(
                'Any perfect squares in 1st 1E6 terms ?'
            )(
                Array.from({
                    length: 1E6
                })
                .map(nonSquare)
                .some(isPerfectSquare)
            )
        ]
        .map(kv => `${fst(kv)} -> ${snd(kv)}`)
        .join('\n\n');


    // --------------------- GENERAL ---------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });

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

    // fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
    const fmapGen = f =>
        function* (gen) {
            let v = take(1)(gen);
            while (0 < v.length) {
                yield(f(v[0]));
                v = take(1)(gen);
            }
        };

    // fst :: (a, b) -> a
    const fst = tpl =>
        // First member of a pair.
        tpl[0];


    // snd :: (a, b) -> b
    const snd = tpl =>
        // Second member of a pair.
        tpl[1];


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

    return main()
})();
