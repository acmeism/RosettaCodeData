(() => {
    'use strict';

    // yellowstone :: Generator [Int]
    function* yellowstone() {
        // A non finite stream of terms in the
        // Yellowstone permutation of the natural numbers.
        // OEIS A098550
        const nextWindow = ([p2, p1, rest]) => {
            const [rp2, rp1] = [p2, p1].map(
                relativelyPrime
            );
            const go = xxs => {
                const [x, xs] = Array.from(
                    uncons(xxs).Just
                );
                return rp1(x) && !rp2(x) ? (
                    Tuple(x)(xs)
                ) : secondArrow(cons(x))(
                    go(xs)
                );
            };
            return [p1, ...Array.from(go(rest))];
        };
        const A098550 = fmapGen(x => x[1])(
            iterate(nextWindow)(
                [2, 3, enumFrom(4)]
            )
        );
        yield 1
        yield 2
        while (true)(
            yield A098550.next().value
        )
    };


    // relativelyPrime :: Int -> Int -> Bool
    const relativelyPrime = a =>
        // True if a is relatively prime to b.
        b => 1 === gcd(a)(b);


    // ------------------------TEST------------------------
    const main = () => console.log(
        take(30)(
            yellowstone()
        )
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
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });

    // abs :: Num -> Num
    const abs =
        // Absolute value of a given number - without the sign.
        Math.abs;

    // cons :: a -> [a] -> [a]
    const cons = x =>
        xs => Array.isArray(xs) ? (
            [x].concat(xs)
        ) : 'GeneratorFunction' !== xs
        .constructor.constructor.name ? (
            x + xs
        ) : ( // cons(x)(Generator)
            function*() {
                yield x;
                let nxt = xs.next()
                while (!nxt.done) {
                    yield nxt.value;
                    nxt = xs.next();
                }
            }
        )();

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
        function*(gen) {
            let v = take(1)(gen);
            while (0 < v.length) {
                yield(f(v[0]))
                v = take(1)(gen)
            }
        };

    // gcd :: Int -> Int -> Int
    const gcd = x => y => {
        const
            _gcd = (a, b) => (0 === b ? a : _gcd(b, a % b)),
            abs = Math.abs;
        return _gcd(abs(x), abs(y));
    };

    // iterate :: (a -> a) -> a -> Gen [a]
    const iterate = f =>
        function*(x) {
            let v = x;
            while (true) {
                yield(v);
                v = f(v);
            }
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

    // secondArrow :: (a -> b) -> ((c, a) -> (c, b))
    const secondArrow = f => xy =>
        // A function over a simple value lifted
        // to a function over a tuple.
        // f (a, b) -> (a, f(b))
        Tuple(xy[0])(
            f(xy[1])
        );

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

    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => {
        // Just a tuple of the head of xs and its tail,
        // Or Nothing if xs is an empty list.
        const lng = length(xs);
        return (0 < lng) ? (
            Infinity > lng ? (
                Just(Tuple(xs[0])(xs.slice(1))) // Finite list
            ) : (() => {
                const nxt = take(1)(xs);
                return 0 < nxt.length ? (
                    Just(Tuple(nxt[0])(xs))
                ) : Nothing();
            })() // Lazy generator
        ) : Nothing();
    };

    // MAIN ---
    return main();
})();
