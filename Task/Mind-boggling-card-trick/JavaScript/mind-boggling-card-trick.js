(() => {
    'use strict';

    const main = () => {
        const
        // DEALT
        [rs_, bs_, discards] = threeStacks(
                map(n =>
                    even(n) ? (
                        'R'
                    ) : 'B', knuthShuffle(
                        enumFromTo(1, 52)
                    )
                )
            ),

            // SWAPPED
            nSwap = randomRInt(1, min(rs_.length, bs_.length)),
            [rs, bs] = exchange(nSwap, rs_, bs_),

            // CHECKED
            rrs = filter(c => 'R' === c, rs).join(''),
            bbs = filter(c => 'B' === c, bs).join('');
        return unlines([
            'Discarded: ' + discards.join(''),
            'Swapped: ' + nSwap,
            'Red pile: ' + rs.join(''),
            'Black pile: ' + bs.join(''),
            rrs + ' = Red cards in the red pile',
            bbs + ' = Black cards in the black pile',
            (rrs.length === bbs.length).toString()
        ]);
    };

    // THREE STACKS ---------------------------------------

    // threeStacks :: [Chars] -> ([Chars], [Chars], [Chars])
    const threeStacks = cards => {
        const go = ([rs, bs, ds]) => xs => {
            const lng = xs.length;
            return 0 < lng ? (
                1 < lng ? (() => {
                    const [x, y] = take(2, xs),
                        ds_ = cons(x, ds);
                    return (
                        'R' === x ? (
                            go([cons(y, rs), bs, ds_])
                        ) : go([rs, cons(y, bs), ds_])
                    )(drop(2, xs));
                })() : [rs, bs, ds_]
            ) : [rs, bs, ds];
        };
        return go([
            [],
            [],
            []
        ])(cards);
    };

    // exchange :: Int -> [a] -> [a] -> ([a], [a])
    const exchange = (n, xs, ys) => {
        const [xs_, ys_] = map(splitAt(n), [xs, ys]);
        return [
            fst(ys_).concat(snd(xs_)),
            fst(xs_).concat(snd(ys_))
        ];
    };

    // SHUFFLE --------------------------------------------

    // knuthShuffle :: [a] -> [a]
    const knuthShuffle = xs =>
        enumFromTo(0, xs.length - 1)
        .reduceRight((a, i) => {
            const iRand = randomRInt(0, i);
            return i !== iRand ? (
                swapped(i, iRand, a)
            ) : a;
        }, xs);

    // swapped :: Int -> Int -> [a] -> [a]
    const swapped = (iFrom, iTo, xs) =>
        xs.map(
            (x, i) => iFrom !== i ? (
                iTo !== i ? (
                    x
                ) : xs[iFrom]
            ) : xs[iTo]
        );

    // GENERIC FUNCTIONS ----------------------------------

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) =>
        Array.isArray(xs) ? (
            [x].concat(xs)
        ) : (x + xs);

    // drop :: Int -> [a] -> [a]
    // drop :: Int -> String -> String
    const drop = (n, xs) => xs.slice(n);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        m <= n ? iterateUntil(
            x => n <= x,
            x => 1 + x,
            m
        ) : [];

    // even :: Int -> Bool
    const even = n => 0 === n % 2;

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

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

    // min :: Ord a => a -> a -> a
    const min = (a, b) => b < a ? b : a;

    // randomRInt :: Int -> Int -> Int
    const randomRInt = (low, high) =>
        low + Math.floor(
            (Math.random() * ((high - low) + 1))
        );

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // splitAt :: Int -> [a] -> ([a],[a])
    const splitAt = n => xs => Tuple(xs.slice(0, n), xs.slice(n));

    // take :: Int -> [a] -> [a]
    const take = (n, xs) => xs.slice(0, n);

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // MAIN ---
    return main();
})();
