(() => {
    'use strict';

    const main = () =>
        showPascal(take(7, pascal()));


    // pascal :: Generator [[Int]]
    const pascal = () =>
        iterate(
            xs => zipWith(
                plus,
                append([0], xs), append(xs, [0])
            ),
            [1]
        );

    // showPascal :: [[Int]] -> String
    const showPascal = xs => {
        const
            w = length(intercalate('   ', last(xs))),
            align = xs => center(w, ' ', intercalate('   ', xs));
        return unlines(map(align, xs));
    };


    // GENERIC FUNCTIONS ----------------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = (xs, ys) => xs.concat(ys);

    // Size of space -> filler Char -> String -> Centered String

    // center :: Int -> Char -> String -> String
    const center = (n, c, s) => {
        const
            qr = quotRem(n - s.length, 2),
            q = qr[0];
        return replicateString(q, c) +
            s + replicateString(q + qr[1], c);
    };

    // intercalate :: String -> [String] -> String
    const intercalate = (s, xs) =>
        xs.join(s);

    // iterate :: (a -> a) -> a -> Generator [a]
    function* iterate(f, x) {
        let v = x;
        while (true) {
            yield(v);
            v = f(v);
        }
    }

    // last :: [a] -> a
    const last = xs =>
        0 < xs.length ? xs.slice(-1)[0] : undefined;

    // Returns Infinity over objects without finite length
    // this enables zip and zipWith to choose the shorter
    // argument when one non-finite like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs => xs.length || Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // plus :: Num -> Num -> Num
    const plus = (a, b) => a + b;

    // quotRem :: Int -> Int -> (Int, Int)
    const quotRem = (m, n) =>
        Tuple(Math.floor(m / n), m % n);

    // replicateString :: Int -> String -> String
    const replicateString = (n, s) => s.repeat(n);

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

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // Use of `take` and `length` here allows zipping with non-finite lists
    // i.e. generators like cycle, repeat, iterate.

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const
            lng = Math.min(length(xs), length(ys)),
            as = take(lng, xs),
            bs = take(lng, ys);
        return Array.from({
            length: lng
        }, (_, i) => f(as[i], bs[i], i));
    };

    // MAIN ---
    return main();
})();
