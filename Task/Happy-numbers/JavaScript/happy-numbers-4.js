(() => {

    // isHappy :: Int -> Bool
    const isHappy = n => {
        const f = n =>
            foldl(
                (a, x) => a + raise(read(x), 2), // ^2
                0,
                splitOn('', show(n))
            ),
            p = (s, n) => n === 1 ? (
                true
            ) : member(n, s) ? (
                false
            ) : p(
                insert(n, s), f(n)
            );
        return p(new Set(), n);
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // insert :: Ord a => a -> Set a -> Set a
    const insert = (e, s) => s.add(e);

    // member :: Ord a => a -> Set a -> Bool
    const member = (e, s) => s.has(e);

    // read :: Read a => String -> a
    const read = JSON.parse;

    // show :: a -> String
    const show = x => JSON.stringify(x);

    // splitOn :: String -> String -> [String]
    const splitOn = (cs, xs) => xs.split(cs);

    // raise :: Num -> Int -> Num
    const raise = (n, e) => Math.pow(n, e);

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // TEST -------------------------------------------------------------------
    return show(
        until(
            m => m.xs.length === 8,
            m => {
                const n = m.n;
                return {
                    n: n + 1,
                    xs: isHappy(n) ? m.xs.concat(n) : m.xs
                };
            }, {
                n: 1,
                xs: []
            }
        )
        .xs
    );
})();
