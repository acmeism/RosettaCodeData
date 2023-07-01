(() => {
    'use strict';

    // levenshtein :: String -> String -> Int
    const levenshtein = sa => sb => {
        const cs = chars(sa);
        const go = (ns, c) => {
            const calc = z => tpl => {
                const [c1, x, y] = Array.from(tpl);
                return minimum([
                    succ(y),
                    succ(z),
                    x + (c !== c1 ? 1 : 0)
                ]);
            };
            const [n, ns1] = [ns[0], ns.slice(1)];
            return scanl(calc)(succ(n))(
                zip3(cs)(ns)(ns1)
            );
        };
        return last(
            chars(sb).reduce(
                go,
                enumFromTo(0)(cs.length)
            )
        );
    };

    // ----------------------- TEST ------------------------
    const main = () => [
        ["kitten", "sitting"],
        ["sitting", "kitten"],
        ["rosettacode", "raisethysword"],
        ["raisethysword", "rosettacode"]
    ].map(uncurry(levenshtein));


    // ----------------- GENERIC FUNCTIONS -----------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });


    // TupleN :: a -> b ...  -> (a, b ... )
    function TupleN() {
        const
            args = Array.from(arguments),
            n = args.length;
        return 2 < n ? Object.assign(
            args.reduce((a, x, i) => Object.assign(a, {
                [i]: x
            }), {
                type: 'Tuple' + n.toString(),
                length: n
            })
        ) : args.reduce((f, x) => f(x), Tuple);
    };


    // chars :: String -> [Char]
    const chars = s =>
        s.split('');


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // last :: [a] -> a
    const last = xs => (
        // The last item of a list.
        ys => 0 < ys.length ? (
            ys.slice(-1)[0]
        ) : undefined
    )(xs);


    // minimum :: Ord a => [a] -> a
    const minimum = xs => (
        // The least value of xs.
        ys => 0 < ys.length ? (
            ys.slice(1)
            .reduce((a, y) => y < a ? y : a, ys[0])
        ) : undefined
    )(xs);


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.length
        ) : Infinity;


    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    const scanl = f => startValue => xs =>
        xs.reduce((a, x) => {
            const v = f(a[0])(x);
            return Tuple(v)(a[1].concat(v));
        }, Tuple(startValue)([startValue]))[1];


    // succ :: Enum a => a -> a
    const succ = x =>
        1 + x;


    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        // A function over a pair, derived
        // from a curried function.
        function () {
            const
                args = arguments,
                xy = Boolean(args.length % 2) ? (
                    args[0]
                ) : args;
            return f(xy[0])(xy[1]);
        };


    // zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
    const zip3 = xs =>
        ys => zs => xs
        .slice(0, Math.min(...[xs, ys, zs].map(length)))
        .map((x, i) => TupleN(x, ys[i], zs[i]));

    // MAIN ---
    return JSON.stringify(main())
})();
