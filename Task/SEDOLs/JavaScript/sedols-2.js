(() => {
    'use strict';

    const main = () => {

        // checkSumLR :: String -> Either String String
        const checkSumLR = s => {
            const
                tpl = partitionEithers(map(charValueLR, s));
            return 0 < tpl[0].length ? (
                Left(s + ' -> ' + unwords(tpl[0]))
            ) : Right(rem(10 - rem(
                sum(zipWith(
                    (a, b) => a * b,
                    [1, 3, 1, 7, 3, 9],
                    tpl[1]
                )), 10
            ), 10).toString());
        };

        // charValue :: Char -> Either String Int
        const charValueLR = c =>
            isAlpha(c) ? (
                isUpper(c) ? (
                    elem(c, 'AEIOU') ? Left(
                        'Unexpected vowel: ' + c
                    ) : Right(ord(c) - ord('A') + 10)
                ) : Left('Unexpected lower case character: ' + c)
            ) : isDigit(c) ? Right(
                parseInt(c, 10)
            ) : Left('Unexpected character: ' + c);

        // TESTS ------------------------------------------
        const [problems, checks] = Array.from(
            partitionEithers(map(s => bindLR(
                    checkSumLR(s),
                    c => Right(s + c)
                ),
                [
                    "710889", "B0YBKJ", "406566",
                    "B0YBLH", "228276", "B0YBKL",
                    "557910", "B0YBKR", "585284",
                    "B0YBKT", "B00030"
                ]
            ))
        );
        return unlines(
            0 < problems.length ? (
                problems
            ) : checks
        );
    };

    // GENERIC FUNCTIONS ----------------------------

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

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
    const bindLR = (m, mf) =>
        undefined !== m.Left ? (
            m
        ) : mf(m.Right);

    // elem :: Eq a => a -> [a] -> Bool
    const elem = (x, xs) => xs.includes(x);

    // isAlpha :: Char -> Bool
    const isAlpha = c =>
        /[A-Za-z\u00C0-\u00FF]/.test(c);

    // isDigit :: Char -> Bool
    const isDigit = c => {
        const n = ord(c);
        return 48 <= n && 57 >= n;
    };

    // isUpper :: Char -> Bool
    const isUpper = c =>
        /[A-Z]/.test(c);

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

    // ord :: Char -> Int
    const ord = c => c.codePointAt(0);

    // partitionEithers :: [Either a b] -> ([a],[b])
    const partitionEithers = xs =>
        xs.reduce(
            (a, x) => undefined !== x.Left ? (
                Tuple(a[0].concat(x.Left), a[1])
            ) : Tuple(a[0], a[1].concat(x.Right)),
            Tuple([], [])
        );

    // rem :: Int -> Int -> Int
    const rem = (n, m) => n % m;

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

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

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

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
