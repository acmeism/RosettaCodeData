(() => {
    'use strict';

    const main = () =>
        unlines(
            map(n => concat(zeckendorf(n)),
                enumFromTo(0, 20)
            )
        );

    // zeckendorf :: Int -> String
    const zeckendorf = n => {
        const go = (n, x) =>
            n < x ? (
                Tuple(n, '0')
            ) : Tuple(n - x, '1')
        return 0 < n ? (
            snd(mapAccumL(
                go, n,
                reverse(fibUntil(n))
            ))
        ) : ['0'];
    };

    // fibUntil :: Int -> [Int]
    const fibUntil = n =>
        cons(1, takeWhile(x => n >= x,
            map(snd, iterateUntil(
                tpl => n <= fst(tpl),
                tpl => {
                    const x = snd(tpl);
                    return Tuple(x, x + fst(tpl));
                },
                Tuple(1, 2)
            ))));

    // GENERIC FUNCTIONS ----------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) =>
        Array.isArray(xs) ? (
            [x].concat(xs)
        ) : (x + xs);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        m <= n ? iterateUntil(
            x => n <= x,
            x => 1 + x,
            m
        ) : [];

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        const vs = [x];
        let h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // 'The mapAccumL function behaves like a combination of map and foldl;
    // it applies a function to each element of a list, passing an accumulating
    // parameter from left to right, and returning a final value of this
    // accumulator together with the new list.' (See Hoogle)

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    const mapAccumL = (f, acc, xs) =>
        xs.reduce((a, x, i) => {
            const pair = f(a[0], x, i);
            return Tuple(pair[0], a[1].concat(pair[1]));
        }, Tuple(acc, []));

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

    // takeWhile :: (a -> Bool) -> [a] -> [a]
    // takeWhile :: (Char -> Bool) -> String -> String
    const takeWhile = (p, xs) => {
        const lng = xs.length;
        return 0 < lng ? xs.slice(
            0,
            until(
                i => i === lng || !p(xs[i]),
                i => 1 + i,
                0
            )
        ) : [];
    };

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return main();
})();
