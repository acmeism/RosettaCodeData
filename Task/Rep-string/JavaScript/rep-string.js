(() => {
    'use strict';

    // REP-CYCLES -------------------------------------------------------------

    // repCycles :: String -> [String]
    const repCycles = xs => {
        const n = xs.length;
        return filter(
            cs => xs === takeCycle(n, cs),
            map(concat, tail(inits(take(quot(n, 2), xs))))
        );
    };

    // cycleReport :: String -> [String]
    const cycleReport = xs => {
        const reps = repCycles(xs);
        return [xs, isNull(reps) ? '(n/a)' : last(reps)];
    };


    // GENERIC ----------------------------------------------------------------

    // compose :: (b -> c) -> (a -> b) -> (a -> c)
    const compose = (f, g) => x => f(g(x));

    // concat :: [[a]] -> [a] | [String] -> String
    const concat = xs => {
        if (xs.length > 0) {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        } else return [];
    };

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // inits :: [a] -> [[a]]
    // inits :: String -> [String]
    const inits = xs => [
            []
        ]
        .concat((typeof xs === 'string' ? xs.split('') : xs)
            .map((_, i, lst) => lst.slice(0, i + 1)));

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // last :: [a] -> a
    const last = xs => xs.length ? xs.slice(-1)[0] : undefined;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // isNull :: [a] -> Bool
    const isNull = xs => (xs instanceof Array) ? xs.length < 1 : undefined;

    // Integral a => a -> a -> a
    const quot = (n, m) => Math.floor(n / m);

    // replicate :: Int -> a -> [a]
    const replicate = (n, a) => {
        let v = [a],
            o = [];
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    };

    // tail :: [a] -> [a]
    const tail = xs => xs.length ? xs.slice(1) : undefined;

    // take :: Int -> [a] -> [a]
    const take = (n, xs) => xs.slice(0, n);

    // First n members of an infinite cycle of xs
    // takeCycle :: Int -> [a] -> [a]
    const takeCycle = (n, xs) => {
        const lng = xs.length;
        return concat((lng >= n ? xs : replicate(Math.ceil(n / lng), xs)))
            .slice(0, n);
    };

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');


    // TEST -------------------------------------------------------------------
    const samples = ["1001110011", "1110111011", "0010010010", "1010101010",
        "1111111111", "0100101101", "0100100", "101", "11", "00", "1"
    ];

    return unlines(cons('Longest cycle:\n',
        map(compose(curry(intercalate)(' -> '), cycleReport), samples)));
})();
