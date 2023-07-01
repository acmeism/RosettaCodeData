(() => {
    'use strict';

    // a005179 :: () -> [Int]
    const a005179 = () =>
        fmapGen(
            n => find(
                compose(
                    eq(n),
                    succ,
                    length,
                    properDivisors
                )
            )(enumFrom(1)).Just
        )(enumFrom(1));


    // ------------------------TEST------------------------
    // main :: IO ()
    const main = () =>
        console.log(
            take(15)(
                a005179()
            )
        );

    // [1,2,4,6,16,12,64,24,36,48,1024,60,4096,192,144]


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
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );

    // enumFrom :: Enum a => a -> [a]
    function* enumFrom(x) {
        // A non-finite succession of enumerable
        // values, starting with the value x.
        let v = x;
        while (true) {
            yield v;
            v = succ(v);
        }
    };

    // eq (==) :: Eq a => a -> a -> Bool
    const eq = a =>
        // True when a and b are equivalent in the terms
        // defined below for their shared data type.
        b => a === b;

    // find :: (a -> Bool) -> Gen [a] -> Maybe a
    const find = p => xs => {
        const mb = until(tpl => {
            const nxt = tpl[0];
            return nxt.done || p(nxt.value);
        })(
            tpl => Tuple(tpl[1].next())(
                tpl[1]
            )
        )(Tuple(xs.next())(xs))[0];
        return mb.done ? (
            Nothing()
        ) : Just(mb.value);
    }

    // fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
    const fmapGen = f =>
        function*(gen) {
            let v = take(1)(gen);
            while (0 < v.length) {
                yield(f(v[0]))
                v = take(1)(gen)
            }
        };

    // group :: [a] -> [[a]]
    const group = xs => {
        // A list of lists, each containing only equal elements,
        // such that the concatenation of these lists is xs.
        const go = xs =>
            0 < xs.length ? (() => {
                const
                    h = xs[0],
                    i = xs.findIndex(x => h !== x);
                return i !== -1 ? (
                    [xs.slice(0, i)].concat(go(xs.slice(i)))
                ) : [xs];
            })() : [];
        return go(xs);
    };

    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // liftA2List :: (a -> b -> c) -> [a] -> [b] -> [c]
    const liftA2List = f => xs => ys =>
        // The binary operator f lifted to a function over two
        // lists. f applied to each pair of arguments in the
        // cartesian product of xs and ys.
        xs.flatMap(
            x => ys.map(f(x))
        );

    // mul (*) :: Num a => a -> a -> a
    const mul = a => b => a * b;

    // properDivisors :: Int -> [Int]
    const properDivisors = n =>
        // The ordered divisors of n,
        // excluding n itself.
        1 < n ? (
            sort(group(primeFactors(n)).reduce(
                (a, g) => liftA2List(mul)(a)(
                    scanl(mul)([1])(g)
                ),
                [1]
            )).slice(0, -1)
        ) : [];

    // primeFactors :: Int -> [Int]
    const primeFactors = n => {
        // A list of the prime factors of n.
        const
            go = x => {
                const
                    root = Math.floor(Math.sqrt(x)),
                    m = until(
                        ([q, _]) => (root < q) || (0 === (x % q))
                    )(
                        ([_, r]) => [step(r), 1 + r]
                    )(
                        [0 === x % 2 ? 2 : 3, 1]
                    )[0];
                return m > root ? (
                    [x]
                ) : ([m].concat(go(Math.floor(x / m))));
            },
            step = x => 1 + (x << 2) - ((x >> 1) << 1);
        return go(n);
    };

    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = f => startValue => xs =>
        xs.reduce((a, x) => {
            const v = f(a[0])(x);
            return Tuple(v)(a[1].concat(v));
        }, Tuple(startValue)([startValue]))[1];

    // sort :: Ord a => [a] -> [a]
    const sort = xs => xs.slice()
        .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));

    // succ :: Enum a => a -> a
    const succ = x =>
        1 + x;

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

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p => f => x => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return main();
})();
