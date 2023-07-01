(() => {
    'use strict';

    // Start sequence -> Number of terms -> terms

    // takeNFibs :: [Int] -> Int -> [Int]
    const takeNFibs = (xs, n) => {
        const go = (xs, n) =>
            0 < n && 0 < xs.length ? (
                cons(
                    head(xs),
                    go(
                        append(tail(xs), [sum(xs)]),
                        n - 1
                    )
                )
            ) : [];
        return go(xs, n);
    };

    // fibInit :: Int -> [Int]
    const fibInit = n =>
        cons(
            1,
            map(x => Math.pow(2, x),
                enumFromToInt(0, n - 2)
            )
        );

    // TEST -----------------------------------------------------------------
    const main = () => {
        const
            intTerms = 15,
            strTable = unlines(
                zipWith(
                    (s, n) =>
                    justifyLeft(12, ' ', s + 'nacci') + ' -> ' +
                    showJSON(
                        takeNFibs(fibInit(n), intTerms)
                    ),
                    words('fibo tribo tetra penta hexa hepta octo nona deca'),
                    enumFromToInt(2, 10)
                )
            );

        return justifyLeft(12, ' ', 'Lucas ') + ' -> ' +
            showJSON(takeNFibs([2, 1], intTerms)) + '\n' +
            strTable;
    };

    // GENERIC FUNCTIONS ----------------------------

    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = (xs, ys) => xs.concat(ys);

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) =>
        Array.isArray(xs) ? (
            [x].concat(xs)
        ) : (x + xs);

    // enumFromToInt :: Int -> Int -> [Int]
    const enumFromToInt = (m, n) =>
        m <= n ? iterateUntil(
            x => n <= x,
            x => 1 + x,
            m
        ) : [];

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        const vs = [x];
        let h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // justifyLeft :: Int -> Char -> String -> String
    const justifyLeft = (n, cFiller, s) =>
        n > s.length ? (
            s.padEnd(n, cFiller)
        ) : s;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // showJSON :: a -> String
    const showJSON = x => JSON.stringify(x);

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // words :: String -> [String]
    const words = s => s.split(/\s+/);

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) =>
        Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => f(xs[i], ys[i], i));

    // MAIN ---
    return main();
})();
