(() => {
    'use strict';

    // mid3digits :: Int -> Either String String
    const mid3digits = n => {
        const
            m = abs(n),
            s = m.toString();
        return 100 > m ? (
            Left('Less than 3 digits')
        ) : even(length(s)) ? (
            Left('Even digit count')
        ) : Right(take(3, drop(quot(length(s) - 3, 2), s)));
    };

    // TEST -----------------------------------------------
    const main = () => {
        const
            xs = [
                123, 12345, 1234567, 987654321, 10001, -10001, -123,
                -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0
            ],
            w = maximum(map(x => x.toString().length, xs));
        return (
            unlines(map(
                n => justifyRight(w, ' ', n.toString()) + ' -> ' +
                either(
                    s => '(' + s + ')',
                    id,
                    mid3digits(n)
                ),
                xs
            ))
        );
    };

    // GENERIC FUNCTIONS ----------------------------------

    // Left :: a -> Either a b
    const Left = x => ({
        type: 'Either',
        Left: x
    });

    // Right :: b -> Either a b
    const Right = x => ({
        type: 'Either',
        Right: x
    });

    // abs :: Num -> Num
    const abs = Math.abs;

    // drop :: Int -> [a] -> [a]
    // drop :: Int -> Generator [a] -> Generator [a]
    // drop :: Int -> String -> String
    const drop = (n, xs) =>
        Infinity > length(xs) ? (
            xs.slice(n)
        ) : (take(n, xs), xs);

    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = (fl, fr, e) =>
        'Either' === e.type ? (
            undefined !== e.Left ? (
                fl(e.Left)
            ) : fr(e.Right)
        ) : undefined;

    // even :: Int -> Bool
    const even = n => 0 === n % 2;

    // foldl1 :: (a -> a -> a) -> [a] -> a
    const foldl1 = (f, xs) =>
        1 < xs.length ? xs.slice(1)
        .reduce(f, xs[0]) : xs[0];

    // id :: a -> a
    const id = x => x;

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = (n, cFiller, s) =>
        n > s.length ? (
            s.padStart(n, cFiller)
        ) : s;

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // maximum :: Ord a => [a] -> a
    const maximum = xs =>
        0 < xs.length ? (
            foldl1((a, x) => x > a ? x : a, xs)
        ) : undefined;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // quot :: Int -> Int -> Int
    const quot = (n, m) => Math.floor(n / m);

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

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // MAIN ---
    return main();
})();
