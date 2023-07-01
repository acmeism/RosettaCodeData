(() => {
    'use strict';

    // main :: IO()
    const main = () => {

        // powers :: Gen [Int]
        const powers = n =>
            fmapGen(
                x => Math.pow(x, n),
                enumFrom(0)
            );

        // xs :: [Int]
        const xs = take(10, drop(20,
            differenceGen(
                powers(2),
                powers(3)
            )
        ));

        console.log(xs);
        // -> [529,576,625,676,784,841,900,961,1024,1089]
    };


    // GENERIC FUNCTIONS ----------------------------------

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
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // differenceGen :: Gen [a] -> Gen [a] -> Gen [a]
    function* differenceGen(ga, gb) {
        // All values of generator stream a except any
        // already seen in generator stream b.
        const
            stream = zipGen(ga, gb),
            sb = new Set([]);
        let xy = take(1, stream);
        while (0 < xy.length) {
            const [x, y] = Array.from(xy[0]);
            sb.add(y);
            if (!sb.has(x)) yield x;
            xy = take(1, stream);
        }
    };

    // drop :: Int -> [a] -> [a]
    // drop :: Int -> Generator [a] -> Generator [a]
    // drop :: Int -> String -> String
    const drop = (n, xs) =>
        Infinity > length(xs) ? (
            xs.slice(n)
        ) : (take(n, xs), xs);

    // enumFrom :: Enum a => a -> [a]
    function* enumFrom(x) {
        let v = x;
        while (true) {
            yield v;
            v = 1 + v;
        }
    }

    // fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
    function* fmapGen(f, gen) {
        let v = take(1, gen);
        while (0 < v.length) {
            yield(f(v[0]))
            v = take(1, gen)
        }
    }

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => {
        const lng = length(xs);
        return (0 < lng) ? (
            lng < Infinity ? (
                Just(Tuple(xs[0], xs.slice(1))) // Finite list
            ) : (() => {
                const nxt = take(1, xs);
                return 0 < nxt.length ? (
                    Just(Tuple(nxt[0], xs))
                ) : Nothing();
            })() // Lazy generator
        ) : Nothing();
    };

    // zipGen :: Gen [a] -> Gen [b] -> Gen [(a, b)]
    const zipGen = (ga, gb) => {
        function* go(ma, mb) {
            let
                a = ma,
                b = mb;
            while (!a.Nothing && !b.Nothing) {
                let
                    ta = a.Just,
                    tb = b.Just
                yield(Tuple(fst(ta), fst(tb)));
                a = uncons(snd(ta));
                b = uncons(snd(tb));
            }
        }
        return go(uncons(ga), uncons(gb));
    };

    // MAIN ---
    return main();
})();
