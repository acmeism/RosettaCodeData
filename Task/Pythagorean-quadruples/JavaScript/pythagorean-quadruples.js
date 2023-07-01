(() => {
    'use strict';

    // main :: IO ()
    const main = () => {
        const xs = takeWhileGen(
            x => 2200 >= x,
            mergeInOrder(
                powersOfTwo(),
                fmapGen(x => 5 * x, powersOfTwo())
            )
        );

        return (
            console.log(JSON.stringify(xs)),
            xs
        );
    }

    // powersOfTwo :: Gen [Int]
    const powersOfTwo = () =>
        iterate(x => 2 * x, 1);

    // mergeInOrder :: Gen [Int] -> Gen [Int] -> Gen [Int]
    const mergeInOrder = (ga, gb) => {
        function* go(ma, mb) {
            let
                a = ma,
                b = mb;
            while (!a.Nothing && !b.Nothing) {
                let
                    ta = a.Just,
                    tb = b.Just;
                if (fst(ta) < fst(tb)) {
                    yield(fst(ta));
                    a = uncons(snd(ta))
                } else {
                    yield(fst(tb));
                    b = uncons(snd(tb))
                }
            }
        }
        return go(uncons(ga), uncons(gb))
    };


    // GENERIC FUNCTIONS ----------------------------

    // fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
    function* fmapGen(f, gen) {
        const g = gen;
        let v = take(1, g);
        while (0 < v.length) {
            yield(f(v))
            v = take(1, g)
        }
    }

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // iterate :: (a -> a) -> a -> Generator [a]
    function* iterate(f, x) {
        let v = x;
        while (true) {
            yield(v);
            v = f(v);
        }
    }

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Returns Infinity over objects without finite length
    // this enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs => xs.length || Infinity;

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        xs.constructor.constructor.name !== 'GeneratorFunction' ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // takeWhileGen :: (a -> Bool) -> Generator [a] -> [a]
    const takeWhileGen = (p, xs) => {
        const ys = [];
        let
            nxt = xs.next(),
            v = nxt.value;
        while (!nxt.done && p(v)) {
            ys.push(v);
            nxt = xs.next();
            v = nxt.value
        }
        return ys;
    };

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

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

    // MAIN ---
    return main();
})();
