(() => {
    'use strict';

    const main = () => {

        const
            iFrom = 1,
            iTo = 249,
            xs = enumFromTo(1, 249),
            p5 = x => Math.pow(x, 5);

        const
            // powerMap :: Dict Int Int
            powerMap = mapFromList(
                zip(map(p5, xs), xs)
            ),
            // sumMap :: Dict Int (Int, Int)
            sumMap = mapFromList(
                bind(
                    xs,
                    x => bind(
                        tail(xs),
                        y => Tuple(
                            p5(x) + p5(y),
                            Tuple(x, y)
                        )
                    )
                )
            );

        // mbExample :: Maybe (Int, Int)
        const mbExample = find(
            tpl => member(fst(tpl) - snd(tpl), sumMap),
            bind(
                map(x => parseInt(x, 10),
                    keys(powerMap)
                ),
                p => bind(
                    takeWhile(
                        x => x < p,
                        map(x => parseInt(x, 10),
                            keys(sumMap)
                        )
                    ),
                    s => [Tuple(p, s)]
                )
            )
        );

        // showExample :: (Int, Int) -> String
        const showExample = tpl => {
            const [p, s] = Array.from(tpl);
            const [a, b] = Array.from(sumMap[p - s]);
            const [c, d] = Array.from(sumMap[s]);
            return 'Counter-example found:\n' + intercalate(
                '^5 + ',
                map(str, [a, b, c, d])
            ) + '^5 = ' + str(powerMap[p]) + '^5';
        };

        return maybe(
            'No counter-example found',
            showExample,
            mbExample
        );
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

    // bind (>>=) :: [a] -> (a -> [b]) -> [b]
    const bind = (xs, mf) => [].concat.apply([], xs.map(mf));

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];


    // enumFromTo :: (Int, Int) -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // find :: (a -> Bool) -> [a] -> Maybe a
    const find = (p, xs) => {
        for (let i = 0, lng = xs.length; i < lng; i++) {
            if (p(xs[i])) return Just(xs[i]);
        }
        return Nothing();
    };

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // intercalate :: [a] -> [[a]] -> [a]
    // intercalate :: String -> [String] -> String
    const intercalate = (sep, xs) =>
        0 < xs.length && 'string' === typeof sep &&
        'string' === typeof xs[0] ? (
            xs.join(sep)
        ) : concat(intersperse(sep, xs));

    // intersperse(0, [1,2,3]) -> [1, 0, 2, 0, 3]

    // intersperse :: a -> [a] -> [a]
    // intersperse :: Char -> String -> String
    const intersperse = (sep, xs) => {
        const bln = 'string' === typeof xs;
        return xs.length > 1 ? (
            (bln ? concat : x => x)(
                (bln ? (
                    xs.split('')
                ) : xs)
                .slice(1)
                .reduce((a, x) => a.concat([sep, x]), [xs[0]])
            )) : xs;
    };

    // keys :: Dict -> [String]
    const keys = Object.keys;

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // mapFromList :: [(k, v)] -> Dict
    const mapFromList = kvs =>
        kvs.reduce(
            (a, kv) => {
                const k = kv[0];
                return Object.assign(a, {
                    [
                        (('string' === typeof k) && k) || JSON.stringify(k)
                    ]: kv[1]
                });
            }, {}
        );

    // Default value (v) if m.Nothing, or f(m.Just)

    // maybe :: b -> (a -> b) -> Maybe a -> b
    const maybe = (v, f, m) =>
        m.Nothing ? v : f(m.Just);

    // member :: Key -> Dict -> Bool
    const member = (k, dct) => k in dct;

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // str :: a -> String
    const str = x => x.toString();

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

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

    // takeWhile :: (a -> Bool) -> [a] -> [a]
    // takeWhile :: (Char -> Bool) -> String -> String
    const takeWhile = (p, xs) =>
        xs.constructor.constructor.name !==
        'GeneratorFunction' ? (() => {
            const lng = xs.length;
            return 0 < lng ? xs.slice(
                0,
                until(
                    i => lng === i || !p(xs[i]),
                    i => 1 + i,
                    0
                )
            ) : [];
        })() : takeWhileGen(p, xs);


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // Use of `take` and `length` here allows for zipping with non-finite
    // lists - i.e. generators like cycle, repeat, iterate.

    // zip :: [a] -> [b] -> [(a, b)]
    const zip = (xs, ys) => {
        const lng = Math.min(length(xs), length(ys));
        return Infinity !== lng ? (() => {
            const bs = take(lng, ys);
            return take(lng, xs).map((x, i) => Tuple(x, bs[i]));
        })() : zipGen(xs, ys);
    };

    // MAIN ---
    return main();
})();
