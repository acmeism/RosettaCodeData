(() => {
    'use strict';

    // OS-INDEPENDENT CURRIED FUNCTION --------------------

    // takeExtension :: Regex String -> FilePath -> String
    const takeExtension = charSet => fp => {
        const
            rgx = new RegExp('^[' + charSet + ']+$'),
            xs = fp.split('/').slice(-1)[0].split('.'),
            ext = 1 < xs.length ? (
                xs.slice(-1)[0]
            ) : '';
        return rgx.test(ext) ? (
            '.' + ext
        ) : '';
    };

    // OS-SPECIFIC SPECIALIZED FUNCTIONS ------------------

    // takePosixExtension :: FilePath -> String
    const takePosixExtension = takeExtension('A-Za-z0-9\_\-');

    // takeWindowsExtension :: FilePath -> String
    const takeWindowsExtension = takeExtension('A-Za-z0-9');


    // TEST -------------------------------------------
    // main :: IO()
    const main = () => {
        [
            ['Posix', takePosixExtension],
            ['Windows', takeWindowsExtension]
        ].forEach(
            ([osName, f]) => console.log(
                tabulated(
                    '\n\ntake' + osName +
                    'Extension :: FilePath -> String:\n',
                    x => x.toString(),
                    x => "'" + x.toString() + "'",
                    f,
                    [
                        "http://example.com/download.tar.gz",
                        "CharacterModel.3DS",
                        ".desktop",
                        "document",
                        "document.txt_backup",
                        "/etc/pam.d/login"
                    ]
                ),
                '\n'
            )
        )

    };

    // GENERIC FUNCTIONS FOR TESTING AND DISPLAY OF RESULTS

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
            i
        };

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (f, g) => x => f(g(x));

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

    // Map over lists or strings

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);


    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        0 < xs.length ? (
            xs.slice(1)
            .reduce((a, x) => 0 < f(x, a) ? x : a, xs[0])
        ) : undefined;

    // tabulated :: String -> (a -> String) ->
    //                        (b -> String) ->
    //           (a -> b) -> [a] -> String
    const tabulated = (s, xShow, fxShow, f, xs) => {
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        const
            ys = map(xShow, xs),
            w = maximumBy(comparing(x => x.length), ys).length,
            rows = zipWith(
                (a, b) => justifyRight(w, ' ', a) + ' -> ' + b,
                ys,
                map(compose(fxShow, f), xs)
            );
        return s + '\n' + unlines(rows);
    };

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
